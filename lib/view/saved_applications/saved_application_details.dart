import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/res/reusable_widgets/checklist_question_tile_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/dropdown_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/officer_approval_status_reusable_widget.dart';
import 'package:lrsofficer/res/reusable_widgets/pdf_view_widget.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view/document_download.dart';
import 'dart:async';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/saved_application_details_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/upload_plot_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedApplicationDetails extends StatefulWidget {
  const SavedApplicationDetails({super.key});

  @override
  State<SavedApplicationDetails> createState() =>
      _SavedApplicationDetailsState();
}

class _SavedApplicationDetailsState extends State<SavedApplicationDetails> {
  ScrollController? scrollBarController;
  List<ListUnsoldPlots> unsoldPlotsList = [];
  TextEditingController layoutNameController = TextEditingController();
  TextEditingController layoutOwnerController = TextEditingController();
  TextEditingController ownerMobileNoController = TextEditingController();

  TextEditingController netPlotAreaExtentController = TextEditingController();
  TextEditingController totalUnsoldLayoutPlotsAreaController =
      TextEditingController();
  TextEditingController villageNameController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController surveyNoController = TextEditingController();
  TextEditingController zdpController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  // applicant details
  TextEditingController applicationNoController = TextEditingController();
  TextEditingController applicantNameController = TextEditingController();
  TextEditingController fatherOrSpouseNameController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  TextEditingController streetOrColonyController = TextEditingController();
  TextEditingController applicantLocalityController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController applicantMobileNoController = TextEditingController();

  // payment details
  TextEditingController conversionChargesController = TextEditingController();
  TextEditingController mvAsOn26082020Controller = TextEditingController();
  TextEditingController mvAsonDateOfRegistraionController =
      TextEditingController();
  TextEditingController regularizationChargesController =
      TextEditingController();
  TextEditingController openSpaceChargesController = TextEditingController();
  TextEditingController totalRegularizationChargesController =
      TextEditingController();
  TextEditingController initialAmountPaidController = TextEditingController();
  List<TextEditingController> officerApprovalControllers = [];
  List<TextEditingController> createdByControllers = [];
  List<TextEditingController> notesAddedControllers = [];
  TextEditingController l1RemarksController = TextEditingController();
  TextEditingController l2RemarksController = TextEditingController();
  TextEditingController l3RemarksController = TextEditingController();

  List titleList = ["appDetails".tr(), "plotDetails".tr(), "Document"];
  int? activeMeterIndex;
  // Expansion Panel
  final StreamController activeMeterIndexStreamControl =
      StreamController.broadcast();

  Stream get onUpdateActiveIndex => activeMeterIndexStreamControl.stream;

  void updateExpansionTile() =>
      activeMeterIndexStreamControl.sink.add(activeMeterIndex);

