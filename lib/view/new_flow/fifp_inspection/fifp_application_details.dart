import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/res/reusable_widgets/dropdown_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/officer_approval_status_reusable_widget.dart';
import 'package:lrsofficer/res/reusable_widgets/otp_component.dart';
import 'package:lrsofficer/res/reusable_widgets/pdf_view_widget.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view/document_download.dart';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_application_details_view_model.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FifpApplicationDetails extends StatefulWidget {
  const FifpApplicationDetails({super.key});

  @override
  State<FifpApplicationDetails> createState() => _FifpApplicationDetailsState();
}

class _FifpApplicationDetailsState extends State<FifpApplicationDetails> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final fifpProvider = Provider.of<FifpApplicationDetailsViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    final updateMobileProvider = Provider.of<UpdateMobileNoViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          /* fifpProvider.clusterApplDetails.isNotEmpty
              ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                  context,
                  message:
                      "Data of the Application ID : ${fifpProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
              title: "Fee Paid Application Details",
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  /* WarningCustomCupertinoAlertTwoButtons().showAlert(
                    context,
                    message:
                        "Data of the Application ID : ${fifpProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
                  ); */
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: ExactAssetImage(AppAssets.appBg),
                  ),
                ),
                padding: const EdgeInsets.all(6.0),
                child: fifpProvider.clusterApplDetails.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.98,
                              child: Card(
                                elevation: 4.0,
                                child: ExpansionTile(
                                  dense: true,
                                  visualDensity:
                                      VisualDensity.adaptivePlatformDensity,
                                  tilePadding: const EdgeInsets.all(0),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getTitleCard(
                                        "Application Details",
                                        /*  style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ), */
                                      ),
                                      const SizedBox(height: 8.0),
                                      buildLabelValueRow("Application No",
                                          "${fifpProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${fifpProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${fifpProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${fifpProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${fifpProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${fifpProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${fifpProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl: fifpProvider
                                                .clusterApplDetails[0]
                                                .sALEDEEDEC ??
                                            ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl: fifpProvider
                                                .clusterApplDetails[0]
                                                .cOPYOFLAYOUT ??
                                            ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl: fifpProvider
                                                .clusterApplDetails[0]
                                                .oTHERSDOC ??
                                            ""),
                                    if ((fifpProvider.clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .sECDOC !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .sECDOC !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .sDOCOTHERS !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .sDOCOTHERS !=
                                                ""))
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Citizen Updated Document",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Layout Document",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .sLAYOUTDOC ??
                                              ""),
                                    if (fifpProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            null &&
                                        fifpProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall EC Document",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .sECDOC ??
                                              ""),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Ownership Document",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .sOWNERSHIPDOC ??
                                              ""),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .sDOCOTHERS !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .sDOCOTHERS !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Other Document",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .sDOCOTHERS ??
                                              ""),
                                    if ((fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC1 !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC1 !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC2 !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC2 !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC3 !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC3 !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC4 !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC4 !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC5 !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC5 !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC6 !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .pROHIBITEDDOC6 !=
                                                ""))
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Citizen Updated Document(Prohibited)",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC1 !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC1 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Sale Deed Document",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC1 ??
                                              ""),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC2 !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC2 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Link Document",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC2 ??
                                              ""),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC3 !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC3 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Layout Copy",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC3 ??
                                              ""),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC4 !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC4 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Plot site plan",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC4 ??
                                              ""),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC5 !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC5 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Other Document 1",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC5 ??
                                              ""),
                                    if (fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC6 !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .pROHIBITEDDOC6 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Other Document 2",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC6 ??
                                              ""),
                                    if ((fifpProvider.clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc1 !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc1 !=
                                                "") ||
                                        (fifpProvider.clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc2 !=
                                                null &&
                                            fifpProvider.clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc2 !=
                                                ""))
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Additional Documents",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if ((fifpProvider.clusterApplDetails[0]
                                                .prohibittedAdditionalDoc1 !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .prohibittedAdditionalDoc1 !=
                                            ""))
                                      BuildDocumentView(
                                          title: "Additional Document",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .prohibittedAdditionalDoc1 ??
                                              ""),
                                    if ((fifpProvider.clusterApplDetails[0]
                                                .prohibittedAdditionalDoc2 !=
                                            null &&
                                        fifpProvider.clusterApplDetails[0]
                                                .prohibittedAdditionalDoc2 !=
                                            ""))
                                      BuildDocumentView(
                                          title: "Additional Document",
                                          pdfUrl: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .prohibittedAdditionalDoc2 ??
                                              ""),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.98,
                              child: Card(
                                elevation: 4.0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      getTitleCard("Plot Details"),
                                      Column(
                                        children: [
                                          AppInputTextfield(
                                            isReadOnly:
                                                AppConstants.userType != "tp",
                                            textColor:
                                                AppConstants.userType != "tp"
                                                    ? Colors.grey
                                                    : Colors.black,
                                            hintText: "Layout Name",
                                            length: 100,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'^[A-Za-z0-9 _\-\/]{0,100}'))
                                            ],
                                            nameController: fifpProvider
                                                .layoutNameController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                            hintText:
                                                "Layout Owner/Plot owner Name",
                                            length: 100,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'^[A-Za-z0-9 _\-\/]{0,100}'))
                                            ],
                                            nameController: fifpProvider
                                                .layoutOwnerController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly:
                                                AppConstants.userType != "tp",
                                            textColor:
                                                AppConstants.userType != "tp"
                                                    ? Colors.grey
                                                    : Colors.black,
                                            hintText: "Plot No",
                                            length: 20,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'^[A-Za-z0-9 _\-\/]{0,100}'))
                                            ],
                                            nameController:
                                                fifpProvider.plotNoController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly:
                                                true /*  AppConstants.userType != "tp" */,
                                            textColor:
                                                /*   AppConstants.userType != "tp"
                                                    ? */
                                                Colors.grey,
                                            /* : Colors.black, */
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            hintText:
                                                "Plot Area Extent Sq.Yards(As on Ground)*",
                                            nameController: fifpProvider
                                                .plotAreaExtentController,
                                            inputType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            onChanged: (p0) {
                                              num plotArea =
                                                  num.tryParse(p0) ?? 0;
                                              num roadEffectedArea =
                                                  num.tryParse(fifpProvider
                                                          .roadEffectedAreaExtentController
                                                          .text) ??
                                                      0;
                                              if (roadEffectedArea < plotArea) {
                                                if (plotArea -
                                                        roadEffectedArea >
                                                    0) {
                                                  num netplotArea = plotArea -
                                                      roadEffectedArea;
                                                  fifpProvider
                                                      .netPlotAreaExtentController
                                                      .text = "$netplotArea";
                                                } else {
                                                  fifpProvider
                                                      .plotAreaExtentController
                                                      .clear();
                                                  fifpProvider
                                                      .netPlotAreaExtentController
                                                      .clear();
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                              } else {
                                                fifpProvider
                                                    .roadEffectedAreaExtentController
                                                    .clear();
                                                fifpProvider
                                                    .netPlotAreaExtentController
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
                                          AppInputTextfield(
                                            isReadOnly:
                                                true /* AppConstants.userType != "tp" */,
                                            textColor:
                                                /* AppConstants.userType != "tp"
                                                    ? */
                                                Colors.grey,
                                            /* : Colors.black, */
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            hintText:
                                                "Road Effected Area Extent Sq.Yards*",
                                            nameController: fifpProvider
                                                .roadEffectedAreaExtentController,
                                            inputType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            onChanged: (value) async {
                                              num plotArea = num.tryParse(
                                                      fifpProvider
                                                          .plotAreaExtentController
                                                          .text) ??
                                                  0;
                                              num roadEffectedArea =
                                                  num.tryParse(value) ?? 0;

                                              if (plotArea > 0) {
                                                if (plotArea -
                                                        roadEffectedArea >
                                                    0) {
                                                  num netplotArea = plotArea -
                                                      roadEffectedArea;
                                                  fifpProvider
                                                          .netPlotAreaExtentController
                                                          .text =
                                                      netplotArea
                                                          .toStringAsFixed(2);
                                                } else {
                                                  fifpProvider
                                                      .roadEffectedAreaExtentController
                                                      .clear();
                                                  fifpProvider
                                                      .netPlotAreaExtentController
                                                      .clear();
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  ValidationIoSAlert().showAlert(
                                                      context,
                                                      description:
                                                          "Road Effected Area should be less than Plot Area");
                                                }
                                              } else {
                                                fifpProvider
                                                    .roadEffectedAreaExtentController
                                                    .clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                ValidationIoSAlert().showAlert(
                                                    context,
                                                    description:
                                                        "Please Enter Plot Area");
                                              }
                                            },
                                          ),
                                          AppInputTextfield(
                                            isReadOnly:
                                                true /* AppConstants.userType != "tp" */,
                                            textColor:
                                                /*  AppConstants.userType != "tp"
                                                    ? */
                                                Colors
                                                    .grey /* : Colors.black */,
                                            hintText:
                                                "Net plot Area Extent Sq.Yards",
                                            nameController: fifpProvider
                                                .netPlotAreaExtentController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                            hintText: "Village Name",
                                            nameController: fifpProvider
                                                .villageNameController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                            hintText: "Locality",
                                            nameController:
                                                fifpProvider.localityController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                            hintText: "Survey Number",
                                            maxLines: null,
                                            // height: 80,
                                            nameController:
                                                fifpProvider.surveyNoController,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: DropdownReusable<
                                                ListMasterPlansZDP>(
                                              label:
                                                  "Land use as per Master Plan/ZDP *",
                                              isEnabled:
                                                  (AppConstants.userType ==
                                                          "tp")
                                                      ? true
                                                      : false,
                                              items: fifpProvider
                                                  .listMasterPlansZDP
                                                  .map<
                                                      DropdownMenuItem<
                                                          ListMasterPlansZDP>>(
                                                (ListMasterPlansZDP item) {
                                                  return DropdownMenuItem<
                                                      ListMasterPlansZDP>(
                                                    value: item,
                                                    child: Text(
                                                      item.landUseName ?? "",
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (ListMasterPlansZDP?
                                                  newValue) async {
                                                fifpProvider
                                                    .changeMasterPlanZDP(
                                                        newValue);
                                              },
                                              selectedValue: fifpProvider
                                                  .selectedListMasterPlansZDP,
                                            ),
                                          ),
                                          if (fifpProvider.l1RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                              hintText: "L1 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController: fifpProvider
                                                  .l1RemarksController,
                                            ),
                                          if (fifpProvider.l2RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                              hintText: "L2 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController: fifpProvider
                                                  .l2RemarksController,
                                            ),
                                          if (fifpProvider.l3RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                              hintText: "L3 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController: fifpProvider
                                                  .l3RemarksController,
                                            ),
                                          if ((fifpProvider.clusterApplDetails)
                                              .isNotEmpty)
                                            if ((fifpProvider.clusterApplDetails[0].officersComments ?? [])
                                                .isNotEmpty)
                                              OfficerApprovalStatusReusableWidget(
                                                  officerApprovalStatus:
                                                      fifpProvider
                                                          .officerApprovalControllers,
                                                  officerIds: fifpProvider
                                                      .createdByControllers,
                                                  officerRemarks: fifpProvider
                                                      .notesAddedControllers)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.98,
                              child: Card(
                                elevation: 4.0,
                                child: Column(
                                  children: [
                                    getTitleCard(
                                      "Sale Deed Document Download",
                                    ),
                                    if (fifpProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag: fifpProvider
                                                  .clusterApplDetails[0]
                                                  .sroCodeEdit ??
                                              "",
                                          callbackValue: (p0) async {
                                            fifpProvider.setSroEdited(p0);
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (AppConstants.userType == "tp")
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.98,
                                child: Card(
                                  elevation: 4.0,
                                  child: ExpansionTile(
                                    maintainState: isExpanded,
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        AppLogger().logDebug(
                                            "isExpandedVal:: $isExpanded");
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    dense: true,
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    tilePadding: const EdgeInsets.all(0),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getTitleCard(
                                          "Update Mobile Number",
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0),
                                          child: buildLabelValueRow(
                                              "Old Mobile Number",
                                              "${fifpProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      AppInputTextfield(
                                        isReadOnly:
                                            AppConstants.userType != "tp",
                                        textColor: AppConstants.userType != "tp"
                                            ? Colors.grey
                                            : Colors.black,
                                        nameController:
                                            fifpProvider.newMobileNoController,
                                        hintText: "New Mobile Number",
                                        inputType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        length: 10,
                                      ),
                                      ReusableButton(
                                        buttonText: "Send OTP",
                                        onPressed: () {
                                          if (fifpProvider.validateNewMobileNo(
                                              fifpProvider
                                                  .newMobileNoController,
                                              context)) {
                                            String mobileNumberNew =
                                                fifpProvider
                                                    .newMobileNoController.text;
                                            fifpProvider.newMobileNoController
                                                .clear();
                                            fifpProvider.getResendOtp(
                                                context, mobileNumberNew);

                                            showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext dialogContext) {
                                                return Dialog(
                                                  child: PopScope(
                                                    canPop: false,
                                                    child: OTPVerificationPage(
                                                      onValidatePressed: (otp) {
                                                        setState(() {
                                                          isExpanded =
                                                              !isExpanded;
                                                        });
                                                        fifpProvider
                                                            .validateOTp(
                                                          context,
                                                          dialogContext,
                                                          otp,
                                                          mobileNumberNew,
                                                        );
                                                      },
                                                      onCancelPressed: () {
                                                        Navigator.of(
                                                                dialogContext)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ReusableButton(
                                buttonText: "next".tr(),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (AppConstants.userType == "tp") {
                                    LocalStoreHelper sharedpref =
                                        LocalStoreHelper();
                                    await sharedpref.writeData(
                                        SharedPrefConstants.applicationNo,
                                        "${fifpProvider.clusterApplDetails[0].aPPLICATIONID}");
                                    await sharedpref.writeData(
                                      SharedPrefConstants.totalAreaExtent,
                                      fifpProvider
                                          .netPlotAreaExtentController.text,
                                    );
                                    final sroCode = await LocalStoreHelper()
                                        .readTheData(
                                            SharedPrefConstants.sroCode);
                                    if (!context.mounted) return;
                                    fifpProvider.navigateToUploadDocsScreen(
                                      context,
                                      applicationId: fifpProvider
                                              .clusterApplDetails[0]
                                              .aPPLICATIONID ??
                                          "",
                                      layoutName: fifpProvider
                                              .clusterApplDetails[0]
                                              .lAYOUTNAME ??
                                          "",
                                      plotNo:
                                          fifpProvider.plotNoController.text,
                                      areaExtent: fifpProvider
                                          .netPlotAreaExtentController.text
                                          .trim(),
                                      plotAreaExtent: fifpProvider
                                          .plotAreaExtentController.text
                                          .trim(),
                                      roadAreaExtent: fifpProvider
                                          .roadEffectedAreaExtentController.text
                                          .trim(),
                                      masterplanZdp: fifpProvider
                                              .selectedListMasterPlansZDP
                                              ?.landUseName ??
                                          "",
                                      sroCode: sroCode,
                                      layoutNmae: fifpProvider
                                          .layoutNameController.text,
                                      applicationDetails:
                                          fifpProvider.clusterApplDetails[0],
                                    );
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.fifpCheckList);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
          ),
          if (fifpProvider.getLoaderVisibilityStatus ||
              updateMobileProvider.getLoaderVisibilityStatus ||
              documentDownloadProvider.getLoaderVisibilityStatus)
            const LoaderComponent()
        ],
      ),
    );
  }

  Widget getTitleCard(String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        elevation: 4.0,
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
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
                fontWeight: FontWeight.bold,
              ),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final fifpProvider =
          Provider.of<FifpApplicationDetailsViewModel>(context, listen: false);

      if (!mounted) return;
      await fifpProvider.getListOfMasterPlansZDPDetails(context);
      if (!mounted) return;
      await fifpProvider.getClusterApplDetails(context);
      if (fifpProvider.clusterApplDetails.isNotEmpty) {
        await LocalStoreHelper().writeData(SharedPrefConstants.sroCode,
            fifpProvider.clusterApplDetails[0].sROCODEFOURDIGITS ?? "");
        await LocalStoreHelper().writeData(SharedPrefConstants.saleDeedNo,
            fifpProvider.clusterApplDetails[0].sALEDEEDNUMBER ?? "");

        await LocalStoreHelper().writeData(SharedPrefConstants.saleDeedYear,
            fifpProvider.clusterApplDetails[0].sALEDEEDYEAR ?? "");
        fifpProvider.layoutNameController.text =
            fifpProvider.layoutNameController.text.isNotEmpty
                ? fifpProvider.layoutNameController.text
                : fifpProvider.clusterApplDetails[0].lAYOUTNAME ?? "";
        fifpProvider.layoutOwnerController.text =
            fifpProvider.layoutOwnerController.text.isNotEmpty
                ? fifpProvider.layoutOwnerController.text
                : fifpProvider.clusterApplDetails[0].lAYOUTOWNERNAME ?? "";
        fifpProvider.plotNoController.text =
            fifpProvider.plotNoController.text.isNotEmpty
                ? fifpProvider.plotNoController.text
                : fifpProvider.clusterApplDetails[0].pLOTNO ?? "";
        fifpProvider.netPlotAreaExtentController.text =
            fifpProvider.netPlotAreaExtentController.text.isNotEmpty
                ? fifpProvider.netPlotAreaExtentController.text
                : fifpProvider.clusterApplDetails[0].aREAEXTENT ?? "";
        fifpProvider.plotAreaExtentController.text = fifpProvider
                .plotAreaExtentController.text.isNotEmpty
            ? fifpProvider.plotAreaExtentController.text
            : (fifpProvider.clusterApplDetails[0].pLOTAREAEXTENT ?? "".trim())
                    .isEmpty
                ? fifpProvider.clusterApplDetails[0].aREAEXTENT ?? ""
                : fifpProvider.clusterApplDetails[0].pLOTAREAEXTENT ?? "";
        fifpProvider.roadEffectedAreaExtentController.text =
            fifpProvider.roadEffectedAreaExtentController.text.isNotEmpty
                ? fifpProvider.roadEffectedAreaExtentController.text
                : fifpProvider.clusterApplDetails[0].rOADAREAEXTENT ?? "";
        fifpProvider.villageNameController.text =
            fifpProvider.villageNameController.text.isNotEmpty
                ? fifpProvider.villageNameController.text
                : fifpProvider.clusterApplDetails[0].vILLAGENAME ?? "";
        fifpProvider.localityController.text =
            fifpProvider.localityController.text.isNotEmpty
                ? fifpProvider.localityController.text
                : fifpProvider.clusterApplDetails[0].lOCALITY ?? "";
        fifpProvider.surveyNoController.text =
            fifpProvider.surveyNoController.text.isNotEmpty
                ? fifpProvider.surveyNoController.text
                : fifpProvider.clusterApplDetails[0].sURVEYNUMBER ?? "";
        fifpProvider.l1RemarksController.text =
            fifpProvider.l1RemarksController.text.isNotEmpty
                ? fifpProvider.l1RemarksController.text
                : fifpProvider.clusterApplDetails[0].l1Remarks ?? "";
        fifpProvider.l2RemarksController.text =
            fifpProvider.l2RemarksController.text.isNotEmpty
                ? fifpProvider.l2RemarksController.text
                : fifpProvider.clusterApplDetails[0].l2Remarks ?? "";
        fifpProvider.l3RemarksController.text =
            fifpProvider.l3RemarksController.text.isNotEmpty
                ? fifpProvider.l3RemarksController.text
                : fifpProvider.clusterApplDetails[0].l3Remarks ?? "";
        final zdp = fifpProvider.clusterApplDetails[0].mASTERPLANZDP ?? "";
        if (zdp.isNotEmpty) {
          if (fifpProvider.selectedListMasterPlansZDP == null ||
              fifpProvider.selectedListMasterPlansZDP?.landUseId == "0" ||
              (fifpProvider.selectedListMasterPlansZDP?.landUseId?.isEmpty ??
                  true)) {
            fifpProvider.selectedListMasterPlansZDP =
                fifpProvider.listMasterPlansZDP.firstWhere(
              (element) {
                return (element.landUseId == zdp ||
                    element.landUseName?.toLowerCase() == zdp.toLowerCase());
              },
              orElse: () => fifpProvider.listMasterPlansZDP[0],
            );
          }
        }
        var officersCommentsList =
            fifpProvider.clusterApplDetails[0].officersComments ?? [];
        if (fifpProvider.officerApprovalControllers.isEmpty) {
          for (var comment in officersCommentsList) {
            // Create a controller for each field in officersCommentsList
            fifpProvider.officerApprovalControllers
                .add(TextEditingController(text: comment.aPPROVALFLAG ?? ""));
            fifpProvider.createdByControllers
                .add(TextEditingController(text: comment.cREATEDBY ?? ""));
            fifpProvider.notesAddedControllers
                .add(TextEditingController(text: comment.aDDNOTES ?? ""));
          }
        }

        await LocalStoreHelper().writeData(SharedPrefConstants.sroCode,
            fifpProvider.clusterApplDetails[0].sROCODEFOURDIGITS ?? "");
        await LocalStoreHelper().writeData(SharedPrefConstants.saleDeedNo,
            fifpProvider.clusterApplDetails[0].sALEDEEDNUMBER ?? "");
        await LocalStoreHelper().writeData(SharedPrefConstants.saleDeedYear,
            fifpProvider.clusterApplDetails[0].sALEDEEDYEAR ?? "");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final checkListStr =
            (fifpProvider.clusterApplDetails[0].listSaveDatas != null &&
                    (fifpProvider.clusterApplDetails[0].listSaveDatas?.length ??
                            0) !=
                        0)
                ? jsonEncode(fifpProvider.clusterApplDetails[0].listSaveDatas)
                : [];
        prefs.setString(
            SharedPrefConstants.checkListKey, checkListStr.toString());
        prefs.setString(SharedPrefConstants.layoutSelectedDocKey,
            fifpProvider.clusterApplDetails[0].lAYOUTDOC ?? "");
        prefs.setString(SharedPrefConstants.ecSelectedDocKey,
            fifpProvider.clusterApplDetails[0].eCDOC ?? "");
        prefs.setString(SharedPrefConstants.ownershipSelectedDocKey,
            fifpProvider.clusterApplDetails[0].oWNERSHIPDOC ?? "");
        prefs.setString(SharedPrefConstants.plot1Img,
            fifpProvider.clusterApplDetails[0].pHOTO1 ?? "");
        prefs.setString(SharedPrefConstants.plot2Img,
            fifpProvider.clusterApplDetails[0].pHOTO2 ?? "");
        prefs.setString(SharedPrefConstants.plot3Img,
            fifpProvider.clusterApplDetails[0].pHOTO3 ?? "");
        prefs.setString(SharedPrefConstants.plot4ImgMasterPlanExt,
            fifpProvider.clusterApplDetails[0].pHOTO4 ?? "");

        prefs.setString(SharedPrefConstants.gisCoordinatesList,
            fifpProvider.clusterApplDetails[0].gISCORDINATE ?? "");
        prefs.setString(SharedPrefConstants.mvEditFlagKey,
            fifpProvider.clusterApplDetails[0].mvEditFlag ?? "");
        prefs.setString(SharedPrefConstants.mvRate2020Key,
            fifpProvider.clusterApplDetails[0].mVRATE2020 ?? "");
        prefs.setString(SharedPrefConstants.mvRateDocumentKey,
            fifpProvider.clusterApplDetails[0].mVRATEDOCUMET ?? "");
        prefs.setString(SharedPrefConstants.conversionChargesKey,
            fifpProvider.clusterApplDetails[0].conversionCharges ?? "");
        // basic regular charges
        prefs.setString(SharedPrefConstants.rcKey,
            fifpProvider.clusterApplDetails[0].rC ?? "");
        prefs.setString(SharedPrefConstants.plotOpenspaceKey,
            fifpProvider.clusterApplDetails[0].pLOTOPENSPACE ?? "");
        prefs.setString(SharedPrefConstants.rebate,
            fifpProvider.clusterApplDetails[0].rebateAmount ?? "");
        prefs.setString(SharedPrefConstants.trcKey,
            fifpProvider.clusterApplDetails[0].tRC ?? "");
        prefs.setString(SharedPrefConstants.amountPaid,
            fifpProvider.clusterApplDetails[0].paidAmount ?? "");
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
    LocalStoreHelper().removeData(SharedPrefConstants.layoutDocumentradioVal);
    LocalStoreHelper().removeData(SharedPrefConstants.ownershipDocumetRadioVal);
    LocalStoreHelper().removeData(SharedPrefConstants.ecDocumentRadioVal);
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
    LocalStoreHelper().removeData(SharedPrefConstants.marketValueFlag);
    LocalStoreHelper().removeData(SharedPrefConstants.editedMv);
    LocalStoreHelper().removeData(SharedPrefConstants.editedMvDateOfRegstn);
    LocalStoreHelper().removeData(SharedPrefConstants.editedPlotAreaExtent);
    LocalStoreHelper().removeData(SharedPrefConstants.editedRoadAffectedArea);
    LocalStoreHelper().removeData(SharedPrefConstants.editedNetPlotArea);

    //
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
  }
}
