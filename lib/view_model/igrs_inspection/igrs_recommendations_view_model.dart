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
import 'package:lrsofficer/repository/igrs_repo/igrs_final_submit_repository.dart';
import 'package:lrsofficer/repository/recommendations_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/internet_check_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/base64.dart';
import 'package:lrsofficer/utils/get_device_id.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/plots_layouts/add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IGRSRecommendationsViewModel with ChangeNotifier {
  List<RecommendationsListMasterPlans> recommendationListMasterPlans = [];
  RecommendationsListMasterPlans? selectedRecommendationValue;
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  List<ListMasterPlans> questionsChecklist = [];
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
    } catch (e) {
      AppLogger().logError("getRecommendationsDetails Error: $e");
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
  }

  void setDropdownValue(RecommendationsListMasterPlans? value) {
    selectedRecommendationValue = value;
    notifyListeners();
  }

  Future<void> finalSubmitMethod(BuildContext context, String? remarks) async {
    FocusScope.of(context).unfocus();
    //final submit validations
    //plot details upload

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final checklistQues = await getQuesCheckListFromSharedPreferences(
        SharedPrefConstants.questionsChecklist);
    String? layoutSelectedDoc =
        prefs.getString(SharedPrefConstants.layoutSelectedDocKey);
    String? ownershipSelectedDoc =
        prefs.getString(SharedPrefConstants.ownershipSelectedDocKey);
    String? ecSelectedDoc =
        prefs.getString(SharedPrefConstants.ecSelectedDocKey);

    // Retrieving values for checklist
    String? checkListString = prefs.getString(SharedPrefConstants.checkListKey);
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
    String? applicationId = prefs.getString(SharedPrefConstants.applicationNo);
    String? layoutName = prefs.getString(SharedPrefConstants.layoutNameKey);
    String? plotNo = prefs.getString(SharedPrefConstants.plotNoKey);
    String? areaExtent = prefs.getString(SharedPrefConstants.areaExtentKey);
    bool? marketValueFlag = prefs.getBool(SharedPrefConstants.marketValueFlag);
    final editedMv = prefs.getString(SharedPrefConstants.editedMv);
    final editedMvDateOfRegstn =
        prefs.getString(SharedPrefConstants.editedMvDateOfRegstn);
    final editedPlotAreaExtent =
        prefs.getString(SharedPrefConstants.editedPlotAreaExtent);
    final editedRoadAffectedArea =
        prefs.getString(SharedPrefConstants.editedRoadAffectedArea);
    final editedNetPlotArea =
        prefs.getString(SharedPrefConstants.editedNetPlotArea);
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
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter road effected area");
      } else if ((masterplanZdp ?? "").isEmpty ||
          (masterplanZdp ?? "").toLowerCase() == "please select") {
        if (!context.mounted) return;
        ValidationIoSAlert().showAlert(context,
            description: "Please select land use as per Master Plan/ZDP");
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
          /*  if ((conversionCharges == null || conversionCharges == '')) {
            if (!context.mounted) return;
            ValidationIoSAlert().showAlert(
              context,
              description: "enterConversionChargers".tr(),
            );
          } else */
          if ((marketValueFlag ?? false) &&
              (editedMv == null || editedMv == '')) {
            if (!context.mounted) return;

            ValidationIoSAlert().showAlert(
              context,
              description: "movOn26082020".tr(),
            );
          } else if ((marketValueFlag ?? false) &&
              (editedMvDateOfRegstn == null || editedMvDateOfRegstn == '')) {
            if (!context.mounted) return;

            ValidationIoSAlert().showAlert(
              context,
              description: "mvDateOFRegistration".tr(),
            );
          } else if ((marketValueFlag ?? false) &&
              (plotAreaExtent == null || plotAreaExtent == '')) {
            if (!context.mounted) return;

            ValidationIoSAlert().showAlert(
              context,
              description: "plotAreaExtent".tr(),
            );
          } else if ((marketValueFlag ?? false) &&
              (editedNetPlotArea == null || editedNetPlotArea == '')) {
            if (!context.mounted) return;

            ValidationIoSAlert().showAlert(
              context,
              description: "netplotAreaExtent".tr(),
            );
          } else if ((marketValueFlag ?? false) &&
              (editedRoadAffectedArea == null ||
                  editedRoadAffectedArea == '')) {
            if (!context.mounted) return;

            ValidationIoSAlert().showAlert(
              context,
              description: "roadEffectedArea".tr(),
            );
          } /*  else if ((isCalcutae == null || isCalcutae == false)) {
            if (!context.mounted) return;

            ValidationIoSAlert().showAlert(
              context,
              description: "calculatebtn".tr(),
            );
          } */
          else if (selectedRecommendationValue?.recommendation == null ||
              (selectedRecommendationValue?.recommendationValue ?? "")
                  .isEmpty ||
              (selectedRecommendationValue?.recommendationValue ?? "") == "0" ||
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
                  lAYOUTDOC: (layoutSelectedDoc ?? "").startsWith("http")
                      ? null
                      : layoutSelectedDoc,
                  oWNERSHIPDOC: (ownershipSelectedDoc ?? "").startsWith("http")
                      ? null
                      : ownershipSelectedDoc,
                  eCDOC: (ecSelectedDoc ?? "").startsWith("http")
                      ? null
                      : ecSelectedDoc,
                  pHOTO1: (plot1Img ?? "").startsWith("http") ? null : plot1Img,
                  pHOTO2: (plot2Img ?? "").startsWith("http") ? null : plot2Img,
                  pHOTO3: (plot3Img ?? "").startsWith("http") ? null : plot3Img,
                  pHOTO4: (plot4Img ?? "").startsWith("http") ? null : plot4Img,
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
                  updMVRate2020: editedMv,
                  updMvRateDoc: editedMvDateOfRegstn,
                  updAreaExtent: editedNetPlotArea,
                  updPlotAreaExtent: editedPlotAreaExtent,
                  updRoadAreaExtent: editedRoadAffectedArea,
                  // fifpFlag: AppConstants.IGRSFlag,
                  isSaveType: "submit");
              final jsonPayload = jsonEncode(payload.toJson());
              AppLogger().logDebug("submit $jsonPayload");
              if (!context.mounted) return;
              FinalSubmitResponse? submitResponse;

              submitResponse =
                  await IGRSFinalSubmit().finalSubmitApi(context, payload);

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
                  clearSavedData();
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
    } else {
      if (!context.mounted) return;
      submitApplication(context, checkList, remarks ?? "",
          selectedRecommendationValue?.recommendation, checklistQues);
    }
  }

  void clearSavedData() {
    final localStore = LocalStoreHelper();

    // All keys to clear
    final keysToClear = [
      // Application Details
      SharedPrefConstants.applicationNo,
      SharedPrefConstants.layoutNameKey,
      SharedPrefConstants.plotNoKey,
      SharedPrefConstants.areaExtentKey,
      SharedPrefConstants.plotAreaExtentKey,
      SharedPrefConstants.roadAreaExtentKey,
      SharedPrefConstants.masterplanZdpKey,
      SharedPrefConstants.latitudeKey,
      SharedPrefConstants.longitudeKey,

      // Upload Details
      SharedPrefConstants.layoutSelectedDocKey,
      SharedPrefConstants.ownershipSelectedDocKey,
      SharedPrefConstants.ecSelectedDocKey,
      SharedPrefConstants.plot1Img,
      SharedPrefConstants.plot2Img,
      SharedPrefConstants.plot3Img,
      SharedPrefConstants.plot4ImgMasterPlanExt,
      SharedPrefConstants.plot5ImgCaptureLocScreenshot,
      SharedPrefConstants.layoutDocumentradioVal,
      SharedPrefConstants.ownershipDocumetRadioVal,
      SharedPrefConstants.ecDocumentRadioVal,
      SharedPrefConstants.gisCoordinatesList,

      // Check Details
      SharedPrefConstants.checkListKey,
      SharedPrefConstants.questionsChecklist,

      // Payment Details
      SharedPrefConstants.srdpRdpKey,
      SharedPrefConstants.conversionChargesKey,
      SharedPrefConstants.mvRate2020Key,
      SharedPrefConstants.mvRateDocumentKey,
      SharedPrefConstants.rcKey,
      SharedPrefConstants.vltKey,
      SharedPrefConstants.plotOpenspaceKey,
      SharedPrefConstants.trcKey,
      SharedPrefConstants.mvEditFlagKey,
      SharedPrefConstants.isCalculate,
      SharedPrefConstants.marketValueFlag,
      SharedPrefConstants.editedMv,
      SharedPrefConstants.editedMvDateOfRegstn,
      SharedPrefConstants.editedPlotAreaExtent,
      SharedPrefConstants.editedRoadAffectedArea,
      SharedPrefConstants.editedNetPlotArea,

      // Recommendations
      SharedPrefConstants.additionalConditionKey,
      SharedPrefConstants.notesKey,
      SharedPrefConstants.conditionKey,
      SharedPrefConstants.recommendationsKey,

      // Layout
      SharedPrefConstants.totalNoOfPlotsKey,
      SharedPrefConstants.selectedUnsoldPlotKey,
      SharedPrefConstants.soldPlotsKey,
      SharedPrefConstants.unsoldPlotsKey,
      SharedPrefConstants.totalunsoldPlotAreakey,
      SharedPrefConstants.unsoldPlotListKey,
      SharedPrefConstants.totalAreaExtent,
    ];

    // Loop and remove
    for (var key in keysToClear) {
      localStore.removeData(key);
    }
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
            (selectedRecommendationValue?.recommendationValue ?? "").isEmpty ||
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
            final List<dynamic> unsoldListJson = jsonDecode(unsoldPlotListStr);
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
          final empID = await sharedpref.readTheData(SharedPrefConstants.empID);
          final tokenID =
              await sharedpref.readTheData(SharedPrefConstants.token);

          final ip = await GetDeviceId().getIpAddress();

          final dateRefId =
              DateFormat('ddMMyyyyHHmmssSSSS').format(DateTime.now());

          AppLogger().logDebug("dateRefId $dateRefId");
          if (!context.mounted) return;
          final lat = prefs.getString(SharedPrefConstants.latitudeKey);
          final long = prefs.getString(SharedPrefConstants.longitudeKey);
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
                sRDPRDP: "",
                conversionCharges: "",
                mVRATE2020: "",
                mVRATEDOCUMET: "",
                rC: "",
                vLT: "",
                pLOTOPENSPACE: "",
                tRC: "",
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
            AppLogger().logDebug("submit IGRS payload $jsonPayload");
            if (!context.mounted) return;
            FinalSubmitResponse? submitResponse;
            submitResponse =
                await IGRSFinalSubmit().finalSubmitApi(context, payload);
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
                clearSavedData();
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