  @override
  Widget build(BuildContext context) {
    final clusterwiseApplDetailsProvider =
        Provider.of<SavedApplicationDetailsViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    return Stack(
      children: [
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              /* clusterwiseApplDetailsProvider.savedApplicationDetails.isNotEmpty
                  ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                      context,
                      message:
                          "Data of the Application ID : ${clusterwiseApplDetailsProvider.savedApplicationDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
                      onPressedOk: () {
                        clearSavedData(context);
                        //dialog pop
                        Navigator.pop(
                          context,
                        );
                        //page Pop
                        Navigator.pop(
                          context,
                        );
                      },
                      onPressedCancel: () {
                        Navigator.pop(context);
                      },
                    )
                  :  */
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: AppBarReusable(
              title: "Saved Application Details",
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  /* clusterwiseApplDetailsProvider
                          .savedApplicationDetails.isNotEmpty
                      ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                          context,
                          message:
                              "Data of the Application ID : ${clusterwiseApplDetailsProvider.savedApplicationDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
                          onPressedOk: () {
                            clearSavedData(context);
                            //dialog pop
                            Navigator.pop(
                              context,
                            );
                            //page Pop
                            Navigator.pop(
                              context,
                            );
                          },
                          onPressedCancel: () {
                            Navigator.pop(context);
                          },
                        )
                      : */
                  Navigator.pop(context);
                },
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.appBgScreens),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: titleList.length,
                        itemBuilder: (BuildContext context, int i) {
                          return StreamBuilder(
                              stream: onUpdateActiveIndex,
                              builder: (context, snapShot) {
                                return (i != 2)
                                    ? ExpansionPanelList(
                                        expandIconColor: AppColors.black,
                                        expandedHeaderPadding: EdgeInsets.zero,
                                        expansionCallback:
                                            (int index, bool status) {
                                          activeMeterIndex =
                                              snapShot.data == i ? null : i;
                                          updateExpansionTile();
                                        },
                                        children: [
                                          ExpansionPanel(
                                            canTapOnHeader: true,
                                            isExpanded: (i != 2)
                                                ? (snapShot.data == i)
                                                : true,
                                            headerBuilder:
                                                (BuildContext context,
                                                    bool isExpanded) {
                                              return ListTile(
                                                  title: getTitleCard(
                                                      titleList[i]));
                                            },
                                            body: (() {
                                              switch (i) {
                                                case 0: // Application Details
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: AppColors.white,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        AppInputTextfield(
                                                          hintText:
                                                              "applicationNo"
                                                                  .tr(),
                                                          nameController:
                                                              applicationNoController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "aplicantName"
                                                                  .tr(),
                                                          nameController:
                                                              applicantNameController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "father/SpouseName"
                                                                  .tr(),
                                                          nameController:
                                                              fatherOrSpouseNameController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "aadharNo".tr(),
                                                          nameController:
                                                              aadharNumberController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "Gender",
                                                          nameController:
                                                              genderController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "Address",
                                                          nameController:
                                                              addressController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "H.NO/Door No",
                                                          nameController:
                                                              houseNoController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Street/Colony",
                                                          nameController:
                                                              streetOrColonyController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "Locality",
                                                          nameController:
                                                              applicantLocalityController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Town/City/Village",
                                                          nameController:
                                                              townController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "District",
                                                          nameController:
                                                              districtController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "Pincode",
                                                          nameController:
                                                              pincodeController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "Mobile No",
                                                          nameController:
                                                              applicantMobileNoController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "E-Mail ID",
                                                          nameController:
                                                              clusterwiseApplDetailsProvider
                                                                  .emailIdController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Alternate Mobile Number",
                                                          nameController:
                                                              clusterwiseApplDetailsProvider
                                                                  .alternateMobileNoController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Total Plot Area/Extent in Sq.Yards",
                                                          nameController:
                                                              clusterwiseApplDetailsProvider
                                                                  .totalPlotAreaController,
                                                          isReadOnly: true,
                                                        ),
                                                        if (clusterwiseApplDetailsProvider
                                                            .getSavedApplicationDetails
                                                            .isNotEmpty)
                                                          Column(
                                                            children: [
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .sALEDEEDEC !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .sALEDEEDEC !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Sales Deed Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .sALEDEEDEC ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .cOPYOFLAYOUT !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .cOPYOFLAYOUT !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Layout Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .cOPYOFLAYOUT ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .oTHERSDOC !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .oTHERSDOC !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Other Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .oTHERSDOC ??
                                                                        ""),
                                                              if ((clusterwiseApplDetailsProvider.getSavedApplicationDetails[0].pROHIBITEDDOC1 != null && clusterwiseApplDetailsProvider.getSavedApplicationDetails[0].pROHIBITEDDOC1 != "") ||
                                                                  (clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC2 !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC2 !=
                                                                          "") ||
                                                                  (clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC3 !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC3 !=
                                                                          "") ||
                                                                  (clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC4 !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC4 !=
                                                                          "") ||
                                                                  (clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC5 !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC5 !=
                                                                          "") ||
                                                                  (clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .pROHIBITEDDOC6 !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[0]
                                                                              .pROHIBITEDDOC6 !=
                                                                          ""))
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8.0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      "Citizen Updated Document(Prohibited)",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC1 !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC1 !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Sale Deed Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .pROHIBITEDDOC1 ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC2 !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC2 !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Link Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .pROHIBITEDDOC2 ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC3 !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC3 !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Layout Copy",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .pROHIBITEDDOC3 ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC4 !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC4 !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Plot site plan",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .pROHIBITEDDOC4 ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC5 !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC5 !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Other Document 1",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .pROHIBITEDDOC5 ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC6 !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .pROHIBITEDDOC6 !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Other Document 2",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .pROHIBITEDDOC6 ??
                                                                        ""),
                                                              if ((clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .prohibittedAdditionalDoc1 !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .prohibittedAdditionalDoc1 !=
                                                                          "") ||
                                                                  (clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .prohibittedAdditionalDoc2 !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[0]
                                                                              .prohibittedAdditionalDoc2 !=
                                                                          ""))
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8.0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      "Additional Documents",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              if ((clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .prohibittedAdditionalDoc1 !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .prohibittedAdditionalDoc1 !=
                                                                      ""))
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Additional Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .prohibittedAdditionalDoc1 ??
                                                                        ""),
                                                              if ((clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .prohibittedAdditionalDoc2 !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .prohibittedAdditionalDoc2 !=
                                                                      ""))
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Additional Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .prohibittedAdditionalDoc2 ??
                                                                        ""),
                                                              if ((clusterwiseApplDetailsProvider.getSavedApplicationDetails[0].sLAYOUTDOC != null && clusterwiseApplDetailsProvider.getSavedApplicationDetails[0].sLAYOUTDOC != "") ||
                                                                  (clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .sECDOC !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .sECDOC !=
                                                                          "") ||
                                                                  (clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[
                                                                                  0]
                                                                              .sOWNERSHIPDOC !=
                                                                          null &&
                                                                      clusterwiseApplDetailsProvider
                                                                              .getSavedApplicationDetails[0]
                                                                              .sOWNERSHIPDOC !=
                                                                          ""))
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8.0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      "Citizen Updated Documents(Shortfall)",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .sLAYOUTDOC !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .sLAYOUTDOC !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Shortfall Layout Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .sLAYOUTDOC ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .sECDOC !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .sECDOC !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Shortfall EC Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .sECDOC ??
                                                                        ""),
                                                              if (clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .sOWNERSHIPDOC !=
                                                                      null &&
                                                                  clusterwiseApplDetailsProvider
                                                                          .getSavedApplicationDetails[
                                                                              0]
                                                                          .sOWNERSHIPDOC !=
                                                                      "")
                                                                BuildDocumentView(
                                                                    title:
                                                                        "Shortfall Ownership Document",
                                                                    pdfUrl: clusterwiseApplDetailsProvider
                                                                            .getSavedApplicationDetails[0]
                                                                            .sOWNERSHIPDOC ??
                                                                        ""),
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                  );
                                                case 1: // Plot Details
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: AppColors.white,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Layout Name",
                                                          nameController:
                                                              layoutNameController,
                                                          isReadOnly: true,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Layout Owner/Plot owner Name",
                                                          nameController:
                                                              layoutOwnerController,
                                                          isReadOnly: true,
                                                          textColor:
                                                              Colors.grey,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Owner Mobile Number",
                                                          nameController:
                                                              ownerMobileNoController,
                                                          isReadOnly: true,
                                                          textColor:
                                                              Colors.grey,
                                                        ),
                                                        if (AppConstants
                                                                .isLayoutPlot ==
                                                            "P")
                                                          //plot related data
                                                          Column(
                                                            children: [
                                                              AppInputTextfield(
                                                                hintText:
                                                                    "Plot No",
                                                                nameController:
                                                                    clusterwiseApplDetailsProvider
                                                                        .plotNoController,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  AppInputTextfield(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter
                                                                          .allow(
                                                                              RegExp(r'^\d+\.?\d{0,2}')),
                                                                    ],
                                                                    hintText:
                                                                        "Plot Area Extent Sq.Yards(As on Ground)*",
                                                                    nameController:
                                                                        clusterwiseApplDetailsProvider
                                                                            .plotAreaExtentController,
                                                                    inputType: const TextInputType
                                                                        .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                    onChanged:
                                                                        (p0) {
                                                                      num plotArea =
                                                                          num.tryParse(p0) ??
                                                                              0;
                                                                      num roadEffectedArea =
                                                                          num.tryParse(clusterwiseApplDetailsProvider.roadEffectedAreaExtentController.text) ??
                                                                              0;
                                                                      if (roadEffectedArea <
                                                                          plotArea) {
                                                                        if (plotArea -
                                                                                roadEffectedArea >
                                                                            0) {
                                                                          num netplotArea =
                                                                              plotArea - roadEffectedArea;
                                                                          netPlotAreaExtentController.text =
                                                                              "$netplotArea";
                                                                        } else {
                                                                          clusterwiseApplDetailsProvider
                                                                              .plotAreaExtentController
                                                                              .clear();
                                                                          netPlotAreaExtentController
                                                                              .clear();
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                        }
                                                                      } else {
                                                                        clusterwiseApplDetailsProvider
                                                                            .roadEffectedAreaExtentController
                                                                            .clear();
                                                                        netPlotAreaExtentController
                                                                            .clear();
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        ValidationIoSAlert().showAlert(
                                                                            context,
                                                                            description:
                                                                                "Plot Area cannot be less than road effected area");
                                                                      }
                                                                    },
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          AppRoutes
                                                                              .viewMapPolygon,
                                                                          arguments:
                                                                              applicationNoController.text);
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                      AppAssets
                                                                          .viewmap,
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              AppInputTextfield(
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          r'^\d+\.?\d{0,2}')),
                                                                ],
                                                                hintText:
                                                                    "Road Effected Area Extent Sq.Yards*",
                                                                nameController:
                                                                    clusterwiseApplDetailsProvider
                                                                        .roadEffectedAreaExtentController,
                                                                inputType:
                                                                    const TextInputType
                                                                        .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                onChanged:
                                                                    (value) async {
                                                                  num plotArea =
                                                                      num.tryParse(clusterwiseApplDetailsProvider
                                                                              .plotAreaExtentController
                                                                              .text) ??
                                                                          0;
                                                                  num roadEffectedArea =
                                                                      num.tryParse(
                                                                              value) ??
                                                                          0;

                                                                  if (plotArea >
                                                                      0) {
                                                                    if (plotArea -
                                                                            roadEffectedArea >
                                                                        0) {
                                                                      num netplotArea =
                                                                          plotArea -
                                                                              roadEffectedArea;
                                                                      netPlotAreaExtentController
                                                                              .text =
                                                                          netplotArea
                                                                              .toStringAsFixed(2);
                                                                    } else {
                                                                      clusterwiseApplDetailsProvider
                                                                          .roadEffectedAreaExtentController
                                                                          .clear();
                                                                      netPlotAreaExtentController
                                                                          .clear();
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();
                                                                      ValidationIoSAlert().showAlert(
                                                                          context,
                                                                          description:
                                                                              "Road Effected Area should be less than Plot Area");
                                                                    }
                                                                  } else {
                                                                    clusterwiseApplDetailsProvider
                                                                        .roadEffectedAreaExtentController
                                                                        .clear();
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    ValidationIoSAlert().showAlert(
                                                                        context,
                                                                        description:
                                                                            "Please Enter Plot Area");
                                                                  }
                                                                },
                                                              ),
                                                              AppInputTextfield(
                                                                hintText:
                                                                    "Net plot Area Extent Sq.Yards",
                                                                nameController:
                                                                    netPlotAreaExtentController,
                                                                isReadOnly:
                                                                    true,
                                                                textColor:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                        if (AppConstants
                                                                .isLayoutPlot ==
                                                            "L")
                                                          //Layout related data
                                                          Column(
                                                            children: [
                                                              QuestionTile(
                                                                question:
                                                                    "Do you want to enter Unsold plot Details",
                                                                selectedAnswer:
                                                                    clusterwiseApplDetailsProvider
                                                                        .selectedUnsoldPlotDetails,
                                                                onChanged:
                                                                    (value) {
                                                                  clusterwiseApplDetailsProvider
                                                                      .totalNoOfLayoutPlotsController
                                                                      .clear();
                                                                  clusterwiseApplDetailsProvider
                                                                      .soldLayoutPlotsController
                                                                      .clear();
                                                                  clusterwiseApplDetailsProvider
                                                                      .unSoldLayoutPlotsController
                                                                      .clear();
                                                                  clusterwiseApplDetailsProvider
                                                                      .changeUnsoldPlotDetails(
                                                                          value);
                                                                },
                                                              ),
                                                              AppInputTextfield(
                                                                hintText:
                                                                    "Total No of Plots",
                                                                length: 10,
                                                                nameController:
                                                                    clusterwiseApplDetailsProvider
                                                                        .totalNoOfLayoutPlotsController,
                                                                inputType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ],
                                                                onChanged:
                                                                    (p0) {
                                                                  clusterwiseApplDetailsProvider
                                                                      .soldLayoutPlotsController
                                                                      .clear();
                                                                  clusterwiseApplDetailsProvider
                                                                      .unSoldLayoutPlotsController
                                                                      .clear();
                                                                },
                                                              ),
                                                              AppInputTextfield(
                                                                length: 10,
                                                                hintText:
                                                                    "Sold Plots",
                                                                inputType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ],
                                                                nameController:
                                                                    clusterwiseApplDetailsProvider
                                                                        .soldLayoutPlotsController,
                                                                onChanged:
                                                                    (p0) {
                                                                  final totalPlots =
                                                                      (int.tryParse(clusterwiseApplDetailsProvider
                                                                              .totalNoOfLayoutPlotsController
                                                                              .text) ??
                                                                          0);
                                                                  final soldPlots =
                                                                      (int.tryParse(clusterwiseApplDetailsProvider
                                                                              .soldLayoutPlotsController
                                                                              .text) ??
                                                                          0);
                                                                  if (totalPlots >
                                                                      soldPlots) {
                                                                    clusterwiseApplDetailsProvider
                                                                        .unSoldLayoutPlotsController
                                                                        .text = (totalPlots -
                                                                            soldPlots)
                                                                        .toString();
                                                                  } else {
                                                                    ErrorCustomCupertinoAlert()
                                                                        .showAlert(
                                                                      context,
                                                                      message:
                                                                          "Sold plots cannot be greater than total No.of plots",
                                                                      onPressed:
                                                                          () {
                                                                        clusterwiseApplDetailsProvider
                                                                            .soldLayoutPlotsController
                                                                            .clear();
                                                                        clusterwiseApplDetailsProvider
                                                                            .unSoldLayoutPlotsController
                                                                            .clear();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              AppInputTextfield(
                                                                length: 10,
                                                                isReadOnly:
                                                                    true,
                                                                hintText:
                                                                    "Unsold Plots",
                                                                nameController:
                                                                    clusterwiseApplDetailsProvider
                                                                        .unSoldLayoutPlotsController,
                                                              ),
                                                              clusterwiseApplDetailsProvider
                                                                          .selectedUnsoldPlotDetails ==
                                                                      'N'
                                                                  ? Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              AppInputTextfield(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.85,
                                                                            length:
                                                                                10,
                                                                            hintText:
                                                                                "Total Unsold Plots Area(Sq.Yrds)",
                                                                            nameController:
                                                                                totalUnsoldLayoutPlotsAreaController,
                                                                            inputFormatters: [
                                                                              FilteringTextInputFormatter.digitsOnly
                                                                            ],
                                                                            inputType:
                                                                                TextInputType.number,
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pushNamed(context,
                                                                                AppRoutes.viewMapPolygon,
                                                                                arguments: applicationNoController.text);
                                                                          },
                                                                          child:
                                                                              Image.asset(
                                                                            AppAssets.viewmap,
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                30,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Village Name",
                                                          nameController:
                                                              villageNameController,
                                                          isReadOnly: true,
                                                          textColor:
                                                              Colors.grey,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "Locality",
                                                          nameController:
                                                              localityController,
                                                          isReadOnly: true,
                                                          textColor:
                                                              Colors.grey,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText:
                                                              "Survey Number",
                                                          nameController:
                                                              surveyNoController,
                                                          isReadOnly: true,
                                                          textColor:
                                                              Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 8.0),
                                                          child: DropdownReusable<
                                                                  ListMasterPlansZDP>(
                                                              label:
                                                                  "Land use as per Master Plan/ZDP *",
                                                              items: clusterwiseApplDetailsProvider
                                                                  .listMasterPlansZDP
                                                                  .map<
                                                                      DropdownMenuItem<
                                                                          ListMasterPlansZDP>>(
                                                                (ListMasterPlansZDP
                                                                    item) {
                                                                  return DropdownMenuItem<
                                                                      ListMasterPlansZDP>(
                                                                    value: item,
                                                                    child: Text(
                                                                      item.landUseName ??
                                                                          "",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  );
                                                                },
                                                              ).toList(),
                                                              onChanged: (ListMasterPlansZDP?
                                                                  newValue) async {
                                                                clusterwiseApplDetailsProvider
                                                                    .changeMasterPlanZDP(
                                                                        newValue);
                                                              },
                                                              selectedValue:
                                                                  clusterwiseApplDetailsProvider
                                                                      .selectedListMasterPlansZDP,
                                                              isEnabled: true),
                                                        ),
                                                        /*  : AppInputTextfield(
                                                                hintText:
                                                                    "Land use as per Master Plan/ZDP",
                                                                nameController:
                                                                    zdpController,
                                                                isReadOnly: true,
                                                              ), */
                                                        AppInputTextfield(
                                                          hintText: "Latitude",
                                                          isReadOnly: true,
                                                          nameController:
                                                              latitudeController,
                                                        ),
                                                        AppInputTextfield(
                                                          hintText: "Longitude",
                                                          isReadOnly: true,
                                                          nameController:
                                                              longitudeController,
                                                        ),
                                                        if (l1RemarksController
                                                            .text.isNotEmpty)
                                                          AppInputTextfield(
                                                            hintText:
                                                                "L1 Remarks",
                                                            maxLines: null,
                                                            // height: 80,
                                                            nameController:
                                                                l1RemarksController,
                                                            isReadOnly: true,
                                                            textColor:
                                                                Colors.grey,
                                                          ),
                                                        if (l2RemarksController
                                                            .text.isNotEmpty)
                                                          AppInputTextfield(
                                                            hintText:
                                                                "L2 Remarks",
                                                            maxLines: null,
                                                            // height: 80,
                                                            nameController:
                                                                l2RemarksController,
                                                            isReadOnly: true,
                                                            textColor:
                                                                Colors.grey,
                                                          ),
                                                        if (l3RemarksController
                                                            .text.isNotEmpty)
                                                          AppInputTextfield(
                                                            hintText:
                                                                "L3 Remarks",
                                                            maxLines: null,
                                                            // height: 80,
                                                            nameController:
                                                                l3RemarksController,
                                                            isReadOnly: true,
                                                            textColor:
                                                                Colors.grey,
                                                          ),
                                                        if ((clusterwiseApplDetailsProvider
                                                                .getSavedApplicationDetails)
                                                            .isNotEmpty)
                                                          if ((clusterwiseApplDetailsProvider
                                                                      .getSavedApplicationDetails[
                                                                          0]
                                                                      .officersComments ??
                                                                  [])
                                                              .isNotEmpty)
                                                            OfficerApprovalStatusReusableWidget(
                                                                officerApprovalStatus:
                                                                    officerApprovalControllers,
                                                                officerIds:
                                                                    createdByControllers,
                                                                officerRemarks:
                                                                    notesAddedControllers),
                                                      ],
                                                    ),
                                                  );

                                                default:
                                                  return Container(); // Default case, if needed
                                              }
                                            })(),
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.98,
                                        child: Card(
                                          elevation: 4.0,
                                          child: Column(
                                            children: [
                                              getTitleCard(
                                                "Sale Deed Document Download",
                                              ),
                                              if (clusterwiseApplDetailsProvider
                                                  .getSavedApplicationDetails
                                                  .isNotEmpty)
                                                Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: DocumentDownload(
                                                    sroEditFlag:
                                                        clusterwiseApplDetailsProvider
                                                                .getSavedApplicationDetails[
                                                                    0]
                                                                .sroCodeEdit ??
                                                            "",
                                                    callbackValue: (p0) {
                                                      clusterwiseApplDetailsProvider
                                                          .setSroEdited(p0);
                                                    },
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                              });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ReusableButton(
                width: double.infinity,
                buttonText: "Next",
                onPressed: () async {
                  final sroCode = await LocalStoreHelper()
                      .readTheData(SharedPrefConstants.sroCode);
                  if (!context.mounted) return;
                  clusterwiseApplDetailsProvider.navigateToUploadDocsScreen(
                      context,
                      applicationId: applicationNoController.text,
                      plotNo:
                          clusterwiseApplDetailsProvider.plotNoController.text,
                      areaExtent: netPlotAreaExtentController.text,
                      plotAreaExtent: clusterwiseApplDetailsProvider
                          .plotAreaExtentController.text,
                      roadAreaExtent: clusterwiseApplDetailsProvider
                          .roadEffectedAreaExtentController.text,
                      masterplanZdp: clusterwiseApplDetailsProvider
                              .selectedListMasterPlansZDP?.landUseName ??
                          "",
                      applicationDetails: clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0],
                      layoutName: layoutNameController.text,
                      soldPlots: clusterwiseApplDetailsProvider
                          .soldLayoutPlotsController.text,
                      totalNoOfPlots: clusterwiseApplDetailsProvider
                          .totalNoOfLayoutPlotsController.text,
                      totalUnsoldPlotArea:
                          totalUnsoldLayoutPlotsAreaController.text,
                      unsoldPlots: clusterwiseApplDetailsProvider
                          .unSoldLayoutPlotsController.text,
                      sroCode: sroCode);
                },
              ),
            ),
          ),
        ),
        if (clusterwiseApplDetailsProvider.getLoaderVisibilityStatus ||
            documentDownloadProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
      ],
    );
  }

  @override
  void dispose() {
    scrollBarController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final clusterwiseApplDetailsProvider =
          Provider.of<SavedApplicationDetailsViewModel>(context, listen: false);
      clusterwiseApplDetailsProvider.setLoaderVisibleStatus(true);
      final uploadPlotDetailsProvider =
          Provider.of<UploadPlotDetailsViewModel>(context, listen: false);
      final locEnabled =
          await uploadPlotDetailsProvider.handleLocationPermission(context);
      if (locEnabled) {
        final currentPos = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
        );
        if (!mounted) return;
        await clusterwiseApplDetailsProvider
            .getListOfMasterPlansZDPDetails(context);
        if (!mounted) return;
        await clusterwiseApplDetailsProvider.getSavedApplicationDetailsApi(
          context,
        );
        if (clusterwiseApplDetailsProvider
            .getSavedApplicationDetails.isNotEmpty) {
          activeMeterIndex = 1;
          unsoldPlotsList = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].listUnsoldPlots ??
              [];
          if (unsoldPlotsList.isNotEmpty) {
            clusterwiseApplDetailsProvider.changeUnsoldPlotDetails('Y');
          } else {
            clusterwiseApplDetailsProvider.changeUnsoldPlotDetails('N');
          }
          await LocalStoreHelper().writeData(
              SharedPrefConstants.sroCode,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].sROCODEFOURDIGITS ??
                  "");
          await LocalStoreHelper().writeData(
              SharedPrefConstants.saleDeedNo,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].sALEDEEDNUMBER ??
                  "");

