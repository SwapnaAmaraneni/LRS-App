import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/cluster_application_details_request.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_request.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/models/resend_otp_payload.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart';
import 'package:lrsofficer/repository/list_of_master_plan_zdp_repo.dart';
import 'package:lrsofficer/repository/new_flow/fifp_application_details_repository.dart';
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

class FifpApplicationDetailsViewModel extends ChangeNotifier {
  List<ApplicationDetails> clusterApplDetails = [];
  List<ListMasterPlansZDP> listMasterPlansZDP = [];
  ListMasterPlansZDP? selectedListMasterPlansZDP;
  bool isLoaderVisible = false;
  String apiOTP = "";

  // Declare controllers as final and late
  TextEditingController layoutNameController = TextEditingController();
  TextEditingController layoutOwnerController = TextEditingController();
  TextEditingController plotNoController = TextEditingController();
  TextEditingController plotAreaExtentController = TextEditingController();
  TextEditingController roadEffectedAreaExtentController =
      TextEditingController();
  TextEditingController netPlotAreaExtentController = TextEditingController();
  TextEditingController villageNameController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController surveyNoController = TextEditingController();
  TextEditingController newMobileNoController = TextEditingController();
  List<TextEditingController> officerApprovalControllers = [];
  List<TextEditingController> createdByControllers = [];
  List<TextEditingController> notesAddedControllers = [];
  TextEditingController l1RemarksController = TextEditingController();
  TextEditingController l2RemarksController = TextEditingController();
  TextEditingController l3RemarksController = TextEditingController();
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

  void clearAllControllers() {
    layoutNameController.clear();
    layoutOwnerController.clear();
    plotNoController.clear();
    plotAreaExtentController.clear();
    roadEffectedAreaExtentController.clear();
    netPlotAreaExtentController.clear();
    villageNameController.clear();
    localityController.clear();
    surveyNoController.clear();
    newMobileNoController.clear();
    l1RemarksController.clear();
    l2RemarksController.clear();
    l3RemarksController.clear();
    // Clear all approval, created by, and notes controllers
    for (var controller in officerApprovalControllers) {
      controller.clear();
    }
    for (var controller in createdByControllers) {
      controller.clear();
    }
    for (var controller in notesAddedControllers) {
      controller.clear();
    }
    // Remove all controllers from lists to prevent memory leaks
    officerApprovalControllers.clear();
    createdByControllers.clear();
    notesAddedControllers.clear();
    // Reset other states if needed
    isSroEdited = false;
    listMasterPlansZDP.clear();
    selectedListMasterPlansZDP = null;
    apiOTP = "";
    clusterApplDetails.clear();
    notifyListeners();
  }

