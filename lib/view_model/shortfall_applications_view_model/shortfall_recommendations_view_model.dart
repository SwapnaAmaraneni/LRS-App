import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/check_details_response.dart';
import 'package:lrsofficer/models/recommendation_details_request.dart';
import 'package:lrsofficer/models/recommendation_details_response.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_response.dart';
import 'package:lrsofficer/repository/final_submit_repository.dart';
import 'package:lrsofficer/repository/recommendations_repository.dart';
import 'package:lrsofficer/repository/shortfall_applicatuions_repo/shortfall_final_submit_repo.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/internet_check_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/base64.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/get_device_id.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/plots_layouts/add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_application_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_check_list_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_layout_app_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_upload_plot_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortfallRecommendationsModel with ChangeNotifier {
  List<RecommendationsListMasterPlans> recommendationListMasterPlans = [];
  RecommendationsListMasterPlans? selectedRecommendationValue;
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  List<ListMasterPlans> questionsChecklist = [];
  
  bool isInitialized = false;
  TextEditingController remarksController = TextEditingController();

  void clearAll() {
    isInitialized = false;
    remarksController.clear();
    recommendationListMasterPlans.clear();
    selectedRecommendationValue = null;
    questionsChecklist.clear();
    notifyListeners();
  }

  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> getRecommendationsDetails(BuildContext context) async {
    try {
      if (await internetCheck()) {
        recommendationListMasterPlans.clear();
        setLoaderVisibleStatus(true);
        RecommendationDetailsRequest request = RecommendationDetailsRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        RecommendationDetailsResponse? response =
            await RecommendationsRepository()
                .getRecommendationDetails(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          List<RecommendationsListMasterPlans> listmasterPlans =
              response.listMasterPlans ?? [];
          if (listmasterPlans.isNotEmpty) {
            recommendationListMasterPlans = response.listMasterPlans ?? [];
            selectedRecommendationValue = recommendationListMasterPlans[0];
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

  void setDropdownValue(RecommendationsListMasterPlans? newValue) {
    selectedRecommendationValue = newValue;
    notifyListeners();
  }

  Future<void> finalSubmitMethod(BuildContext context, String? remarks) async {
    try {
      FocusScope.of(context).unfocus();
      //final submit validations
      //plot details upload

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final checklistQues = await getQuesCheckListFromSharedPreferences(
          SharedPrefConstants.questionsChecklist);

      final layoutDocVal =
          prefs.getString(SharedPrefConstants.layoutDocumentradioVal);
      final ownershipDocVal =
          prefs.getString(SharedPrefConstants.ownershipDocumetRadioVal);
      final ecDocVal = prefs.getString(SharedPrefConstants.ecDocumentRadioVal);

      // AppLogger().logDebug("layoutDocVal $layoutDocVal");
      // AppLogger().logDebug("ownershipDocVal $ownershipDocVal");
      // AppLogger().logDebug("ecDocVal $ecDocVal");

      String? layoutSelectedDoc =
          prefs.getString(SharedPrefConstants.layoutSelectedDocKey);
      String? ownershipSelectedDoc =
          prefs.getString(SharedPrefConstants.ownershipSelectedDocKey);
      String? ecSelectedDoc =
          prefs.getString(SharedPrefConstants.ecSelectedDocKey);

      AppLogger().logDebug("layoutSelectedDoc $layoutSelectedDoc");

      // Retrieving values for checklist
      String? checkListString =
          prefs.getString(SharedPrefConstants.checkListKey);
      final List<dynamic> checkListJson = jsonDecode(checkListString!);
      final List<CHECKLIST> checkList = checkListJson
          .map((checkListMap) => CHECKLIST.fromJson(checkListMap))
          .toList();
      AppLogger().logDebug("checkListANSWW2 ::: ${jsonEncode(checkList)}");

      for (CHECKLIST item in checkList) {
        if (!kReleaseMode) debugPrint("docPath ${item.docment}");
        if (item.docment != null) {
          item.docment = (item.docment ?? "").startsWith("http")
              ? item.docment
              : (item.docment ?? "").contains(".pdf")
                  ? convertToBase64(item.docment)
                  : "";
        }
      }

// payment validations
      String? conversionCharges =
          prefs.getString(SharedPrefConstants.conversionChargesKey);
      String? mvRate2020 = prefs.getString(SharedPrefConstants.mvRate2020Key);
      String? mvRateDocument =
          prefs.getString(SharedPrefConstants.mvRateDocumentKey);

      bool? isCalcutae = prefs.getBool(SharedPrefConstants.isCalculate);
      // Retrieving values for Application Details
      String? applicationId =
          prefs.getString(SharedPrefConstants.applicationNo);
      String? layoutName = prefs.getString(SharedPrefConstants.layoutNameKey);
      String? plotNo = prefs.getString(SharedPrefConstants.plotNoKey);
      String? areaExtent = prefs.getString(SharedPrefConstants.areaExtentKey);
      String? plotAreaExtent =
          prefs.getString(SharedPrefConstants.plotAreaExtentKey);
      String? roadAreaExtent =
          prefs.getString(SharedPrefConstants.roadAreaExtentKey);
      String? masterplanZdp =
          prefs.getString(SharedPrefConstants.masterplanZdpKey);
      AppLogger().logDebug("isCalcutae$isCalcutae");
      if (AppConstants.userType.toLowerCase() == "tp") {
        if ((plotNo ?? "").isEmpty || plotNo == "") {
          if (!context.mounted) return;
          ValidationIoSAlert()
              .showAlert(context, description: "Please enter plot no.");
        } else if (plotNo == "0") {
          if (!context.mounted) return;
          ValidationIoSAlert()
              .showAlert(context, description: "Please enter valid plot no.");
        } else if ((plotAreaExtent ?? "").isEmpty || plotAreaExtent == "") {
          if (!context.mounted) return;
          ValidationIoSAlert()
              .showAlert(context, description: "Please enter plot area");
        } else if ((roadAreaExtent ?? "").isEmpty) {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please enter road effected area");
        } else if ((masterplanZdp ?? "").isEmpty ||
            (masterplanZdp ?? "").toLowerCase() == "please select") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please select land use as per Master Plan/ZDP");
        } else if (layoutDocVal == "") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please select option layout Document");
        } else if (layoutDocVal == "Y" && layoutSelectedDoc == "") {
          if (!context.mounted) return;
          ValidationIoSAlert()
              .showAlert(context, description: "Please upload layout Document");
        } else if (ownershipDocVal == "") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please select option ownership Document");
        } else if (ownershipDocVal == "Y" && ownershipSelectedDoc == "") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please upload ownership Document");
        } else if (ecDocVal == "") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please select option EC Document");
        } else if (ecDocVal == "Y" && ecSelectedDoc == "") {
          if (!context.mounted) return;
          ValidationIoSAlert()
              .showAlert(context, description: "Please upload EC Document");
        } else if (checkList.isEmpty) {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: (checklistQues.isNotEmpty &&
                      checklistQues[0].pLOTQUESTIONARY != null)
                  ? "Please select answer for question ${checklistQues[0].pLOTQUESTIONARY}"
                  : "Please select answers for check details");
        } else {
          //check details screen validations
          if (!context.mounted) return;
          final isCheckDetailsAnswered =
              validateQues(context, checklistQues, checkList);
          if (isCheckDetailsAnswered) {
            if (conversionCharges == null || conversionCharges == '') {
              if (!context.mounted) return;
              ValidationIoSAlert().showAlert(
                context,
                description: "enterConversionChargers".tr(),
              );
            } else if (mvRate2020 == null || mvRate2020 == '') {
              if (!context.mounted) return;

              ValidationIoSAlert().showAlert(
                context,
                description: "movOn26082020".tr(),
              );
            } else if (mvRateDocument == null || mvRateDocument == '') {
              if (!context.mounted) return;

              ValidationIoSAlert().showAlert(
                context,
                description: "mvDateOFRegistration".tr(),
              );
            } else if (isCalcutae == null || isCalcutae == false) {
              if (!context.mounted) return;

              ValidationIoSAlert().showAlert(
                context,
                description: "calculatebtn".tr(),
              );
            } else if (selectedRecommendationValue?.recommendation == null ||
                (selectedRecommendationValue?.recommendationValue ?? "")
                    .isEmpty ||
                (selectedRecommendationValue?.recommendationValue ?? "") ==
                    "0" ||
                selectedRecommendationValue?.recommendation?.toLowerCase() ==
                    "please select") {
              if (!context.mounted) return;
              ValidationIoSAlert().showAlert(context,
                  description: "Please select any recommendation");
            } else if (remarks == null || remarks.trim().isEmpty) {
              if (!context.mounted) return;
              ValidationIoSAlert()
                  .showAlert(context, description: "Please enter remarks");
            } else {
              if (!context.mounted) return;
              final addCoordinatesProvider =
                  Provider.of<AddCoordinatesViewModel>(context, listen: false);
              //final submit validations
              //plot details upload

              setLoaderVisibleStatus(true);

/*       String? latitude = prefs.getString(SharedPrefConstants.latitudeKey);
      String? longitude = prefs.getString(SharedPrefConstants.longitudeKey); */

              // Retrieving values for uploadPlot

              String? plot1Img = prefs.getString(SharedPrefConstants.plot1Img);
              String? plot2Img = prefs.getString(SharedPrefConstants.plot2Img);
              String? plot3Img = prefs.getString(SharedPrefConstants.plot3Img);
              String? plot4Img =
                  prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt);
              // String? plot5Img = prefs.getString(SharedPrefConstants.plot5Img);
              String? captureLocScreenshot = prefs
                  .getString(SharedPrefConstants.plot5ImgCaptureLocScreenshot);

              // Retrieving values for checklist

              // Retrieving values for payments
              String? srdpRdp = prefs.getString(SharedPrefConstants.srdpRdpKey);

              String? rc = prefs.getString(SharedPrefConstants.rcKey);
              String? vlt = prefs.getString(SharedPrefConstants.vltKey);
              String? plotOpenspace =
                  prefs.getString(SharedPrefConstants.plotOpenspaceKey);
              String? trc = prefs.getString(SharedPrefConstants.trcKey);

              /* 
      totalNoAreaExtent: ,totalNoOfSoldPlots: ,totalNoOfUnSoldPlots: ,totalNoPlots: ,unSoldPlotsList: ,
       */
              //Layouts
              final totalUnsoldPlotArea =
                  prefs.getString(SharedPrefConstants.totalunsoldPlotAreakey);
              final totalNoOfPlots =
                  prefs.getString(SharedPrefConstants.totalNoOfPlotsKey);
              final unsoldPlots =
                  prefs.getString(SharedPrefConstants.unsoldPlotsKey);
              final soldPlots =
                  prefs.getString(SharedPrefConstants.soldPlotsKey);
              //Layouts Unsold PlotList retrieval
              String? unsoldPlotListStr =
                  prefs.getString(SharedPrefConstants.unsoldPlotListKey);
              List<UnSoldPlots> finalUnsoldPlotsList = [];
              if (unsoldPlotListStr != null && unsoldPlotListStr != "") {
                final List<dynamic> unsoldListJson =
                    jsonDecode(unsoldPlotListStr);
                finalUnsoldPlotsList = unsoldListJson
                    .map((item) => UnSoldPlots.fromJson(item))
                    .toList();
              }
              // Retrieving values for recommendations

              String reMarks = remarks;

              // String? recommendations = selectedRecommendationValue?.recommendation;
              String? statusId =
                  selectedRecommendationValue?.recommendationValue;

              LocalStoreHelper sharedpref = LocalStoreHelper();
              final userID =
                  await sharedpref.readTheData(SharedPrefConstants.userID);
              final empID =
                  await sharedpref.readTheData(SharedPrefConstants.empID);
              final tokenID =
                  await sharedpref.readTheData(SharedPrefConstants.token);

              final ip = await GetDeviceId().getIpAddress();

              final dateRefId =
                  DateFormat('ddMMyyyyHHmmssSSSS').format(DateTime.now());

              AppLogger().logDebug("dateRefId $dateRefId");
              if (!context.mounted) return;
              final lat = prefs.getString(SharedPrefConstants.latitudeKey);
              final long = prefs.getString(SharedPrefConstants.longitudeKey);

              AppLogger().logDebug(
                  "Before---------> ${addCoordinatesProvider.getAddedCoordinates}");
              List<List<double>> coordinates = addCoordinatesProvider
                  .getAddedCoordinates
                  .map((latLng) => [latLng.longitude, latLng.latitude])
                  .toList();

              final latlngStrings = jsonEncode(coordinates);

              AppLogger()
                  .logDebug("latlngStrings------------->>>> $latlngStrings");
              AppLogger().logDebug("Coordinated------------->>>> $coordinates");
              final connection = await internetCheck();

              if (connection) {
                for (CHECKLIST item in checkList) {
                  if (item.docment != null) {
                    item.docment = (item.docment ?? "").startsWith("http")
                        ? null
                        : (item.docment ?? "");
                  }
                }
                FinalSubmitPayload payload = FinalSubmitPayload(
                    aPPLICATIONID: applicationId,
                    lAYOUTNAME: layoutName,
                    pLOTNO: plotNo,
                    aREAEXTENT: areaExtent,
                    pLOTAREAEXTENT: plotAreaExtent,
                    rOADAREAEXTENT: roadAreaExtent,
                    mASTERPLANZDP: masterplanZdp,
                    latitude: lat,
                    longitude: long,
                    lAYOUTDOC: (layoutSelectedDoc ?? "").startsWith("http")
                        ? null
                        : layoutSelectedDoc,
                    oWNERSHIPDOC:
                        (ownershipSelectedDoc ?? "").startsWith("http")
                            ? null
                            : ownershipSelectedDoc,
                    eCDOC: (ecSelectedDoc ?? "").startsWith("http")
                        ? null
                        : ecSelectedDoc,
                    pHOTO1:
                        (plot1Img ?? "").startsWith("http") ? null : plot1Img,
                    pHOTO2:
                        (plot2Img ?? "").startsWith("http") ? null : plot2Img,
                    pHOTO3:
                        (plot3Img ?? "").startsWith("http") ? null : plot3Img,
                    pHOTO4:
                        (plot4Img ?? "").startsWith("http") ? null : plot4Img,
                    pHOTO5: captureLocScreenshot,
                    sRDPRDP: srdpRdp,
                    conversionCharges: conversionCharges,
                    mVRATE2020: mvRate2020,
                    mVRATEDOCUMET: mvRateDocument,
                    rC: rc,
                    vLT: vlt,
                    pLOTOPENSPACE: plotOpenspace,
                    tRC: trc,
                    aDDITIONALCONDITION: "",
                    nOTES: reMarks,
                    cONDTION: "",
                    rECOMMENDATIONS: statusId,
                    cHECKLIST: checkList,
                    empID: empID,
                    gISCORDINATE: latlngStrings,
                    gISCOUNT: addCoordinatesProvider.getAddedCoordinates.length
                        .toString(),
                    iPAddress: ip ?? "",
                    sTATUSID: statusId,
                    tokenID: tokenID,
                    uNIREFID: dateRefId,
                    userID: userID,
                    isLayoutPlot: AppConstants.isLayoutPlot,
                    totalNoAreaExtent: totalUnsoldPlotArea,
                    totalNoOfSoldPlots: soldPlots,
                    totalNoOfUnSoldPlots: unsoldPlots,
                    totalNoPlots: totalNoOfPlots,
                    unSoldPlotsList: finalUnsoldPlotsList,
                    isSaveType: "submit");
                final jsonPayload = jsonEncode(payload.toJson());
                AppLogger().logDebug("submit $jsonPayload");
                AppLogger().logDebug("IP $ip");
                try {
                  if (!context.mounted) return;
                  FinalSubmitResponse? submitResponse;
                  if (AppConstants.isSavedApplication == "yes") {
                    submitResponse = await ShortfallFinalSubmitRepository()
                        .finalSavedSubmitApi(context, payload);
                  } else {
                    submitResponse = await ShortfallFinalSubmitRepository()
                        .finalSubmitApi(context, payload);
                  }
                  if (submitResponse != null) {
                    if (submitResponse.statusCode == ApiErrorCodes.success) {
                      if (!context.mounted) return;
                      SuccessCustomCupertinoAlert().showAlert(
                          context: context,
                          title: submitResponse.statusMsg ?? "",
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.dashboard);
                          });
                      final captureGeoCoordinatesProvider =
                          Provider.of<CaptureGeoCoordinatesViewModelNew>(
                              context,
                              listen: false);
                      captureGeoCoordinatesProvider.onClear(context);
                      clearSavedData(context);
                    } else if (submitResponse.statusCode ==
                        ApiErrorCodes.badRequest) {
                      setLoaderVisibleStatus(false);
                      if (!context.mounted) return;
                      ErrorCustomCupertinoAlert().showAlert(
                        context,
                        message: submitResponse.statusMsg.toString(),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      setLoaderVisibleStatus(false);
                      if (!context.mounted) return;
                      ErrorCustomCupertinoAlert().showAlert(
                        context,
                        message: submitResponse.statusMsg ?? "",
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
                } catch (e) {
                  setLoaderVisibleStatus(false);
                  AppLogger().logDebug("$e");
                }
              } else {
                if (!context.mounted) return;
                InternetCheckAlert().showAlert(context);
              }
            }
          }
        }
      } else {
        if (!context.mounted) return;
        submitApplication(context, checkList, remarks ?? "",
            selectedRecommendationValue?.recommendation, checklistQues);
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

  Future<void> finalLayoutSubmitMethod(
      BuildContext context, String? remarks) async {
    try {
      FocusScope.of(context).unfocus();
      //final submit validations
      //plot details upload

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final checklistQues = await getQuesCheckListFromSharedPreferences(
          SharedPrefConstants.questionsChecklist);

      final layoutDocVal =
          prefs.getString(SharedPrefConstants.layoutDocumentradioVal);
      final ownershipDocVal =
          prefs.getString(SharedPrefConstants.ownershipDocumetRadioVal);
      final ecDocVal = prefs.getString(SharedPrefConstants.ecDocumentRadioVal);

      // AppLogger().logDebug("layoutDocVal $layoutDocVal");
      // AppLogger().logDebug("ownershipDocVal $ownershipDocVal");
      // AppLogger().logDebug("ecDocVal $ecDocVal");

      String? layoutSelectedDoc =
          prefs.getString(SharedPrefConstants.layoutSelectedDocKey);
      String? ownershipSelectedDoc =
          prefs.getString(SharedPrefConstants.ownershipSelectedDocKey);
      String? ecSelectedDoc =
          prefs.getString(SharedPrefConstants.ecSelectedDocKey);

      AppLogger().logDebug("layoutSelectedDoc $layoutSelectedDoc");

      // Retrieving values for checklist
      String? checkListString =
          prefs.getString(SharedPrefConstants.checkListKey);
      final List<dynamic> checkListJson = jsonDecode(checkListString!);
      final List<CHECKLIST> checkList = checkListJson
          .map((checkListMap) => CHECKLIST.fromJson(checkListMap))
          .toList();
      AppLogger().logDebug("checkListANSWW2 ::: ${jsonEncode(checkList)}");

      for (CHECKLIST item in checkList) {
        if (!kReleaseMode) debugPrint("docPath ${item.docment}");
        if (item.docment != null) {
          item.docment = (item.docment ?? "").startsWith("http")
              ? item.docment
              : (item.docment ?? "").contains(".pdf")
                  ? convertToBase64(item.docment)
                  : "";
        }
      }

// payment validations
      String? conversionCharges =
          prefs.getString(SharedPrefConstants.conversionChargesKey);
      String? mvRate2020 = prefs.getString(SharedPrefConstants.mvRate2020Key);
      String? mvRateDocument =
          prefs.getString(SharedPrefConstants.mvRateDocumentKey);

      bool? isCalcutae = prefs.getBool(SharedPrefConstants.isCalculate);
      // Retrieving values for Application Details
      String? applicationId =
          prefs.getString(SharedPrefConstants.applicationNo);
      String? layoutName = prefs.getString(SharedPrefConstants.layoutNameKey);
      String? plotNo = prefs.getString(SharedPrefConstants.plotNoKey);
      String? areaExtent = prefs.getString(SharedPrefConstants.areaExtentKey);
      String? plotAreaExtent =
          prefs.getString(SharedPrefConstants.plotAreaExtentKey);
      String? roadAreaExtent =
          prefs.getString(SharedPrefConstants.roadAreaExtentKey);
      String? masterplanZdp =
          prefs.getString(SharedPrefConstants.masterplanZdpKey);
      AppLogger().logDebug("isCalcutae$isCalcutae");
      if (AppConstants.userType.toLowerCase() == "tp") {
        if ((masterplanZdp ?? "").isEmpty ||
            (masterplanZdp ?? "").toLowerCase() == "please select") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please select land use as per Master Plan/ZDP");
        } else if (layoutDocVal == "") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please select option layout Document");
        } else if (layoutDocVal == "Y" && layoutSelectedDoc == "") {
          if (!context.mounted) return;
          ValidationIoSAlert()
              .showAlert(context, description: "Please upload layout Document");
        } else if (ownershipDocVal == "") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please select option ownership Document");
        } else if (ownershipDocVal == "Y" && ownershipSelectedDoc == "") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please upload ownership Document");
        } else if (ecDocVal == "") {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: "Please select option EC Document");
        } else if (ecDocVal == "Y" && ecSelectedDoc == "") {
          if (!context.mounted) return;
          ValidationIoSAlert()
              .showAlert(context, description: "Please upload EC Document");
        } else if (checkList.isEmpty) {
          if (!context.mounted) return;
          ValidationIoSAlert().showAlert(context,
              description: (checklistQues.isNotEmpty &&
                      checklistQues[0].pLOTQUESTIONARY != null)
                  ? "Please select answer for question ${checklistQues[0].pLOTQUESTIONARY}"
                  : "Please select answers for check details");
        } else {
          //check details screen validations
          if (!context.mounted) return;
          final isCheckDetailsAnswered =
              validateQues(context, checklistQues, checkList);
          if (isCheckDetailsAnswered) {
            if (conversionCharges == null || conversionCharges == '') {
              if (!context.mounted) return;
              ValidationIoSAlert().showAlert(
                context,
                description: "enterConversionChargers".tr(),
              );
            } else if (mvRate2020 == null || mvRate2020 == '') {
              if (!context.mounted) return;

              ValidationIoSAlert().showAlert(
                context,
                description: "movOn26082020".tr(),
              );
            } else if (mvRateDocument == null || mvRateDocument == '') {
              if (!context.mounted) return;

              ValidationIoSAlert().showAlert(
                context,
                description: "mvDateOFRegistration".tr(),
              );
            } else if (isCalcutae == null || isCalcutae == false) {
              if (!context.mounted) return;

              ValidationIoSAlert().showAlert(
                context,
                description: "calculatebtn".tr(),
              );
            } else if (selectedRecommendationValue?.recommendation == null ||
                (selectedRecommendationValue?.recommendationValue ?? "")
                    .isEmpty ||
                (selectedRecommendationValue?.recommendationValue ?? "") ==
                    "0" ||
                selectedRecommendationValue?.recommendation?.toLowerCase() ==
                    "please select") {
              if (!context.mounted) return;
              ValidationIoSAlert().showAlert(context,
                  description: "Please select any recommendation");
            } else if (remarks == null || remarks.trim().isEmpty) {
              if (!context.mounted) return;
              ValidationIoSAlert()
                  .showAlert(context, description: "Please enter remarks");
            } else {
              if (!context.mounted) return;
              final addCoordinatesProvider =
                  Provider.of<AddCoordinatesViewModel>(context, listen: false);
              //final submit validations
              //plot details upload

              setLoaderVisibleStatus(true);

/*       String? latitude = prefs.getString(SharedPrefConstants.latitudeKey);
      String? longitude = prefs.getString(SharedPrefConstants.longitudeKey); */

              // Retrieving values for uploadPlot

              String? plot1Img = prefs.getString(SharedPrefConstants.plot1Img);
              String? plot2Img = prefs.getString(SharedPrefConstants.plot2Img);
              String? plot3Img = prefs.getString(SharedPrefConstants.plot3Img);
              String? plot4Img =
                  prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt);
              // String? plot5Img = prefs.getString(SharedPrefConstants.plot5Img);
              String? captureLocScreenshot = prefs
                  .getString(SharedPrefConstants.plot5ImgCaptureLocScreenshot);

              // Retrieving values for checklist

              // Retrieving values for payments
              String? srdpRdp = prefs.getString(SharedPrefConstants.srdpRdpKey);

              String? rc = prefs.getString(SharedPrefConstants.rcKey);
              String? vlt = prefs.getString(SharedPrefConstants.vltKey);
              String? plotOpenspace =
                  prefs.getString(SharedPrefConstants.plotOpenspaceKey);
              String? trc = prefs.getString(SharedPrefConstants.trcKey);

              /* 
      totalNoAreaExtent: ,totalNoOfSoldPlots: ,totalNoOfUnSoldPlots: ,totalNoPlots: ,unSoldPlotsList: ,
       */
              //Layouts
              final totalUnsoldPlotArea =
                  prefs.getString(SharedPrefConstants.totalunsoldPlotAreakey);
              final totalNoOfPlots =
                  prefs.getString(SharedPrefConstants.totalNoOfPlotsKey);
              final unsoldPlots =
                  prefs.getString(SharedPrefConstants.unsoldPlotsKey);
              final soldPlots =
                  prefs.getString(SharedPrefConstants.soldPlotsKey);
              //Layouts Unsold PlotList retrieval
              String? unsoldPlotListStr =
                  prefs.getString(SharedPrefConstants.unsoldPlotListKey);
              List<UnSoldPlots> finalUnsoldPlotsList = [];
              if (unsoldPlotListStr != null && unsoldPlotListStr != "") {
                final List<dynamic> unsoldListJson =
                    jsonDecode(unsoldPlotListStr);
                finalUnsoldPlotsList = unsoldListJson
                    .map((item) => UnSoldPlots.fromJson(item))
                    .toList();
              }
              // Retrieving values for recommendations

              String reMarks = remarks;

              // String? recommendations = selectedRecommendationValue?.recommendation;
              String? statusId =
                  selectedRecommendationValue?.recommendationValue;

              LocalStoreHelper sharedpref = LocalStoreHelper();
              final userID =
                  await sharedpref.readTheData(SharedPrefConstants.userID);
              final empID =
                  await sharedpref.readTheData(SharedPrefConstants.empID);
              final tokenID =
                  await sharedpref.readTheData(SharedPrefConstants.token);

              final ip = await GetDeviceId().getIpAddress();

              final dateRefId =
                  DateFormat('ddMMyyyyHHmmssSSSS').format(DateTime.now());

              AppLogger().logDebug("dateRefId $dateRefId");
              if (!context.mounted) return;
              final lat = prefs.getString(SharedPrefConstants.latitudeKey);
              final long = prefs.getString(SharedPrefConstants.longitudeKey);

              AppLogger().logDebug(
                  "Before---------> ${addCoordinatesProvider.getAddedCoordinates}");
              List<List<double>> coordinates = addCoordinatesProvider
                  .getAddedCoordinates
                  .map((latLng) => [latLng.longitude, latLng.latitude])
                  .toList();

              final latlngStrings = jsonEncode(coordinates);

              AppLogger()
                  .logDebug("latlngStrings------------->>>> $latlngStrings");
              AppLogger().logDebug("Coordinated------------->>>> $coordinates");
              final connection = await internetCheck();

              if (connection) {
                for (CHECKLIST item in checkList) {
                  if (item.docment != null) {
                    item.docment = (item.docment ?? "").startsWith("http")
                        ? null
                        : (item.docment ?? "");
                  }
                }
                FinalSubmitPayload payload = FinalSubmitPayload(
                    aPPLICATIONID: applicationId,
                    lAYOUTNAME: layoutName,
                    pLOTNO: plotNo,
                    aREAEXTENT: areaExtent,
                    pLOTAREAEXTENT: plotAreaExtent,
                    rOADAREAEXTENT: roadAreaExtent,
                    mASTERPLANZDP: masterplanZdp,
                    latitude: lat,
                    longitude: long,
                    lAYOUTDOC: (layoutSelectedDoc ?? "").startsWith("http")
                        ? null
                        : layoutSelectedDoc,
                    oWNERSHIPDOC:
                        (ownershipSelectedDoc ?? "").startsWith("http")
                            ? null
                            : ownershipSelectedDoc,
                    eCDOC: (ecSelectedDoc ?? "").startsWith("http")
                        ? null
                        : ecSelectedDoc,
                    pHOTO1:
                        (plot1Img ?? "").startsWith("http") ? null : plot1Img,
                    pHOTO2:
                        (plot2Img ?? "").startsWith("http") ? null : plot2Img,
                    pHOTO3:
                        (plot3Img ?? "").startsWith("http") ? null : plot3Img,
                    pHOTO4:
                        (plot4Img ?? "").startsWith("http") ? null : plot4Img,
                    pHOTO5: captureLocScreenshot,
                    sRDPRDP: srdpRdp,
                    conversionCharges: conversionCharges,
                    mVRATE2020: mvRate2020,
                    mVRATEDOCUMET: mvRateDocument,
                    rC: rc,
                    vLT: vlt,
                    pLOTOPENSPACE: plotOpenspace,
                    tRC: trc,
                    aDDITIONALCONDITION: "",
                    nOTES: reMarks,
                    cONDTION: "",
                    rECOMMENDATIONS: statusId,
                    cHECKLIST: checkList,
                    empID: empID,
                    gISCORDINATE: latlngStrings,
                    gISCOUNT: addCoordinatesProvider.getAddedCoordinates.length
                        .toString(),
                    iPAddress: ip ?? "",
                    sTATUSID: statusId,
                    tokenID: tokenID,
                    uNIREFID: dateRefId,
                    userID: userID,
                    isLayoutPlot: AppConstants.isLayoutPlot,
                    totalNoAreaExtent: totalUnsoldPlotArea,
                    totalNoOfSoldPlots: soldPlots,
                    totalNoOfUnSoldPlots: unsoldPlots,
                    totalNoPlots: totalNoOfPlots,
                    unSoldPlotsList: finalUnsoldPlotsList,
                    isSaveType: "submit");
                final jsonPayload = jsonEncode(payload.toJson());
                AppLogger().logDebug("submit $jsonPayload");

                try {
                  if (!context.mounted) return;
                  FinalSubmitResponse? submitResponse;
                  if (AppConstants.isSavedApplication == "yes") {
                    submitResponse = await ShortfallFinalSubmitRepository()
                        .finalSavedSubmitApi(context, payload);
                  } else {
                    submitResponse = await ShortfallFinalSubmitRepository()
                        .finalSubmitApi(context, payload);
                  }
                  if (submitResponse != null) {
                    if (submitResponse.statusCode == ApiErrorCodes.success) {
                      if (!context.mounted) return;
                      SuccessCustomCupertinoAlert().showAlert(
                          context: context,
                          title: submitResponse.statusMsg ?? "",
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.dashboard);
                          });
                      final captureGeoCoordinatesProvider =
                          Provider.of<CaptureGeoCoordinatesViewModelNew>(
                              context,
                              listen: false);
                      captureGeoCoordinatesProvider.onClear(context);
                      clearSavedData(context);
                    } else if (submitResponse.statusCode ==
                        ApiErrorCodes.badRequest) {
                      setLoaderVisibleStatus(false);
                      if (!context.mounted) return;
                      ErrorCustomCupertinoAlert().showAlert(
                        context,
                        message: submitResponse.statusMsg.toString(),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      setLoaderVisibleStatus(false);
                      if (!context.mounted) return;
                      ErrorCustomCupertinoAlert().showAlert(
                        context,
                        message: submitResponse.statusMsg ?? "",
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
                } catch (e) {
                  setLoaderVisibleStatus(false);
                  AppLogger().logDebug("$e");
                }
              } else {
                if (!context.mounted) return;
                InternetCheckAlert().showAlert(context);
              }
            }
          }
        }
      } else {
        if (!context.mounted) return;
        submitApplication(context, checkList, remarks ?? "",
            selectedRecommendationValue?.recommendation, checklistQues);
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

  Future<void> finalSaveMethod(BuildContext context, String? remarks) async {
    try {
      FocusScope.of(context).unfocus();
      final addCoordinatesProvider =
          Provider.of<AddCoordinatesViewModel>(context, listen: false);
      //final submit validations
      //plot details upload

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // AppLogger().logDebug("layoutDocVal $layoutDocVal");
      // AppLogger().logDebug("ownershipDocVal $ownershipDocVal");
      // AppLogger().logDebug("ecDocVal $ecDocVal");

      String? layoutSelectedDoc =
          prefs.getString(SharedPrefConstants.layoutSelectedDocKey);
      String? ownershipSelectedDoc =
          prefs.getString(SharedPrefConstants.ownershipSelectedDocKey);
      String? ecSelectedDoc =
          prefs.getString(SharedPrefConstants.ecSelectedDocKey);

      AppLogger().logDebug("layoutSelectedDoc $layoutSelectedDoc");

      // Retrieving values for checklist
      String? checkListString =
          prefs.getString(SharedPrefConstants.checkListKey);
      final List<dynamic> checkListJson = jsonDecode(checkListString!);
      final List<CHECKLIST> checkList = checkListJson
          .map((checkListMap) => CHECKLIST.fromJson(checkListMap))
          .toList();
      AppLogger().logDebug("checkListANSWW2 ::: ${jsonEncode(checkList)}");

      for (CHECKLIST checklist in checkList) {
        if (checklist.docment != null) {
          checklist.docment = convertToBase64(checklist.docment);
        }
      }
// payment validations
      String? conversionCharges =
          prefs.getString(SharedPrefConstants.conversionChargesKey);
      String? mvRate2020 = prefs.getString(SharedPrefConstants.mvRate2020Key);
      String? mvRateDocument =
          prefs.getString(SharedPrefConstants.mvRateDocumentKey);

      bool? isCalcutae = prefs.getBool(SharedPrefConstants.isCalculate);
      AppLogger().logDebug("isCalcutae$isCalcutae");
      setLoaderVisibleStatus(true);

      // Retrieving values for Application Details
      String? applicationId =
          prefs.getString(SharedPrefConstants.applicationNo);
      String? layoutName = prefs.getString(SharedPrefConstants.layoutNameKey);
      String? plotNo = prefs.getString(SharedPrefConstants.plotNoKey);
      String? areaExtent = prefs.getString(SharedPrefConstants.areaExtentKey);
      String? plotAreaExtent =
          prefs.getString(SharedPrefConstants.plotAreaExtentKey);
      String? roadAreaExtent =
          prefs.getString(SharedPrefConstants.roadAreaExtentKey);
      String? masterplanZdp =
          prefs.getString(SharedPrefConstants.masterplanZdpKey);
/*       String? latitude = prefs.getString(SharedPrefConstants.latitudeKey);
      String? longitude = prefs.getString(SharedPrefConstants.longitudeKey); */

      // Retrieving values for uploadPlot

      String? plot1Img = prefs.getString(SharedPrefConstants.plot1Img);
      String? plot2Img = prefs.getString(SharedPrefConstants.plot2Img);
      String? plot3Img = prefs.getString(SharedPrefConstants.plot3Img);
      String? plot4Img =
          prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt);
      // String? plot5Img = prefs.getString(SharedPrefConstants.plot5Img);
      String? captureLocScreenshot =
          prefs.getString(SharedPrefConstants.plot5ImgCaptureLocScreenshot);

      // Retrieving values for checklist

      // Retrieving values for payments
      String? srdpRdp = prefs.getString(SharedPrefConstants.srdpRdpKey);

      String? rc = prefs.getString(SharedPrefConstants.rcKey);
      String? vlt = prefs.getString(SharedPrefConstants.vltKey);
      String? plotOpenspace =
          prefs.getString(SharedPrefConstants.plotOpenspaceKey);
      String? trc = prefs.getString(SharedPrefConstants.trcKey);

      /* 
      totalNoAreaExtent: ,totalNoOfSoldPlots: ,totalNoOfUnSoldPlots: ,totalNoPlots: ,unSoldPlotsList: ,
       */
      //Layouts
      final totalUnsoldPlotArea =
          prefs.getString(SharedPrefConstants.totalunsoldPlotAreakey);
      final totalNoOfPlots =
          prefs.getString(SharedPrefConstants.totalNoOfPlotsKey);
      final unsoldPlots = prefs.getString(SharedPrefConstants.unsoldPlotsKey);
      final soldPlots = prefs.getString(SharedPrefConstants.soldPlotsKey);
      //Layouts Unsold PlotList retrieval
      String? unsoldPlotListStr =
          prefs.getString(SharedPrefConstants.unsoldPlotListKey);
      List<UnSoldPlots> finalUnsoldPlotsList = [];
      if (unsoldPlotListStr != null && unsoldPlotListStr != "") {
        final List<dynamic> unsoldListJson = jsonDecode(unsoldPlotListStr);
        finalUnsoldPlotsList =
            unsoldListJson.map((item) => UnSoldPlots.fromJson(item)).toList();
      }
      // Retrieving values for recommendations

      String reMarks = remarks ?? "";

      // String? recommendations = selectedRecommendationValue?.recommendation;
      String? statusId = selectedRecommendationValue?.recommendationValue;

      LocalStoreHelper sharedpref = LocalStoreHelper();
      final userID = await sharedpref.readTheData(SharedPrefConstants.userID);
      final empID = await sharedpref.readTheData(SharedPrefConstants.empID);
      final tokenID = await sharedpref.readTheData(SharedPrefConstants.token);

      final ip = await GetDeviceId().getIpAddress();

      final dateRefId = DateFormat('ddMMyyyyHHmmssSSSS').format(DateTime.now());

      AppLogger().logDebug("dateRefId $dateRefId");
      if (!context.mounted) return;
      final lat = prefs.getString(SharedPrefConstants.latitudeKey);
      final long = prefs.getString(SharedPrefConstants.longitudeKey);

      final latlngStrings =
          prefs.getString(SharedPrefConstants.gisCoordinatesList);

      AppLogger().logDebug("latlngStrings------------->>>> $latlngStrings");

      final connection = await internetCheck();

      if (connection) {
        FinalSubmitPayload payload = FinalSubmitPayload(
            aPPLICATIONID: applicationId,
            lAYOUTNAME: layoutName,
            pLOTNO: plotNo,
            aREAEXTENT: areaExtent,
            pLOTAREAEXTENT: plotAreaExtent,
            rOADAREAEXTENT: roadAreaExtent,
            mASTERPLANZDP: masterplanZdp,
            latitude: lat,
            longitude: long,
            lAYOUTDOC: layoutSelectedDoc,
            oWNERSHIPDOC: ownershipSelectedDoc,
            eCDOC: ecSelectedDoc,
            pHOTO1: plot1Img,
            pHOTO2: plot2Img,
            pHOTO3: plot3Img,
            pHOTO4: plot4Img,
            pHOTO5: captureLocScreenshot,
            sRDPRDP: srdpRdp,
            conversionCharges: conversionCharges,
            mVRATE2020: mvRate2020,
            mVRATEDOCUMET: mvRateDocument,
            rC: rc,
            vLT: vlt,
            pLOTOPENSPACE: plotOpenspace,
            tRC: trc,
            aDDITIONALCONDITION: "",
            nOTES: reMarks,
            cONDTION: "",
            rECOMMENDATIONS: statusId,
            cHECKLIST: checkList,
            empID: empID,
            gISCORDINATE: latlngStrings,
            gISCOUNT:
                addCoordinatesProvider.getAddedCoordinates.length.toString(),
            iPAddress: ip ?? "",
            sTATUSID: statusId,
            tokenID: tokenID,
            uNIREFID: dateRefId,
            userID: userID,
            isLayoutPlot: AppConstants.isLayoutPlot,
            totalNoAreaExtent: totalUnsoldPlotArea,
            totalNoOfSoldPlots: soldPlots,
            totalNoOfUnSoldPlots: unsoldPlots,
            totalNoPlots: totalNoOfPlots,
            unSoldPlotsList:
                AppConstants.isLayoutPlot == "P" ? [] : finalUnsoldPlotsList,
            isSaveType: "save");
        final jsonPayload = jsonEncode(payload.toJson());
        AppLogger().logDebug("submit $jsonPayload");

        if (!context.mounted) return;
        FinalSubmitResponse? submitResponse =
            await VillagewiseClusterInspectionFinalSubmitRepository()
                .finalSubmitApi(context, payload);
        if (submitResponse != null) {
          if (submitResponse.statusCode == ApiErrorCodes.success) {
            if (!context.mounted) return;
            SuccessCustomCupertinoAlert().showAlert(
                context: context,
                title: submitResponse.statusMsg ?? "",
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.dashboard);
                });
            final captureGeoCoordinatesProvider =
                Provider.of<CaptureGeoCoordinatesViewModelNew>(context,
                    listen: false);
            captureGeoCoordinatesProvider.onClear(context);
            clearSavedData(context);
          } else if (submitResponse.statusCode == ApiErrorCodes.badRequest) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: submitResponse.statusMsg.toString(),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          } else {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: submitResponse.statusMsg ?? "",
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

  void clearSavedData(BuildContext context) {
    Provider.of<ShortfallApplicationDetailsViewModel>(context, listen: false).clearAll();
    Provider.of<ShortfallLayoutApplicationDetailsViewModel>(context, listen: false).clearAll();
    Provider.of<ShortfallUploadPlotDetailsViewModel>(context, listen: false).clearAll();
    Provider.of<ShortfallAddCoordinatesViewModel>(context, listen: false).clearAll();
    Provider.of<ShortfallCheckDetailsViewModel>(context, listen: false).clearAll();
    Provider.of<ShortfallPaymentDetailsViewModel>(context, listen: false).clearAll();
    clearAll();
    // Clearing values for Application Details
    LocalStoreHelper().removeData(SharedPrefConstants.applicationNo);
    LocalStoreHelper().removeData(SharedPrefConstants.layoutNameKey);
    LocalStoreHelper().removeData(SharedPrefConstants.plotNoKey);
    LocalStoreHelper().removeData(SharedPrefConstants.areaExtentKey);
    LocalStoreHelper().removeData(SharedPrefConstants.plotAreaExtentKey);
    LocalStoreHelper().removeData(SharedPrefConstants.roadAreaExtentKey);
    LocalStoreHelper().removeData(SharedPrefConstants.masterplanZdpKey);
    LocalStoreHelper().removeData(SharedPrefConstants.latitudeKey);
    LocalStoreHelper().removeData(SharedPrefConstants.longitudeKey);

// Clearing values for Upload Details
    LocalStoreHelper().removeData(SharedPrefConstants.layoutSelectedDocKey);
    LocalStoreHelper().removeData(SharedPrefConstants.ownershipSelectedDocKey);
    LocalStoreHelper().removeData(SharedPrefConstants.ecSelectedDocKey);
    LocalStoreHelper().removeData(SharedPrefConstants.plot1Img);
    LocalStoreHelper().removeData(SharedPrefConstants.plot2Img);
    LocalStoreHelper().removeData(SharedPrefConstants.plot3Img);
    LocalStoreHelper().removeData(SharedPrefConstants.plot4ImgMasterPlanExt);
    LocalStoreHelper()
        .removeData(SharedPrefConstants.plot5ImgCaptureLocScreenshot);
    LocalStoreHelper().removeData(SharedPrefConstants.layoutDocumentradioVal);
    LocalStoreHelper().removeData(SharedPrefConstants.ownershipDocumetRadioVal);
    LocalStoreHelper().removeData(SharedPrefConstants.ecDocumentRadioVal);
    LocalStoreHelper().removeData(SharedPrefConstants.gisCoordinatesList);

    // Clearing values for Check Details
    LocalStoreHelper().removeData(SharedPrefConstants.checkListKey);
    LocalStoreHelper().removeData(SharedPrefConstants.questionsChecklist);

    // Clearing values for Payment Details
    LocalStoreHelper().removeData(SharedPrefConstants.srdpRdpKey);
    LocalStoreHelper().removeData(SharedPrefConstants.conversionChargesKey);
    LocalStoreHelper().removeData(SharedPrefConstants.mvRate2020Key);
    LocalStoreHelper().removeData(SharedPrefConstants.mvRateDocumentKey);
    LocalStoreHelper().removeData(SharedPrefConstants.rcKey);
    LocalStoreHelper().removeData(SharedPrefConstants.vltKey);
    LocalStoreHelper().removeData(SharedPrefConstants.plotOpenspaceKey);
    LocalStoreHelper().removeData(SharedPrefConstants.trcKey);
    LocalStoreHelper().removeData(SharedPrefConstants.mvEditFlagKey);
    LocalStoreHelper().removeData(SharedPrefConstants.isCalculate);

    //Recommendations
    LocalStoreHelper().removeData(SharedPrefConstants.additionalConditionKey);
    LocalStoreHelper().removeData(SharedPrefConstants.notesKey);
    LocalStoreHelper().removeData(SharedPrefConstants.conditionKey);
    LocalStoreHelper().removeData(SharedPrefConstants.recommendationsKey);

    //Layout
    LocalStoreHelper().removeData(SharedPrefConstants.totalNoOfPlotsKey);
    LocalStoreHelper().removeData(SharedPrefConstants.selectedUnsoldPlotKey);
    LocalStoreHelper().removeData(SharedPrefConstants.soldPlotsKey);
    LocalStoreHelper().removeData(SharedPrefConstants.unsoldPlotsKey);
    LocalStoreHelper().removeData(SharedPrefConstants.totalunsoldPlotAreakey);
    LocalStoreHelper().removeData(SharedPrefConstants.unsoldPlotListKey);
    LocalStoreHelper().removeData(SharedPrefConstants.totalAreaExtent);
  }

  bool validateQues(
    BuildContext context,
    List<ListMasterPlans> checklistQues,
    List<CHECKLIST> checkList,
  ) {
    bool isAllQuestionsAnswered = true;
    for (ListMasterPlans question in checklistQues) {
      // Check if the question is present in the checklist
      if (!checkList.any((element) => element.cHECKLISTID == question.sNO)) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please select an answer for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      }

      // Proceed with existing validations if the question is present
      CHECKLIST? quesResponse = checkList.firstWhere(
        (element) => element.cHECKLISTID == question.sNO,
        orElse: () => CHECKLIST(), // handle null case gracefully
      );

      if (quesResponse.sTATUSID.toString().isEmpty ||
          quesResponse.sTATUSID == null) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please select an answer for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      } else if (question.iSREMARKS == "Y" &&
          quesResponse.sTATUSID == "Y" &&
          (quesResponse.remarks.toString().isEmpty ||
              quesResponse.remarks == null)) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please enter remarks for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      } else if (question.iSDROPDOWN == "Y" &&
          quesResponse.sTATUSID == "Y" &&
          (quesResponse.checkDRopDown.toString().isEmpty ||
              quesResponse.checkDRopDown == null ||
              quesResponse.checkDRopDown == "0")) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please select a dropdown option for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      } else if (question.iSUPLOAD == "Y" &&
          quesResponse.sTATUSID == "Y" &&
          (quesResponse.docment.toString().isEmpty ||
              quesResponse.docment == null)) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please upload a document for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      }
    }

    return isAllQuestionsAnswered;
  }

  Future<void> submitApplication(
      BuildContext context,
      List<CHECKLIST> checkList,
      String remarks,
      String? recommendation,
      checklistQues) async {
    try {
      final addCoordinatesProvider =
          Provider.of<AddCoordinatesViewModel>(context, listen: false);
      //final submit validations
      if (checkList.isEmpty) {
        if (!context.mounted) return;
        ValidationIoSAlert().showAlert(context,
            description: (checklistQues.isNotEmpty &&
                    checklistQues[0].pLOTQUESTIONARY != null)
                ? "Please select answer for question ${checklistQues[0].pLOTQUESTIONARY}"
                : "Please select answers for check details");
      } else {
        //check details screen validations
        if (!context.mounted) return;
        final isCheckDetailsAnswered =
            validateQues(context, checklistQues, checkList);

        if (isCheckDetailsAnswered) {
          if (selectedRecommendationValue?.recommendation == null ||
              (selectedRecommendationValue?.recommendationValue ?? "")
                  .isEmpty ||
              (selectedRecommendationValue?.recommendationValue ?? "") == "0" ||
              selectedRecommendationValue?.recommendation?.toLowerCase() ==
                  "please select") {
            if (!context.mounted) return;
            ValidationIoSAlert().showAlert(context,
                description: "Please select any recommendation");
          } else if (remarks.trim().isEmpty) {
            if (!context.mounted) return;
            ValidationIoSAlert()
                .showAlert(context, description: "Please enter remarks");
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setLoaderVisibleStatus(true);

            // Retrieving values for Application Details
            String? applicationId =
                prefs.getString(SharedPrefConstants.applicationNo);
            String? layoutName =
                prefs.getString(SharedPrefConstants.layoutNameKey);
            String? plotNo = prefs.getString(SharedPrefConstants.plotNoKey);
            String? areaExtent =
                prefs.getString(SharedPrefConstants.areaExtentKey);
            String? plotAreaExtent =
                prefs.getString(SharedPrefConstants.plotAreaExtentKey);
            String? roadAreaExtent =
                prefs.getString(SharedPrefConstants.roadAreaExtentKey);
            String? masterplanZdp =
                prefs.getString(SharedPrefConstants.masterplanZdpKey);
/*       String? latitude = prefs.getString(SharedPrefConstants.latitudeKey);
      String? longitude = prefs.getString(SharedPrefConstants.longitudeKey); */

            // Retrieving values for checklist

            // Retrieving values for payments
            String? srdpRdp = prefs.getString(SharedPrefConstants.srdpRdpKey);

            String? rc = prefs.getString(SharedPrefConstants.rcKey);
            String? vlt = prefs.getString(SharedPrefConstants.vltKey);
            String? plotOpenspace =
                prefs.getString(SharedPrefConstants.plotOpenspaceKey);
            String? trc = prefs.getString(SharedPrefConstants.trcKey);

            /* 
      totalNoAreaExtent: ,totalNoOfSoldPlots: ,totalNoOfUnSoldPlots: ,totalNoPlots: ,unSoldPlotsList: ,
       */
            //Layouts
            final totalUnsoldPlotArea =
                prefs.getString(SharedPrefConstants.totalunsoldPlotAreakey);
            final totalNoOfPlots =
                prefs.getString(SharedPrefConstants.totalNoOfPlotsKey);
            final unsoldPlots =
                prefs.getString(SharedPrefConstants.unsoldPlotsKey);
            final soldPlots = prefs.getString(SharedPrefConstants.soldPlotsKey);
            //Layouts Unsold PlotList retrieval
            String? unsoldPlotListStr =
                prefs.getString(SharedPrefConstants.unsoldPlotListKey);
            List<UnSoldPlots> finalUnsoldPlotsList = [];
            if (unsoldPlotListStr != null && unsoldPlotListStr != "") {
              final List<dynamic> unsoldListJson =
                  jsonDecode(unsoldPlotListStr);
              finalUnsoldPlotsList = unsoldListJson
                  .map((item) => UnSoldPlots.fromJson(item))
                  .toList();
            }
            // Retrieving values for recommendations

            String reMarks = remarks;

            // String? recommendations = selectedRecommendationValue?.recommendation;
            String? statusId = selectedRecommendationValue?.recommendationValue;

            LocalStoreHelper sharedpref = LocalStoreHelper();
            final userID =
                await sharedpref.readTheData(SharedPrefConstants.userID);
            final empID =
                await sharedpref.readTheData(SharedPrefConstants.empID);
            final tokenID =
                await sharedpref.readTheData(SharedPrefConstants.token);

            final ip = await GetDeviceId().getIpAddress();

            final dateRefId =
                DateFormat('ddMMyyyyHHmmssSSSS').format(DateTime.now());

            AppLogger().logDebug("dateRefId $dateRefId");
            if (!context.mounted) return;
            final lat = prefs.getString(SharedPrefConstants.latitudeKey);
            final long = prefs.getString(SharedPrefConstants.longitudeKey);

            AppLogger().logDebug(
                "Before---------> ${addCoordinatesProvider.getAddedCoordinates}");
            List<List<double>> coordinates = addCoordinatesProvider
                .getAddedCoordinates
                .map((latLng) => [latLng.longitude, latLng.latitude])
                .toList();

            final latlngStrings = jsonEncode(coordinates);

            AppLogger()
                .logDebug("latlngStrings------------->>>> $latlngStrings");
            AppLogger().logDebug("Coordinated------------->>>> $coordinates");
            final connection = await internetCheck();

            if (connection) {
              for (CHECKLIST item in checkList) {
                if (item.docment != null) {
                  item.docment = (item.docment ?? "").startsWith("http")
                      ? null
                      : (item.docment ?? "");
                }
              }
              FinalSubmitPayload payload = FinalSubmitPayload(
                  aPPLICATIONID: applicationId,
                  lAYOUTNAME: layoutName,
                  pLOTNO: plotNo,
                  aREAEXTENT: areaExtent,
                  pLOTAREAEXTENT: plotAreaExtent,
                  rOADAREAEXTENT: roadAreaExtent,
                  mASTERPLANZDP: masterplanZdp,
                  latitude: lat,
                  longitude: long,
                  lAYOUTDOC: "",
                  oWNERSHIPDOC: "",
                  eCDOC: "",
                  pHOTO1: "",
                  pHOTO2: "",
                  pHOTO3: "",
                  pHOTO4: "",
                  pHOTO5: "",
                  sRDPRDP: srdpRdp,
                  conversionCharges: "",
                  mVRATE2020: "",
                  mVRATEDOCUMET: "",
                  rC: rc,
                  vLT: vlt,
                  pLOTOPENSPACE: plotOpenspace,
                  tRC: trc,
                  aDDITIONALCONDITION: "",
                  nOTES: reMarks,
                  cONDTION: "",
                  rECOMMENDATIONS: statusId,
                  cHECKLIST: checkList,
                  empID: empID,
                  gISCORDINATE: "",
                  gISCOUNT: "",
                  iPAddress: ip ?? "",
                  sTATUSID: statusId,
                  tokenID: tokenID,
                  uNIREFID: dateRefId,
                  userID: userID,
                  isLayoutPlot: AppConstants.isLayoutPlot,
                  totalNoAreaExtent: totalUnsoldPlotArea,
                  totalNoOfSoldPlots: soldPlots,
                  totalNoOfUnSoldPlots: unsoldPlots,
                  totalNoPlots: totalNoOfPlots,
                  unSoldPlotsList: finalUnsoldPlotsList,
                  isSaveType: "submit");
              final jsonPayload = jsonEncode(payload.toJson());
              AppLogger().logDebug("submit $jsonPayload");
              if (!context.mounted) return;
              FinalSubmitResponse? submitResponse;
              if (AppConstants.isSavedApplication == "yes") {
                submitResponse =
                    await VillagewiseClusterInspectionFinalSubmitRepository()
                        .finalSavedSubmitApi(context, payload);
              } else {
                submitResponse = await ShortfallFinalSubmitRepository()
                    .finalSubmitApi(context, payload);
              }
              if (submitResponse != null) {
                if (submitResponse.statusCode == ApiErrorCodes.success) {
                  if (!context.mounted) return;
                  SuccessCustomCupertinoAlert().showAlert(
                      context: context,
                      title: submitResponse.statusMsg ?? "",
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.dashboard);
                      });
                  final captureGeoCoordinatesProvider =
                      Provider.of<CaptureGeoCoordinatesViewModelNew>(context,
                          listen: false);
                  captureGeoCoordinatesProvider.onClear(context);
                  clearSavedData(context);
                } else if (submitResponse.statusCode ==
                    ApiErrorCodes.badRequest) {
                  setLoaderVisibleStatus(false);
                  if (!context.mounted) return;
                  ErrorCustomCupertinoAlert().showAlert(
                    context,
                    message: submitResponse.statusMsg.toString(),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  setLoaderVisibleStatus(false);
                  if (!context.mounted) return;
                  ErrorCustomCupertinoAlert().showAlert(
                    context,
                    message: submitResponse.statusMsg ?? "",
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
          }
        }
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

  Future<List<ListMasterPlans>> getQuesCheckListFromSharedPreferences(
      String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedList = prefs.getString(name);
    if (encodedList != null) {
      List<dynamic> decodedList = jsonDecode(encodedList);
      questionsChecklist =
          decodedList.map((e) => ListMasterPlans.fromJson(e)).toList();
      AppLogger().logDebug(
          "questionsChecklististSize ::: ${questionsChecklist.length}");
      AppLogger().logDebug(
          "questionsChecklistList ::: ${jsonEncode(questionsChecklist)}");

      // final dataList = decodedList
      //     .map((itemJson) => CHECKLIST.fromJson(itemJson))
      //     .toList();
    }

    return questionsChecklist;
  }
}