          await LocalStoreHelper().writeData(
              SharedPrefConstants.saleDeedYear,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].sALEDEEDYEAR ??
                  "");
          layoutNameController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].lAYOUTNAME ??
              "";
          layoutOwnerController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].lAYOUTOWNERNAME ??
              "";
          ownerMobileNoController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].oWNERMOBILENUMBER ??
              "";
          clusterwiseApplDetailsProvider.plotNoController.text =
              clusterwiseApplDetailsProvider.plotNoController.text.isNotEmpty
                  ? clusterwiseApplDetailsProvider.plotNoController.text
                  : clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].pLOTNO ??
                      "";
          netPlotAreaExtentController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].aREAEXTENT ??
              "";
          clusterwiseApplDetailsProvider.plotAreaExtentController.text =
              clusterwiseApplDetailsProvider
                      .plotAreaExtentController.text.isNotEmpty
                  ? clusterwiseApplDetailsProvider.plotAreaExtentController.text
                  : (clusterwiseApplDetailsProvider
                                  .getSavedApplicationDetails[0]
                                  .pLOTAREAEXTENT ??
                              "".trim())
                          .isEmpty
                      ? clusterwiseApplDetailsProvider
                              .getSavedApplicationDetails[0].aREAEXTENT ??
                          ""
                      : clusterwiseApplDetailsProvider
                              .getSavedApplicationDetails[0].pLOTAREAEXTENT ??
                          "";
          clusterwiseApplDetailsProvider.roadEffectedAreaExtentController.text =
              clusterwiseApplDetailsProvider
                      .roadEffectedAreaExtentController.text.isNotEmpty
                  ? clusterwiseApplDetailsProvider
                      .roadEffectedAreaExtentController.text
                  : clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].rOADAREAEXTENT ??
                      "";
          addressController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].aPPLICANTADDRESS ??
              "";

          //layout
          clusterwiseApplDetailsProvider.totalNoOfLayoutPlotsController.text =
              clusterwiseApplDetailsProvider
                      .totalNoOfLayoutPlotsController.text.isNotEmpty
                  ? clusterwiseApplDetailsProvider
                      .totalNoOfLayoutPlotsController.text
                  : clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].totalNoPlots ??
                      "";
          clusterwiseApplDetailsProvider.soldLayoutPlotsController.text =
              clusterwiseApplDetailsProvider
                      .soldLayoutPlotsController.text.isNotEmpty
                  ? clusterwiseApplDetailsProvider.soldLayoutPlotsController.text
                  : clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].totalNoSoldPlots ??
                      "";
          clusterwiseApplDetailsProvider.unSoldLayoutPlotsController.text =
              clusterwiseApplDetailsProvider
                      .unSoldLayoutPlotsController.text.isNotEmpty
                  ? clusterwiseApplDetailsProvider
                      .unSoldLayoutPlotsController.text
                  : clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].totalNoUnSoldPlots ??
                  "";
          totalUnsoldLayoutPlotsAreaController.text =
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].totalNoAreaExtent ??
                  "";

          //layout
          villageNameController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].vILLAGENAME ??
              "";
          localityController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].lOCALITY ??
              "";
          surveyNoController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].sURVEYNUMBER ??
              "";
          // application details
          applicationNoController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].aPPLICATIONID ??
              "";
          applicantNameController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].lAYOUTOWNERNAME ??
              "";
          fatherOrSpouseNameController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].fATHERHUSBANDNAME ??
              "";
          aadharNumberController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].aADHARNUMBER ??
              "";
          genderController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].gENDER ??
              "";
          houseNoController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].hNODOORNO ??
              "";
          streetOrColonyController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].sTREETCOLONY ??
              "";
          applicantLocalityController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].lOCALITY ??
              "";
          townController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].vILLAGENAME ??
              "";
          applicationNoController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].aPPLICATIONID ??
              "";
          zdpController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].mASTERPLANZDP ??
              "";

          l1RemarksController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].l1Remarks ??
              "";
          l2RemarksController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].l2Remarks ??
              "";
          l3RemarksController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].l3Remarks ??
              "";
          if (zdpController.text.isNotEmpty) {
            if (clusterwiseApplDetailsProvider.selectedListMasterPlansZDP ==
                    null ||
                clusterwiseApplDetailsProvider
                        .selectedListMasterPlansZDP?.landUseId ==
                    "0" ||
                (clusterwiseApplDetailsProvider
                        .selectedListMasterPlansZDP?.landUseId?.isEmpty ??
                    true)) {
              clusterwiseApplDetailsProvider.selectedListMasterPlansZDP =
                  clusterwiseApplDetailsProvider.listMasterPlansZDP.firstWhere(
                (element) {
                  return (element.landUseId == zdpController.text ||
                      element.landUseName?.toLowerCase() ==
                          zdpController.text.toLowerCase());
                },
                orElse: () =>
                    clusterwiseApplDetailsProvider.listMasterPlansZDP[0],
              );
            }
          }
          districtController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].dISTRICTNAME ??
              "";
          pincodeController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].pINCODE ??
              "";
          applicantMobileNoController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].oWNERMOBILENUMBER ??
              "";
          clusterwiseApplDetailsProvider.emailIdController.text =
              clusterwiseApplDetailsProvider.emailIdController.text.isNotEmpty
                  ? clusterwiseApplDetailsProvider.emailIdController.text
                  : clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].eMAILID ??
                      "";
          clusterwiseApplDetailsProvider
              .alternateMobileNoController.text = clusterwiseApplDetailsProvider
                  .alternateMobileNoController.text.isNotEmpty
              ? clusterwiseApplDetailsProvider.alternateMobileNoController.text
              : clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].aLTERMOBILENO ??
                  "";
          clusterwiseApplDetailsProvider.totalPlotAreaController.text =
              clusterwiseApplDetailsProvider
                      .totalPlotAreaController.text.isNotEmpty
                  ? clusterwiseApplDetailsProvider.totalPlotAreaController.text
                  : clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].pLOTAREAEXTENT ??
                      "";
          // payment details
          conversionChargesController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].conversionCharges ??
              "";
          mvAsOn26082020Controller.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].mVRATE2020 ??
              "";
          mvAsonDateOfRegistraionController.text =
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].mVRATEDOCUMET ??
                  "";
          regularizationChargesController.text =
              clusterwiseApplDetailsProvider.getSavedApplicationDetails[0].rC ??
                  "";
          openSpaceChargesController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].pLOTOPENSPACE ??
              "";
          totalRegularizationChargesController.text =
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].tRC ??
                  "";
          initialAmountPaidController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].iNITIALPAYMENTAMOUNT ??
              "";
          latitudeController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].latitude ??
              "${currentPos.latitude}";
          longitudeController.text = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].longitude ??
              "${currentPos.longitude}";
          var officersCommentsList = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].officersComments ??
              [];

          for (var comment in officersCommentsList) {
            // Create a controller for each field in officersCommentsList
            officerApprovalControllers
                .add(TextEditingController(text: comment.aPPROVALFLAG ?? ""));
            createdByControllers
                .add(TextEditingController(text: comment.cREATEDBY ?? ""));
            notesAddedControllers
                .add(TextEditingController(text: comment.aDDNOTES ?? ""));
          }
          /*  officerApprovalController.text = (clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].officersComments ??
                      [])
                  .isNotEmpty
              ? (clusterwiseApplDetailsProvider.getSavedApplicationDetails[0]
                      .officersComments?[0].aPPROVALFLAG ??
                  "")
              : "";
          creartedByController.text = (clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].officersComments ??
                      [])
                  .isNotEmpty
              ? (clusterwiseApplDetailsProvider.getSavedApplicationDetails[0]
                      .officersComments?[0].cREATEDBY ??
                  "")
              : "";
          notesAddedController.text = (clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].officersComments ??
                      [])
                  .isNotEmpty
              ? (clusterwiseApplDetailsProvider.getSavedApplicationDetails[0]
                      .officersComments?[0].aDDNOTES ??
                  "")
              : ""; */
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final checkListStr = (clusterwiseApplDetailsProvider
                          .getSavedApplicationDetails[0].listSaveDatas !=
                      null &&
                  (clusterwiseApplDetailsProvider.getSavedApplicationDetails[0]
                              .listSaveDatas?.length ??
                          0) !=
                      0)
              ? jsonEncode(clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].listSaveDatas)
              : [];
          prefs.setString(
              SharedPrefConstants.checkListKey, checkListStr.toString());
          prefs.setString(
              SharedPrefConstants.layoutSelectedDocKey,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].lAYOUTDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.ecSelectedDocKey,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].eCDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.ownershipSelectedDocKey,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].oWNERSHIPDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot1Img,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].pHOTO1 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot2Img,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].pHOTO2 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot3Img,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].pHOTO3 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot4ImgMasterPlanExt,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].pHOTO4 ??
                  "");
          prefs.setString(
              SharedPrefConstants.gisCoordinatesList,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].gISCORDINATE ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvEditFlagKey,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].mvEditFlag ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvRate2020Key,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].mVRATE2020 ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvRateDocumentKey,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].mVRATEDOCUMET ??
                  "");
          prefs.setString(
              SharedPrefConstants.conversionChargesKey,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].conversionCharges ??
                  "");
          prefs.setString(
              SharedPrefConstants.applicationNo,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].aPPLICATIONID ??
                  "");
          prefs.setString(
              SharedPrefConstants.areaExtentKey,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].aREAEXTENT ??
                  "");
          prefs.setString(
              SharedPrefConstants.totalunsoldPlotAreakey,
              clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].totalNoAreaExtent ??
                  "");
          AppConstants.maxCoordinatesCount = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].maxCoordinatesCount ??
              "";
          AppConstants.minCoordinatesCount = clusterwiseApplDetailsProvider
                  .getSavedApplicationDetails[0].minCoordinatesCount ??
              "";
          if ((clusterwiseApplDetailsProvider
                      .getSavedApplicationDetails[0].officersComments ??
                  [])
              .isNotEmpty) {
            prefs.setString(
                SharedPrefConstants.recommendationsKey,
                clusterwiseApplDetailsProvider.getSavedApplicationDetails[0]
                        .officersComments?[0].aPPROVALFLAG ??
                    "");
            prefs.setString(
                SharedPrefConstants.notesKey,
                clusterwiseApplDetailsProvider.getSavedApplicationDetails[0]
                        .officersComments?[0].aDDNOTES ??
                    "");
          }
          activeMeterIndex = 1;
          updateExpansionTile();
          setState(() {});
        }
      }
    });
  }

  void clearSavedData(BuildContext context) {
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
    LocalStoreHelper().removeData(SharedPrefConstants.unsoldPlotsKey);
    LocalStoreHelper().removeData(SharedPrefConstants.totalAreaExtent);
  }

  Widget buildLabelValueRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for the label
            child: Text(
              "$label:",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black45),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "",
              softWrap: true, // Allows text to wrap within its bounds
            ),
          ),
        ],
      ),
    );
  }

  Widget getTitleCard(String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.98,
      child: Card(
        elevation: 4.0,
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