  Future<void> getClusterApplDetails(BuildContext context) async {
    if (await internetCheck()) {
      clusterApplDetails.clear();

      setLoaderVisibleStatus(true);
      ClusterApplicationDetailsRequest request =
          ClusterApplicationDetailsRequest();
      LocalStoreHelper sharedpref = LocalStoreHelper();
      String applId =
          await sharedpref.readTheData(SharedPrefConstants.applicationNo);
      request.userID = await sharedpref.readTheData(SharedPrefConstants.userID);
      request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
      request.tokenID = await sharedpref.readTheData(SharedPrefConstants.token);
      request.applicationID = applId;
      request.isLayoutPlot = AppConstants.isLayoutPlot;
      if (!context.mounted) return;
      SavedApplicationDetailsResponse? response =
          await FifpApplicationDetailsRepository()
              .applicationDetailsApi(context, request);
      if (response != null && response.statusCode == ApiErrorCodes.success) {
        List<ApplicationDetails>? applicationsCount =
            response.applications ?? [];
        if (applicationsCount.isNotEmpty) {
          clusterApplDetails = response.applications ?? [];
          if (!kReleaseMode) {
            debugPrint(
                "Officer_list_type:: ${response.applications?[0].officersComments.runtimeType}");
          }
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
  }

  Future<void> getListOfMasterPlansZDPDetails(BuildContext context) async {
    if (await internetCheck()) {
      clusterApplDetails.clear();
      setLoaderVisibleStatus(true);
      ListOfMasterPlanZDPRequest request = ListOfMasterPlanZDPRequest();
      LocalStoreHelper sharedpref = LocalStoreHelper();
      request.userID = await sharedpref.readTheData(SharedPrefConstants.userID);
      request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
      request.tokenID = await sharedpref.readTheData(SharedPrefConstants.token);
      request.isLayoutPlot = AppConstants.isLayoutPlot;

      if (!context.mounted) return;
      ListOfMasterPlanZDPResponse? response =
          await ListMasterPlanZDPRepository()
              .getListMasterPlanZDPDetails(context, request);
      if (response != null && response.statusCode == ApiErrorCodes.success) {
        List<ListMasterPlansZDP>? applicationsCount =
            response.listMasterPlansZDP ?? [];
        if (applicationsCount.isNotEmpty) {
          listMasterPlansZDP = response.listMasterPlansZDP ?? [];
          if (selectedListMasterPlansZDP == null) {
            selectedListMasterPlansZDP = listMasterPlansZDP.first;
          } else {
            selectedListMasterPlansZDP = listMasterPlansZDP.firstWhere(
              (element) =>
                  element.landUseId == selectedListMasterPlansZDP?.landUseId,
              orElse: () => listMasterPlansZDP.first,
            );
          }
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
  }

  Future<void> navigateToUploadDocsScreen(
    BuildContext context, {
    required String applicationId,
    required String layoutName,
    required String plotNo,
    required String areaExtent,
    required String plotAreaExtent,
    required String roadAreaExtent,
    required String masterplanZdp,
    required String sroCode,
    required String layoutNmae,
    required ApplicationDetails applicationDetails,
  }) async {
    if (plotNo.isEmpty || plotNo == "") {
      ValidationIoSAlert()
          .showAlert(context, description: "Please enter plot no.");
    } else if (plotNo == "0") {
      ValidationIoSAlert()
          .showAlert(context, description: "Please enter valid plot no.");
    } /* else if (plotAreaExtent.isEmpty || plotAreaExtent == "") {
      ValidationIoSAlert()
          .showAlert(context, description: "Please enter plot area");
    } else if (roadAreaExtent.isEmpty) {
      ValidationIoSAlert()
          .showAlert(context, description: "Please enter road effected area");
    }  */
    else if (masterplanZdp.isEmpty ||
        masterplanZdp.toLowerCase() == "please select") {
      ValidationIoSAlert().showAlert(context,
          description: "Please select land use as per Master Plan/ZDP");
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefConstants.applicationNo, applicationId);
      await prefs.setString(SharedPrefConstants.layoutNameKey, layoutName);
      await prefs.setString(SharedPrefConstants.plotNoKey, plotNo);
      await prefs.setString(SharedPrefConstants.areaExtentKey, areaExtent);
      await prefs.setString(
          SharedPrefConstants.plotAreaExtentKey, plotAreaExtent);
      await prefs.setString(
          SharedPrefConstants.roadAreaExtentKey, roadAreaExtent);
      await prefs.setString(
          SharedPrefConstants.masterplanZdpKey, masterplanZdp);
      await prefs.setString(SharedPrefConstants.srdpRdpKey, sroCode);
      await prefs.setString(SharedPrefConstants.layoutNameKey, layoutNmae);
      await prefs.setString(SharedPrefConstants.mvRate2020Key,
          applicationDetails.mVRATE2020 ?? "");
      await prefs.setString(SharedPrefConstants.mvEditFlagKey,
          applicationDetails.mvEditFlag ?? "");
      await prefs.setString(SharedPrefConstants.mvRateDocumentKey,
          applicationDetails.mVRATEDOCUMET ?? "");
      AppConstants.maxCoordinatesCount =
          applicationDetails.maxCoordinatesCount ?? "";
      AppConstants.minCoordinatesCount =
          applicationDetails.maxCoordinatesCount ?? "";
      // await prefs.setString(SharedPrefConstants.latitudeKey, latitude);
      // await prefs.setString(SharedPrefConstants.longitudeKey, longitude);
      if (!context.mounted) return;
      Navigator.pushNamed(context, AppRoutes.fifpUploadPlotDetails);
    }
  }

  void changeMasterPlanZDP(ListMasterPlansZDP? phase2Value) {
    selectedListMasterPlansZDP = phase2Value;
    notifyListeners();
  }

  bool validateNewMobileNo(
      TextEditingController mobileNoController, BuildContext context) {
    String mobileNo = mobileNoController.text.trim();
    if (mobileNo.isEmpty) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "Enter mobile number",
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
      return false;
    } else if (mobileNo.length < 10 || !Validators().validateNumber(mobileNo)) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "Enter Valid mobile number",
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
      return false;
    }
    return true;
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

            await updateMobileProvider.updateFifpMobile(
              context,
              clusterApplDetails[0].oWNERMOBILENUMBER ?? "",
              newMobileNo.trim(),
              clusterApplDetails[0].aPPLICATIONID ?? "",
            );
          });
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
    final payload = ResendOTPPayload(
      mobileNo: mobileNo,
    );
    try {
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

  Future<void> revenueNavigation({
    required String applicationNo,
    required String layoutName,
    required String plotNo,
    required String netPlotAreaExtent,
    required String plotAreaExtent,
    required String roadEffectedAreaExtent,
    required String zdp,
    required String layoutSelectedDoc,
    required String ownershipSelectedDoc,
    required String ecSelectedDoc,
    required String captureLocScreenshot,
    required String plot1Img,
    required String plot2Img,
    required String plot3Img,
    required String plot4Img,
    required String gisCoordinates,
    required String gisCoordinatesCount,
    required String conversionCharges,
    required String mVRATE2020,
    required String mVRATEDOCUMET,
    required String srdpRdp,
    required String rc,
    required String vlt,
    required String plotOpenspace,
    required String trc,
    required String sroCode,
    required String saleDeedNo,
    required String saleDeedYear,
    required String latitude,
    required String longitude,
    required BuildContext context,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefConstants.applicationNo, applicationNo);
    await prefs.setString(SharedPrefConstants.layoutNameKey, layoutName);
    await prefs.setString(SharedPrefConstants.plotNoKey, plotNo);
    await prefs.setString(SharedPrefConstants.areaExtentKey, netPlotAreaExtent);
    await prefs.setString(
        SharedPrefConstants.plotAreaExtentKey, plotAreaExtent);
    await prefs.setString(
        SharedPrefConstants.roadAreaExtentKey, roadEffectedAreaExtent);
    await prefs.setString(SharedPrefConstants.masterplanZdpKey, zdp);
    await prefs.setString(SharedPrefConstants.layoutSelectedDocKey, "");
    await prefs.setString(SharedPrefConstants.ownershipSelectedDocKey, "");
    await prefs.setString(SharedPrefConstants.ecSelectedDocKey, "");
    await prefs.setString(SharedPrefConstants.plot5ImgCaptureLocScreenshot, "");
    await prefs.setString(SharedPrefConstants.plot1Img, "");
    await prefs.setString(SharedPrefConstants.plot2Img, "");
    await prefs.setString(SharedPrefConstants.plot3Img, "");
    await prefs.setString(SharedPrefConstants.plot4ImgMasterPlanExt, "");
    await prefs.setString(SharedPrefConstants.latitudeKey, latitude);
    await prefs.setString(SharedPrefConstants.longitudeKey, longitude);
    await LocalStoreHelper().writeData(SharedPrefConstants.sroCode, sroCode);
    await LocalStoreHelper()
        .writeData(SharedPrefConstants.saleDeedNo, saleDeedNo);
    await LocalStoreHelper()
        .writeData(SharedPrefConstants.saleDeedYear, saleDeedYear);

    //payment
    await prefs.setString(SharedPrefConstants.srdpRdpKey, srdpRdp);

    await prefs.setString(
        SharedPrefConstants.conversionChargesKey, conversionCharges);
    await prefs.setString(SharedPrefConstants.mvRate2020Key, mVRATE2020);
    await prefs.setString(SharedPrefConstants.mvRateDocumentKey, mVRATEDOCUMET);
    await prefs.setString(SharedPrefConstants.rcKey, rc);
    await prefs.setString(SharedPrefConstants.vltKey, vlt);

    await prefs.setString(SharedPrefConstants.plotOpenspaceKey, plotOpenspace);
    await prefs.setString(SharedPrefConstants.trcKey, trc);
    if (!context.mounted) return;
    Navigator.pushNamed(context, AppRoutes.fifpCheckList);
  }
}
