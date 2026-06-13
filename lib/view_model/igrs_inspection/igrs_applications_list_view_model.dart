import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/igrs/igrs_application_response_model.dart';
import 'package:lrsofficer/models/login/login_response.dart';
import 'package:lrsofficer/repository/igrs_repo/igrs_applications_list_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/internet_check_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';

class IGRSApplicationsListViewModel with ChangeNotifier {
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

  TextEditingController searchQueryController = TextEditingController();
  List<IGRSApplicationList>? searchedApplicationList;
  List<IGRSApplicationList>? applicationList;
  List<IGRSApplicationList>? get getApplicationList => searchedApplicationList;
  void runFilter({required String searchedVal}) {
    if (searchedVal.trim().isNotEmpty) {
      searchedApplicationList = applicationList
          ?.where((element) =>
              element.aPPLICATIONID
                      ?.toLowerCase()
                      .contains(searchedVal.toLowerCase()) ==
                  true ||
              element.mOBILENO?.contains(searchedVal) == true ||
              element.aPPLICANTNAME
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

  IGRSApplicationResponseModel? igrsApplicationListResponse;
  IGRSApplicationResponseModel? get getIGRSAppResponse =>
      igrsApplicationListResponse;
  Future<void> getIGRSApplications(BuildContext context) async {
    try {
      searchedApplicationList?.clear();
      applicationList?.clear();
      if (await internetCheck()) {
        await getResponseDetails();
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        final payload = DashboardPayload(
          empID: loginData.empID,
          tokenID: loginData.tokenID,
          userID: loginData.userID,
        );
        IGRSApplicationResponseModel? response =
            await IGRSApplicationsListRepository()
                .igrsApplicationApi(context, payload);
        if (response != null) {
          if (response.statusCode == ApiErrorCodes.success) {
            igrsApplicationListResponse = response;
            applicationList = response.iGRSApplicationList ?? [];
            searchedApplicationList = response.iGRSApplicationList ?? [];

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
}
