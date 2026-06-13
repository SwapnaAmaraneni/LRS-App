import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/cluster_application_details_request.dart';
import 'package:lrsofficer/models/cluster_application_details_response.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_request.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/models/resend_otp_payload.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';
import 'package:lrsofficer/repository/cluster_application_details_repo.dart';
import 'package:lrsofficer/repository/list_of_master_plan_zdp_repo.dart';
import 'package:lrsofficer/repository/resend_otp_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/utils/validators.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phase1LayoutApplicationDetailsViewModel with ChangeNotifier {
  List<ClusterApplicationDetails> clusterApplDetails = [];
  List<ListMasterPlansZDP> listMasterPlansZDP = [];
  List<UnSoldPlots> plotDetailsList = [];
  ListMasterPlansZDP? selectedListMasterPlansZDP;
  bool isLoaderVisible = false;
  String apiOTP = "";
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  bool isSroEdited = false;
  void setSroEdited(bool isEdited) {
    isSroEdited = isEdited;
    notifyListeners();
  }

  Future<void> getClusterApplDetails(BuildContext context) async {
    try {
      if (await internetCheck()) {
        clusterApplDetails.clear();

        setLoaderVisibleStatus(true);
        ClusterApplicationDetailsRequest request =
            ClusterApplicationDetailsRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        String applId =
            await sharedpref.readTheData(SharedPrefConstants.applicationNo);
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.applicationID = applId;
        request.isLayoutPlot = AppConstants.isLayoutPlot;
        if (!context.mounted) return;
        ClusterApplicationDetailsResponse? response =
            await ClusterwiseApplDetailsRepository()
                .clusterwiseApplDetailsRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          List<ClusterApplicationDetails>? applicationsCount =
              response.clusterApplicationDetails ?? [];
          if (applicationsCount.isNotEmpty) {
            clusterApplDetails = response.clusterApplicationDetails ?? [];
          }

          setLoaderVisibleStatus(false);
        } else if (response?.statusCode == ApiErrorCodes.badRequest) {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        } else if (response?.statusCode == ApiErrorCodes.sessionExpired) {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          );
        } else {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
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

  Future<void> getListOfMasterPlansZDPDetails(BuildContext context) async {
    try {
      if (await internetCheck()) {
        clusterApplDetails.clear();
        setLoaderVisibleStatus(true);
        ListOfMasterPlanZDPRequest request = ListOfMasterPlanZDPRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);

        if (!context.mounted) return;
        ListOfMasterPlanZDPResponse? response =
            await ListMasterPlanZDPRepository()
                .getListMasterPlanZDPDetails(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          List<ListMasterPlansZDP>? applicationsCount =
              response.listMasterPlansZDP ?? [];
          if (applicationsCount.isNotEmpty) {
            listMasterPlansZDP = response.listMasterPlansZDP ?? [];
            selectedListMasterPlansZDP = listMasterPlansZDP.first;
          }
          setLoaderVisibleStatus(false);
        } else if (response?.statusCode == ApiErrorCodes.badRequest) {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        } else if (response?.statusCode == ApiErrorCodes.sessionExpired) {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          );
        } else {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
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

  Future<void> navigateToUploadDocsScreen(
    BuildContext context, {
    required String applicationId,
    required String layoutName,
    required String masterplanZdp,
    required String sroCode,
    required String layoutNmae,
    required ClusterApplicationDetails applicationDetails,
  }) async {
    if (isSroEdited == true && sroCode.length != 4) {
      ValidationIoSAlert()
          .showAlert(context, description: "Please enter valid SRO code.");
    } else if (selectedUnsoldPlotDetails == '' ||
        selectedUnsoldPlotDetails == null) {
      ValidationIoSAlert().showAlert(context,
          description:
              "Please select do you want to enter Unsold plot Details");
    } else if (totalNoOfPlotsController.text.isEmpty) {
      ValidationIoSAlert()
          .showAlert(context, description: "Please enter total no of plots");
    } else if (soldPlotsController.text.isEmpty) {
      ValidationIoSAlert()
          .showAlert(context, description: "Please enter sold plots");
    } else if (selectedUnsoldPlotDetails == 'N' &&
        totalUnsoldPlotAreaController.text.isEmpty) {
      ValidationIoSAlert().showAlert(context,
          description: "Please enter total unsold plot area");
    } else if (masterplanZdp.isEmpty ||
        masterplanZdp.toLowerCase() == "please select") {
      ValidationIoSAlert().showAlert(context,
          description: "Please select land use as per Master Plan/ZDP");
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefConstants.applicationNo, applicationId);
      await prefs.setString(SharedPrefConstants.layoutNameKey, layoutName);
/*       await prefs.setString(SharedPrefConstants.plotNoKey, plotNo);
      await prefs.setString(SharedPrefConstants.areaExtentKey, areaExtent);
      await prefs.setString(
          SharedPrefConstants.plotAreaExtentKey, plotAreaExtent);
      await prefs.setString(
          SharedPrefConstants.roadAreaExtentKey, roadAreaExtent); */
      await prefs.setString(SharedPrefConstants.selectedUnsoldPlotKey,
          selectedUnsoldPlotDetails ?? "");
      await prefs.setString(
          SharedPrefConstants.totalNoOfPlotsKey, totalNoOfPlotsController.text);
      await prefs.setString(
          SharedPrefConstants.soldPlotsKey, soldPlotsController.text);
      await prefs.setString(
          SharedPrefConstants.unsoldPlotsKey, unsoldPlotsController.text);
      await prefs.setString(SharedPrefConstants.totalunsoldPlotAreakey,
          totalUnsoldPlotAreaController.text);
      await prefs.setString(
          SharedPrefConstants.masterplanZdpKey, masterplanZdp);
      await prefs.setString(SharedPrefConstants.srdpRdpKey, sroCode);
      await prefs.setString(SharedPrefConstants.mvRate2020Key,
          applicationDetails.mVRATE2020 ?? "");
      await prefs.setString(SharedPrefConstants.mvEditFlagKey,
          applicationDetails.mvEditFlag ?? "");
      await prefs.setString(SharedPrefConstants.mvRateDocumentKey,
          applicationDetails.mVRATEDOCUMET ?? "");
      AppConstants.maxCoordinatesCount =
          applicationDetails.maxCoordinatesCount ?? "";
      AppConstants.minCoordinatesCount =
          applicationDetails.minCoordinatesCount ?? "";
      // await prefs.setString(SharedPrefConstants.latitudeKey, latitude);
      // await prefs.setString(SharedPrefConstants.longitudeKey, longitude);
      if (!context.mounted) return;
      if (AppConstants.isLayoutPlot == "L" &&
          selectedUnsoldPlotDetails == 'Y' &&
          unsoldPlotsController.text != "0") {
        Navigator.pushNamed(context, AppRoutes.phase1AddUnsoldPlots);
      } else if (AppConstants.isLayoutPlot == "L" &&
          selectedUnsoldPlotDetails == 'Y' &&
          unsoldPlotsController.text == "0") {
        ValidationIoSAlert()
            .showAlert(context, description: "unable to process");
      } else {
        Navigator.pushNamed(context, AppRoutes.phase1UploadPlotDetails);
      }
    }
  }

  void changeMasterPlanZDP(ListMasterPlansZDP? newValue) {
    selectedListMasterPlansZDP = newValue;
    notifyListeners();
  }

  bool validateNewMobileNo(
      TextEditingController mobileNoController, BuildContext context) {
    String mobileNo = mobileNoController.text.trim();
    if (mobileNo.isEmpty) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "Enter New mobile number",
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
      return false;
    } else if (mobileNo.length < 10 || !Validators().validateNumber(mobileNo)) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "Enter New Valid mobile number",
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
      return false;
    }
    return true;
  }

  void removePlotDetails(int index) {
    plotDetailsList.removeAt(index);
    notifyListeners();
  }

  void addPlotDetails() {
    plotDetailsList.add(UnSoldPlots(
        plotAreaExtent: plotAreaExtentController.text,
        plotNo: plotNoController.text));
    notifyListeners();
  }

  Future<void> validateOTp(BuildContext context, BuildContext dialogContext,
      String otpText, String newMobileNo) async {
    AppLogger().logDebug("sent otp:::::::::::: $apiOTP");
    AppLogger().logDebug("controller otp:::::::::::: $otpText");
    if (!context.mounted) return;
    if (otpText.isEmpty || otpText.length < 4) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "enterOTP".tr(),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    } else if (apiOTP == otpText) {
      try {
        // otpController.clear();
        final updateMobileProvider =
            Provider.of<UpdateMobileNoViewModel>(context, listen: false);
        apiOTP = "";
        notifyListeners();
        SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: "OTP Verification done",
            onPressed: () async {
              Navigator.pop(dialogContext);
              Navigator.pop(context);

              await updateMobileProvider.updatePhase1MobileApi(
                context,
                clusterApplDetails[0].oWNERMOBILENUMBER ?? "",
                newMobileNo.trim(),
                clusterApplDetails[0].aPPLICATIONID ?? "",
              );
            });
      } on DioException catch (dioError) {
        setLoaderVisibleStatus(false);
        if (!context.mounted) return;
        ErrorHandlingUtils.handleError(dioError, context);
      } catch (error) {
        setLoaderVisibleStatus(false);
        if (!context.mounted) return;
        String errorMessage = ErrorHandlingUtils.handleError(error, context);
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      }
    } else {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "incorrectOTP".tr(),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    }
  }

  final _resendRepo = ResendOTPRepository();
  Future<void> getResendOtp(
    BuildContext context,
    String mobileNo,
  ) async {
    try {
      final payload = ResendOTPPayload(
        mobileNo: mobileNo,
      );

      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        final response = await _resendRepo.getResendOTPRepo(context, payload);
        setLoaderVisibleStatus(false);
        if (response != null) {
          if (response.statusCode == ApiErrorCodes.success) {
            apiOTP = response.oTP ?? "";
            notifyListeners();
          } else if (response.statusCode == ApiErrorCodes.badRequest) {
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg.toString(),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          } else {
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
        setLoaderVisibleStatus(false);
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
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

  String? selectedUnsoldPlotDetails;
  TextEditingController totalNoOfPlotsController = TextEditingController();
  TextEditingController soldPlotsController = TextEditingController();
  TextEditingController unsoldPlotsController = TextEditingController();
  TextEditingController totalUnsoldPlotAreaController = TextEditingController();
  TextEditingController plotNoController = TextEditingController();
  TextEditingController plotAreaExtentController = TextEditingController();

  void changeUnsoldPlotDetails(String? value) {
    totalUnsoldPlotAreaController.clear();
    selectedUnsoldPlotDetails = value;
    notifyListeners();
  }

  Future<void> submitAndSave(BuildContext context) async {
    num totalArea = 0;
    for (var element in plotDetailsList) {
      final area = num.tryParse(element.plotAreaExtent ?? "0") ?? 0;
      totalArea = totalArea + area;
    }

    String plotListStr = jsonEncode(plotDetailsList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        SharedPrefConstants.totalunsoldPlotAreakey, totalArea.toString());
    await prefs.setString(SharedPrefConstants.unsoldPlotListKey, plotListStr);
    if (!context.mounted) return;
    Navigator.pushNamed(context, AppRoutes.phase1UploadPlotDetails);
  }
}
