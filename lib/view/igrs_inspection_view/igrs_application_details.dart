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
import 'package:lrsofficer/view_model/igrs_inspection/igrs_application_details_view_model.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IGRSApplicationDetails extends StatefulWidget {
  const IGRSApplicationDetails({super.key});

  @override
  State<IGRSApplicationDetails> createState() => _IGRSApplicationDetailsState();
}

class _IGRSApplicationDetailsState extends State<IGRSApplicationDetails> {
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
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final applicationDetailsProvider =
        Provider.of<IGRSApplicationDetailsViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    final updateMobileProvider = Provider.of<UpdateMobileNoViewModel>(context);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Pop naturally
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
              title: "IGRS Application Details",
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
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
                child: applicationDetailsProvider.clusterApplDetails.isNotEmpty
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
                                          "${applicationDetailsProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${applicationDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${applicationDetailsProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${applicationDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${applicationDetailsProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${applicationDetailsProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${applicationDetailsProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl: applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .sALEDEEDEC ??
                                            ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl: applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .cOPYOFLAYOUT ??
                                            ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl: applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .oTHERSDOC ??
                                            ""),
                                    if ((applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sECDOC !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sECDOC !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sDOCOTHERS !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
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
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Layout Document",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .sLAYOUTDOC ??
                                              ""),
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall EC Document",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .sECDOC ??
                                              ""),
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Ownership Document",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .sOWNERSHIPDOC ??
                                              ""),
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .sDOCOTHERS !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .sDOCOTHERS !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Other Document",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .sDOCOTHERS ??
                                              ""),
                                    if ((applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC1 !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC1 !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC2 !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC2 !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC3 !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC3 !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC4 !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC4 !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC5 !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC5 !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .pROHIBITEDDOC6 !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
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
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC1 !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC1 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Sale Deed Document",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC1 ??
                                              ""),
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC2 !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC2 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Link Document",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC2 ??
                                              ""),
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC3 !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC3 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Layout Copy",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC3 ??
                                              ""),
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC4 !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC4 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Plot site plan",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC4 ??
                                              ""),
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC5 !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC5 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Other Document 1",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC5 ??
                                              ""),
                                    if (applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC6 !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .pROHIBITEDDOC6 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Other Document 2",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .pROHIBITEDDOC6 ??
                                              ""),
                                    if ((applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc1 !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc1 !=
                                                "") ||
                                        (applicationDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc2 !=
                                                null &&
                                            applicationDetailsProvider
                                                    .clusterApplDetails[0]
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
                                    if ((applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibittedAdditionalDoc1 !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibittedAdditionalDoc1 !=
                                            ""))
                                      BuildDocumentView(
                                          title: "Additional Document",
                                          pdfUrl: applicationDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .prohibittedAdditionalDoc1 ??
                                              ""),
                                    if ((applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibittedAdditionalDoc2 !=
                                            null &&
                                        applicationDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibittedAdditionalDoc2 !=
                                            ""))
                                      BuildDocumentView(
                                          title: "Additional Document",
                                          pdfUrl: applicationDetailsProvider
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
                                             nameController:
                                                 layoutNameController,
                                             onChanged: (value) async {
                                               SharedPreferences prefs = await SharedPreferences.getInstance();
                                               await prefs.setString(
                                                   SharedPrefConstants.layoutNameKey,
                                                   value);
                                             },
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
                                             nameController:
                                                 layoutOwnerController,
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
                                             nameController: plotNoController,
                                             onChanged: (value) async {
                                               SharedPreferences prefs = await SharedPreferences.getInstance();
                                               await prefs.setString(
                                                   SharedPrefConstants.plotNoKey,
                                                   value);
                                             },
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
                                            nameController:
                                                plotAreaExtentController,
                                            inputType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            onChanged: (p0) {
                                              num plotArea =
                                                  num.tryParse(p0) ?? 0;
                                              num roadEffectedArea = num.tryParse(
                                                      roadEffectedAreaExtentController
                                                          .text) ??
                                                  0;
                                              if (roadEffectedArea < plotArea) {
                                                if (plotArea -
                                                        roadEffectedArea >
                                                    0) {
                                                  num netplotArea = plotArea -
                                                      roadEffectedArea;
                                                  netPlotAreaExtentController
                                                      .text = "$netplotArea";
                                                } else {
                                                  plotAreaExtentController
                                                      .clear();
                                                  netPlotAreaExtentController
                                                      .clear();
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                              } else {
                                                roadEffectedAreaExtentController
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
                                            nameController:
                                                roadEffectedAreaExtentController,
                                            inputType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            onChanged: (value) async {
                                              num plotArea = num.tryParse(
                                                      plotAreaExtentController
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
                                                  netPlotAreaExtentController
                                                          .text =
                                                      netplotArea
                                                          .toStringAsFixed(2);
                                                } else {
                                                  roadEffectedAreaExtentController
                                                      .clear();
                                                  netPlotAreaExtentController
                                                      .clear();
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  ValidationIoSAlert().showAlert(
                                                      context,
                                                      description:
                                                          "Road Effected Area should be less than Plot Area");
                                                }
                                              } else {
                                                roadEffectedAreaExtentController
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
                                            nameController:
                                                netPlotAreaExtentController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                            hintText: "Village Name",
                                            nameController:
                                                villageNameController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                            hintText: "Locality",
                                            nameController: localityController,
                                          ),
                                          AppInputTextfield(
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                            hintText: "Survey Number",
                                            maxLines: null,
                                            // height: 80,
                                            nameController: surveyNoController,
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
                                              items: applicationDetailsProvider
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
                                                 applicationDetailsProvider
                                                     .changeMasterPlanZDP(
                                                         newValue);
                                                 SharedPreferences prefs = await SharedPreferences.getInstance();
                                                 await prefs.setString(
                                                     SharedPrefConstants.masterplanZdpKey,
                                                     newValue?.landUseName ?? "");
                                               },
                                              selectedValue:
                                                  applicationDetailsProvider
                                                      .selectedListMasterPlansZDP,
                                            ),
                                          ),
                                          if (l1RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                              hintText: "L1 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  l1RemarksController,
                                            ),
                                          if (l2RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                              hintText: "L2 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  l2RemarksController,
                                            ),
                                          if (l3RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                              hintText: "L3 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  l3RemarksController,
                                            ),
                                          if ((applicationDetailsProvider
                                                  .clusterApplDetails)
                                              .isNotEmpty)
                                            if ((applicationDetailsProvider
                                                        .clusterApplDetails[0]
                                                        .officersComments ??
                                                    [])
                                                .isNotEmpty)
                                              OfficerApprovalStatusReusableWidget(
                                                  officerApprovalStatus:
                                                      officerApprovalControllers,
                                                  officerIds:
                                                      createdByControllers,
                                                  officerRemarks:
                                                      notesAddedControllers)
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
                                    if (applicationDetailsProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag:
                                              applicationDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sroCodeEdit ??
                                                  "",
                                          callbackValue: (p0) async {
                                            applicationDetailsProvider
                                                .setSroEdited(p0);
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
                                              "${applicationDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
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
                                        nameController: newMobileNoController,
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
                                          if (applicationDetailsProvider
                                              .validateNewMobileNo(
                                                  newMobileNoController,
                                                  context)) {
                                            String mobileNumberNew =
                                                newMobileNoController.text;
                                            newMobileNoController.clear();
                                            applicationDetailsProvider
                                                .getResendOtp(
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
                                                        applicationDetailsProvider
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
                                        "${applicationDetailsProvider.clusterApplDetails[0].aPPLICATIONID}");
                                    await sharedpref.writeData(
                                      SharedPrefConstants.totalAreaExtent,
                                      netPlotAreaExtentController.text,
                                    );
                                    final sroCode = await LocalStoreHelper()
                                        .readTheData(
                                            SharedPrefConstants.sroCode);
                                    if (!context.mounted) return;
                                    applicationDetailsProvider
                                        .navigateToUploadDocsScreen(
                                      context,
                                      applicationId: applicationDetailsProvider
                                              .clusterApplDetails[0]
                                              .aPPLICATIONID ??
                                          "",
                                      layoutName: applicationDetailsProvider
                                              .clusterApplDetails[0]
                                              .lAYOUTNAME ??
                                          "",
                                      plotNo: plotNoController.text,
                                      areaExtent: netPlotAreaExtentController
                                          .text
                                          .trim(),
                                      plotAreaExtent:
                                          plotAreaExtentController.text.trim(),
                                      roadAreaExtent:
                                          roadEffectedAreaExtentController.text
                                              .trim(),
                                      masterplanZdp: applicationDetailsProvider
                                              .selectedListMasterPlansZDP
                                              ?.landUseName ??
                                          "",
                                      sroCode: sroCode,
                                      layoutNmae: layoutNameController.text,
                                      applicationDetails:
                                          applicationDetailsProvider
                                              .clusterApplDetails[0],
                                    );
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.igrsCheckList);
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
          if (applicationDetailsProvider.getLoaderVisibilityStatus ||
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
      final applicationDetailsProvider =
          Provider.of<IGRSApplicationDetailsViewModel>(context, listen: false);

      if (!mounted) return;
      await applicationDetailsProvider.getListOfMasterPlansZDPDetails(context);
      if (!mounted) return;
      await applicationDetailsProvider.getClusterApplDetails(context);
      if (applicationDetailsProvider.clusterApplDetails.isNotEmpty) {
        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            applicationDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            applicationDetailsProvider.clusterApplDetails[0].sALEDEEDNUMBER ??
                "");

        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            applicationDetailsProvider.clusterApplDetails[0].sALEDEEDYEAR ??
                "");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final savedLayoutName = prefs.getString(SharedPrefConstants.layoutNameKey) ?? "";
        final savedPlotNo = prefs.getString(SharedPrefConstants.plotNoKey) ?? "";
        final savedZdp = prefs.getString(SharedPrefConstants.masterplanZdpKey) ?? "";

        layoutNameController.text = (applicationDetailsProvider.clusterApplDetails[0].lAYOUTNAME ?? "").isNotEmpty
            ? applicationDetailsProvider.clusterApplDetails[0].lAYOUTNAME ?? ""
            : savedLayoutName;
        layoutOwnerController.text =
            applicationDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME ??
                "";
        plotNoController.text = (applicationDetailsProvider.clusterApplDetails[0].pLOTNO ?? "").isNotEmpty
            ? applicationDetailsProvider.clusterApplDetails[0].pLOTNO ?? ""
            : savedPlotNo;
        netPlotAreaExtentController.text =
            applicationDetailsProvider.clusterApplDetails[0].aREAEXTENT ?? "";
        plotAreaExtentController.text = (applicationDetailsProvider
                        .clusterApplDetails[0].pLOTAREAEXTENT ??
                    "".trim())
                .isEmpty
            ? applicationDetailsProvider.clusterApplDetails[0].aREAEXTENT ?? ""
            : applicationDetailsProvider.clusterApplDetails[0].pLOTAREAEXTENT ??
                "";
        roadEffectedAreaExtentController.text =
            applicationDetailsProvider.clusterApplDetails[0].rOADAREAEXTENT ??
                "";
        villageNameController.text =
            applicationDetailsProvider.clusterApplDetails[0].vILLAGENAME ?? "";
        localityController.text =
            applicationDetailsProvider.clusterApplDetails[0].lOCALITY ?? "";
        surveyNoController.text =
            applicationDetailsProvider.clusterApplDetails[0].sURVEYNUMBER ?? "";
        l1RemarksController.text =
            applicationDetailsProvider.clusterApplDetails[0].l1Remarks ?? "";
        l2RemarksController.text =
            applicationDetailsProvider.clusterApplDetails[0].l2Remarks ?? "";
        l3RemarksController.text =
            applicationDetailsProvider.clusterApplDetails[0].l3Remarks ?? "";
        final zdp = (applicationDetailsProvider.clusterApplDetails[0].mASTERPLANZDP ?? "").isNotEmpty
            ? applicationDetailsProvider.clusterApplDetails[0].mASTERPLANZDP ?? ""
            : savedZdp;
        if (zdp.isNotEmpty) {
          applicationDetailsProvider.selectedListMasterPlansZDP =
              applicationDetailsProvider.listMasterPlansZDP.firstWhere(
            (element) {
              return (element.landUseId == zdp ||
                  element.landUseName?.toLowerCase() == zdp.toLowerCase());
            },
            orElse: () => applicationDetailsProvider.listMasterPlansZDP[0],
          );
        }
        var officersCommentsList =
            applicationDetailsProvider.clusterApplDetails[0].officersComments ??
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

        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            applicationDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            applicationDetailsProvider.clusterApplDetails[0].sALEDEEDNUMBER ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            applicationDetailsProvider.clusterApplDetails[0].sALEDEEDYEAR ??
                "");
        final apiChecklist = (applicationDetailsProvider
                        .clusterApplDetails[0].listSaveDatas !=
                    null &&
                (applicationDetailsProvider
                            .clusterApplDetails[0].listSaveDatas?.length ??
                        0) !=
                    0)
            ? jsonEncode(
                applicationDetailsProvider.clusterApplDetails[0].listSaveDatas)
            : "";
        final savedChecklist = prefs.getString(SharedPrefConstants.checkListKey) ?? "";
        await prefs.setString(
            SharedPrefConstants.checkListKey,
            apiChecklist.isNotEmpty ? apiChecklist : savedChecklist);

        final apiLayoutDoc = applicationDetailsProvider.clusterApplDetails[0].lAYOUTDOC ?? "";
        final savedLayoutDoc = prefs.getString(SharedPrefConstants.layoutSelectedDocKey) ?? "";
        await prefs.setString(
            SharedPrefConstants.layoutSelectedDocKey,
            apiLayoutDoc.isNotEmpty ? apiLayoutDoc : savedLayoutDoc);

        final apiEcDoc = applicationDetailsProvider.clusterApplDetails[0].eCDOC ?? "";
        final savedEcDoc = prefs.getString(SharedPrefConstants.ecSelectedDocKey) ?? "";
        await prefs.setString(
            SharedPrefConstants.ecSelectedDocKey,
            apiEcDoc.isNotEmpty ? apiEcDoc : savedEcDoc);

        final apiOwnershipDoc = applicationDetailsProvider.clusterApplDetails[0].oWNERSHIPDOC ?? "";
        final savedOwnershipDoc = prefs.getString(SharedPrefConstants.ownershipSelectedDocKey) ?? "";
        await prefs.setString(
            SharedPrefConstants.ownershipSelectedDocKey,
            apiOwnershipDoc.isNotEmpty ? apiOwnershipDoc : savedOwnershipDoc);

        final apiPhoto1 = applicationDetailsProvider.clusterApplDetails[0].pHOTO1 ?? "";
        final savedPhoto1 = prefs.getString(SharedPrefConstants.plot1Img) ?? "";
        await prefs.setString(
            SharedPrefConstants.plot1Img,
            apiPhoto1.isNotEmpty ? apiPhoto1 : savedPhoto1);

        final apiPhoto2 = applicationDetailsProvider.clusterApplDetails[0].pHOTO2 ?? "";
        final savedPhoto2 = prefs.getString(SharedPrefConstants.plot2Img) ?? "";
        await prefs.setString(
            SharedPrefConstants.plot2Img,
            apiPhoto2.isNotEmpty ? apiPhoto2 : savedPhoto2);

        final apiPhoto3 = applicationDetailsProvider.clusterApplDetails[0].pHOTO3 ?? "";
        final savedPhoto3 = prefs.getString(SharedPrefConstants.plot3Img) ?? "";
        await prefs.setString(
            SharedPrefConstants.plot3Img,
            apiPhoto3.isNotEmpty ? apiPhoto3 : savedPhoto3);

        final apiPhoto4 = applicationDetailsProvider.clusterApplDetails[0].pHOTO4 ?? "";
        final savedPhoto4 = prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt) ?? "";
        await prefs.setString(
            SharedPrefConstants.plot4ImgMasterPlanExt,
            apiPhoto4.isNotEmpty ? apiPhoto4 : savedPhoto4);

        final apiGisCoordinate = applicationDetailsProvider.clusterApplDetails[0].gISCORDINATE ?? "";
        final savedGisCoordinate = prefs.getString(SharedPrefConstants.gisCoordinatesList) ?? "";
        await prefs.setString(
            SharedPrefConstants.gisCoordinatesList,
            apiGisCoordinate.isNotEmpty ? apiGisCoordinate : savedGisCoordinate);

        final apiMvEditFlag = applicationDetailsProvider.clusterApplDetails[0].mvEditFlag ?? "";
        final savedMvEditFlag = prefs.getString(SharedPrefConstants.mvEditFlagKey) ?? "";
        await prefs.setString(SharedPrefConstants.mvEditFlagKey, apiMvEditFlag.isNotEmpty ? apiMvEditFlag : savedMvEditFlag);

        final apiMvRate2020 = applicationDetailsProvider.clusterApplDetails[0].mVRATE2020 ?? "";
        final savedMvRate2020 = prefs.getString(SharedPrefConstants.mvRate2020Key) ?? "";
        await prefs.setString(SharedPrefConstants.mvRate2020Key, apiMvRate2020.isNotEmpty ? apiMvRate2020 : savedMvRate2020);

        final apiMvRateDoc = applicationDetailsProvider.clusterApplDetails[0].mVRATEDOCUMET ?? "";
        final savedMvRateDoc = prefs.getString(SharedPrefConstants.mvRateDocumentKey) ?? "";
        await prefs.setString(SharedPrefConstants.mvRateDocumentKey, apiMvRateDoc.isNotEmpty ? apiMvRateDoc : savedMvRateDoc);

        final apiConversionCharges = applicationDetailsProvider.clusterApplDetails[0].conversionCharges ?? "";
        final savedConversionCharges = prefs.getString(SharedPrefConstants.conversionChargesKey) ?? "";
        await prefs.setString(SharedPrefConstants.conversionChargesKey, apiConversionCharges.isNotEmpty ? apiConversionCharges : savedConversionCharges);

        final apiRc = applicationDetailsProvider.clusterApplDetails[0].rC ?? "";
        final savedRc = prefs.getString(SharedPrefConstants.rcKey) ?? "";
        await prefs.setString(SharedPrefConstants.rcKey, apiRc.isNotEmpty ? apiRc : savedRc);

        final apiPlotOpenspace = applicationDetailsProvider.clusterApplDetails[0].pLOTOPENSPACE ?? "";
        final savedPlotOpenspace = prefs.getString(SharedPrefConstants.plotOpenspaceKey) ?? "";
        await prefs.setString(SharedPrefConstants.plotOpenspaceKey, apiPlotOpenspace.isNotEmpty ? apiPlotOpenspace : savedPlotOpenspace);

        final apiRebate = applicationDetailsProvider.clusterApplDetails[0].rebateAmount ?? "";
        final savedRebate = prefs.getString(SharedPrefConstants.rebate) ?? "";
        await prefs.setString(SharedPrefConstants.rebate, apiRebate.isNotEmpty ? apiRebate : savedRebate);

        final apiTrc = applicationDetailsProvider.clusterApplDetails[0].tRC ?? "";
        final savedTrc = prefs.getString(SharedPrefConstants.trcKey) ?? "";
        await prefs.setString(SharedPrefConstants.trcKey, apiTrc.isNotEmpty ? apiTrc : savedTrc);

        final apiAmountPaid = applicationDetailsProvider.clusterApplDetails[0].paidAmount ?? "";
        final savedAmountPaid = prefs.getString(SharedPrefConstants.amountPaid) ?? "";
        await prefs.setString(SharedPrefConstants.amountPaid, apiAmountPaid.isNotEmpty ? apiAmountPaid : savedAmountPaid);
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
