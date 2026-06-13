import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/login/login_response.dart';
import 'package:lrsofficer/models/new_flow/fifp_applications_list_response.dart';
import 'package:lrsofficer/models/new_flow/remarks_submit_payload.dart';
import 'package:lrsofficer/models/new_flow/remarks_submit_response.dart';
import 'package:lrsofficer/repository/new_flow/fee_initimated_unpaid_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/internet_check_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/get_device_id.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class FeeInitimatedUnpaidViewModel with ChangeNotifier {
  LoginDtls loginData = LoginDtls();
  Future<void> getResponseDetails() async {
    final userType =
        await LocalStoreHelper().readTheData(SharedPrefConstants.userType);
    AppConstants.userType = userType;

    final loginDetails =
        await LocalStoreHelper().readTheData(SharedPrefConstants.loginResponse);
    final data = jsonDecode(loginDetails);
    loginData = LoginDtls.fromJson(data);
    notifyListeners();
  }

  Future<void> getRemarksSubmitVM(
      BuildContext context, String remarks, String appID) async {
    try {
      if (await internetCheck()) {
        await getResponseDetails();
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        final payload = SubmitFeeIntimatedRemarksPayload(
            userID: loginData.userID,
            empID: loginData.empID,
            tokenID: loginData.tokenID,
            applicationID: appID,
            l1REMARKS: remarks,
            iPAddress: await GetDeviceId().getIpAddress());
        if (!context.mounted) return;
        SubmitFeeIntimatedRemarksResponse? response =
            await FeeInitimatedUnpaidRepository()
                .remarksSubmitRepo(context, payload);
        final jsonPayload = jsonEncode(payload.toJson());
        AppLogger().logDebug("SubmitFeeIntimatedRemarksResponse  $jsonPayload");
        if (response != null) {
          if (response.statusCode == ApiErrorCodes.success) {
            if (!kReleaseMode) {
              debugPrint("dashboardInfo::::::::::: ${response.toJson()}");
            }
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            SuccessCustomCupertinoAlert().showAlert(
              context: context,
              title: response.statusMsg.toString(),
              onPressed: () async {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(AppRoutes.dashboard),
                );
              },
            );
          } else if (response.statusCode == ApiErrorCodes.badRequest) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg.toString(),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          } else if (response.statusCode == ApiErrorCodes.sessionExpired) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg.toString(),
              onPressed: () async {
                await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            );
          } else {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg ?? "",
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          }
        } else {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: "somethingWentWrong".tr(),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        InternetCheckAlert().showAlert(context);
      }
    } on DioException catch (dioError) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } finally {
      setLoaderVisibleStatus(false);
    }
  }

  TextEditingController searchQueryController = TextEditingController();
  List<FifpApplications>? searchedApplicationList;
  List<FifpApplications>? applicationList;
  List<FifpApplications>? get getApplicationList => searchedApplicationList;
  void runFilter({required String searchedVal}) {
    if (searchedVal.trim().isNotEmpty) {
      searchedApplicationList = applicationList
          ?.where((element) =>
              element.aPPLICATIONID
                      ?.toLowerCase()
                      .contains(searchedVal.toLowerCase()) ==
                  true ||
              element.oWNERMOBILENUMBER?.contains(searchedVal) == true ||
              element.lAYOUTOWNERNAME
                      ?.toLowerCase()
                      .contains(searchedVal.toLowerCase()) ==
                  true)
          .toList();
    } else {
      searchedApplicationList = applicationList;
    }

    notifyListeners();
  }

  void resetApplications() {
    searchedApplicationList = applicationList;
    searchQueryController.clear();
    notifyListeners();
  }

  FifpApplicationsListResponse? feePaidAppResponse;
  FifpApplicationsListResponse? get getFeePaidAppResponse => feePaidAppResponse;
  Future<void> getFeePaidApplications(BuildContext context) async {
    try {
      applicationList?.clear();
      searchedApplicationList?.clear();
      if (await internetCheck()) {
        await getResponseDetails();
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        final payload = DashboardPayload(
          empID: loginData.empID,
          tokenID: loginData.tokenID,
          userID: loginData.userID,
        );
        FifpApplicationsListResponse? response =
            await FeeInitimatedUnpaidRepository()
                .feeIntimatedUnpaidApi(context, payload);
        if (response != null) {
          if (response.statusCode == ApiErrorCodes.success) {
            feePaidAppResponse = response;
            applicationList = response.fifpApplications;
            searchedApplicationList = applicationList;
            if (!kReleaseMode) {
              debugPrint("dashboardInfo::::::::::: ${response.toJson()}");
            }
            setLoaderVisibleStatus(false);
          } else if (response.statusCode == ApiErrorCodes.badRequest) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg.toString(),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          } else if (response.statusCode == ApiErrorCodes.sessionExpired) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg.toString(),
              onPressed: () async {
                await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            );
          } else {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg ?? "",
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          }
        } else {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: "somethingWentWrong".tr(),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        InternetCheckAlert().showAlert(context);
      }
    } on DioException catch (dioError) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } finally {
      setLoaderVisibleStatus(false);
    }
  }

  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> downloadPdf(BuildContext context, String? pdfUrl) async {
    try {
      setLoaderVisibleStatus(true);
      if (pdfUrl == null || pdfUrl.isEmpty) {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert()
            .showAlert(context, message: "Invalid file URL.");
        setLoaderVisibleStatus(false);

        return;
      }
      String fileName = pdfUrl.split('/').last.replaceAll(r'\', '/');
      // Get storage directory
      Directory? externalDir = await _getDownloadDirectory();
      if (externalDir == null) {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert()
            .showAlert(context, message: "Unable to access storage directory.");
        setLoaderVisibleStatus(false);
        return;
      }

      // Request storage permission (Android only)
      bool permissionGranted = await _requestStoragePermission();
      if (!permissionGranted) {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(context,
            message:
                "Please allow storage permission to download the document.");
        setLoaderVisibleStatus(false);
        return;
      }

      // Generate a unique file path
      String filePath = await _getUniqueFilePath(externalDir.path, fileName);

      // Download file using Dio
      Dio dio = Dio();
      Response response = await dio.download(pdfUrl, filePath);

      if (response.statusCode == 200) {
        if (!context.mounted) return;

        // Share file (iOS only)
        if (Platform.isIOS) {
          SharePlus.instance.share(ShareParams(files: [XFile(filePath)])).then(
            (value) {
              AppLogger().logInfo("Download msg:: $value");
              setLoaderVisibleStatus(false);
              if (value.status == ShareResultStatus.success) {
                if (!context.mounted) return;
                SuccessCustomCupertinoAlert().showAlert(
                    context: context,
                    title: "Document downloaded successfully",
                    onPressed: () {
                      Navigator.pop(context);
                    });
              } else {
                if (!context.mounted) return;
                ErrorCustomCupertinoAlert()
                    .showAlert(context, message: "Failed to download file.");
                setLoaderVisibleStatus(false);
              }
            },
          );
          setLoaderVisibleStatus(false);
        } else {
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: "Document downloaded successfully into:\n$filePath",
            onPressed: () {
              Navigator.pop(context);
            },
          );
          setLoaderVisibleStatus(false);
        }
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert()
            .showAlert(context, message: "Failed to download file.");
        setLoaderVisibleStatus(false);
      }
    } catch (e) {
      if (!context.mounted) return;
      ErrorCustomCupertinoAlert().showAlert(context,
          message: "Error downloading document: ${e.toString()}");
      setLoaderVisibleStatus(false);
    }
  }

// Get download directory
  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      return Directory('/storage/emulated/0/Download');
    }
  }

// Request storage permission
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;
      PermissionStatus status = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
      return status.isGranted;
    }
    return true; // iOS doesn't require storage permission
  }

// Generate a unique file name if needed
  Future<String> _getUniqueFilePath(String directory, String fileName) async {
    String filePath = '$directory/$fileName';
    int count = 1;
    while (await File(filePath).exists()) {
      final name = fileName.split('.').first;
      final extension = fileName.split('.').last;
      filePath = '$directory/$name($count).$extension';
      count++;
    }
    return filePath;
  }
}
