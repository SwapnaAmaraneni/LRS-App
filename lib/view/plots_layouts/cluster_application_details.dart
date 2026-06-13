import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/res/reusable_widgets/dropdown_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/officer_approval_status_reusable_widget.dart';
import 'package:lrsofficer/res/reusable_widgets/otp_component.dart';
import 'package:lrsofficer/res/reusable_widgets/pdf_view_widget.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view/document_download.dart';
import 'package:lrsofficer/view_model/plots_layouts/cluster_application_details_view_model.dart';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';

class ClusterApplicationDetails extends StatefulWidget {
  const ClusterApplicationDetails({super.key});

  @override
  State<ClusterApplicationDetails> createState() =>
      _ClusterApplicationDetailsState();
}

class _ClusterApplicationDetailsState extends State<ClusterApplicationDetails> {
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
  List<TextEditingController> officerApprovalControllers = [];
  List<TextEditingController> createdByControllers = [];
  List<TextEditingController> notesAddedControllers = [];
  TextEditingController newMobileNoController = TextEditingController();
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final clusterwiseApplDetailsProvider =
        Provider.of<ClusterApplicationDetailsViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    final updateMobileProvider = Provider.of<UpdateMobileNoViewModel>(context);
    if (!kReleaseMode) {
      debugPrint(
          "download Loader Status:: ${documentDownloadProvider.getLoaderVisibilityStatus}");
    }
    if (!kReleaseMode) {
      debugPrint(
          "App-Details Loader Status:: ${clusterwiseApplDetailsProvider.getLoaderVisibilityStatus}");
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          clusterwiseApplDetailsProvider.clusterApplDetails.isNotEmpty
              ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                  context,
                  message:
                      "Data of the Application ID : ${clusterwiseApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
              : Navigator.pop(context);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
              title: "Application Details",
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  clusterwiseApplDetailsProvider.clusterApplDetails.isNotEmpty
                      ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                          context,
                          message:
                              "Data of the Application ID : ${clusterwiseApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
                      : Navigator.pop(context);
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
                child: clusterwiseApplDetailsProvider
                        .clusterApplDetails.isNotEmpty
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
                                          "${clusterwiseApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${clusterwiseApplDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${clusterwiseApplDetailsProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${clusterwiseApplDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${clusterwiseApplDetailsProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${clusterwiseApplDetailsProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${clusterwiseApplDetailsProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl: clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .sALEDEEDEC ??
                                            ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl: clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .cOPYOFLAYOUT ??
                                            ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl: clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .oTHERSDOC ??
                                            ""),
                                    if ((clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc1 !=
                                                null &&
                                            clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc1 !=
                                                "") ||
                                        (clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc2 !=
                                                null &&
                                            clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc2 !=
                                                "") ||
                                        (clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc3 !=
                                                null &&
                                            clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc3 !=
                                                "") ||
                                        (clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc4 !=
                                                null &&
                                            clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc4 !=
                                                "") ||
                                        (clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc5 !=
                                                null &&
                                            clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc5 !=
                                                "") ||
                                        (clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc6 !=
                                                null &&
                                            clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc6 !=
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
                                    if (clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc1 !=
                                            null &&
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc1 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Sale Deed Document",
                                          pdfUrl: clusterwiseApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .prohibitedDoc1 ??
                                              ""),
                                    if (clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc2 !=
                                            null &&
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc2 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Link Document",
                                          pdfUrl: clusterwiseApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .prohibitedDoc2 ??
                                              ""),
                                    if (clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc3 !=
                                            null &&
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc3 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Layout Copy",
                                          pdfUrl: clusterwiseApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .prohibitedDoc3 ??
                                              ""),
                                    if (clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc4 !=
                                            null &&
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc4 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Plot site plan",
                                          pdfUrl: clusterwiseApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .prohibitedDoc4 ??
                                              ""),
                                    if (clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc5 !=
                                            null &&
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc5 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Other Document 1",
                                          pdfUrl: clusterwiseApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .prohibitedDoc5 ??
                                              ""),
                                    if (clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc6 !=
                                            null &&
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc6 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Other Document 2",
                                          pdfUrl: clusterwiseApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .prohibitedDoc6 ??
                                              ""),
                                    if ((clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc1 !=
                                                null &&
                                            clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc1 !=
                                                "") ||
                                        (clusterwiseApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibittedAdditionalDoc2 !=
                                                null &&
                                            clusterwiseApplDetailsProvider
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
                                    if ((clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibittedAdditionalDoc1 !=
                                            null &&
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibittedAdditionalDoc1 !=
                                            ""))
                                      BuildDocumentView(
                                          title: "Additional Document",
                                          pdfUrl: clusterwiseApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .prohibittedAdditionalDoc1 ??
                                              ""),
                                    if ((clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibittedAdditionalDoc2 !=
                                            null &&
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibittedAdditionalDoc2 !=
                                            ""))
                                      BuildDocumentView(
                                          title: "Additional Document",
                                          pdfUrl: clusterwiseApplDetailsProvider
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
                                            hintText: "Layout Name",
                                            nameController:
                                                layoutNameController,
                                          ),
                                          AppInputTextfield(
                                            hintText:
                                                "Layout Owner/Plot owner Name",
                                            nameController:
                                                layoutOwnerController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Plot No",
                                            nameController: plotNoController,
                                          ),
                                          AppInputTextfield(
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
                                            hintText:
                                                "Net plot Area Extent Sq.Yards",
                                            nameController:
                                                netPlotAreaExtentController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Village Name",
                                            nameController:
                                                villageNameController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Locality",
                                            nameController: localityController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Survey Number",
                                            maxLines: null,
                                            // height: 80,
                                            nameController: surveyNoController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
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
                                                items: clusterwiseApplDetailsProvider
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
                                                        overflow: TextOverflow
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
                                          if ((clusterwiseApplDetailsProvider
                                                  .clusterApplDetails)
                                              .isNotEmpty)
                                            if ((clusterwiseApplDetailsProvider
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
                                                      notesAddedControllers),
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
                                    if (clusterwiseApplDetailsProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag:
                                              clusterwiseApplDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sroCodeEdit ??
                                                  "",
                                          callbackValue: (p0) async {
                                            clusterwiseApplDetailsProvider
                                                .setSroEdited(p0);
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
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
                                            "${clusterwiseApplDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    AppInputTextfield(
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
                                        if (clusterwiseApplDetailsProvider
                                            .validateNewMobileNo(
                                                newMobileNoController,
                                                context)) {
                                          String mobileNumberNew =
                                              newMobileNoController.text;
                                          newMobileNoController.clear();
                                          clusterwiseApplDetailsProvider
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
                                                      clusterwiseApplDetailsProvider
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
                                  LocalStoreHelper sharedpref =
                                      LocalStoreHelper();
                                  await sharedpref.writeData(
                                      SharedPrefConstants.applicationNo,
                                      "${clusterwiseApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID}");
                                  await sharedpref.writeData(
                                    SharedPrefConstants.totalAreaExtent,
                                    netPlotAreaExtentController.text,
                                  );
                                  final sroCode = await sharedpref.readTheData(
                                    SharedPrefConstants.sroCode,
                                  );
                                  if (!context.mounted) return;
                                  clusterwiseApplDetailsProvider
                                      .navigateToUploadDocsScreen(
                                    context,
                                    applicationId:
                                        clusterwiseApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .aPPLICATIONID ??
                                            "",
                                    layoutName: clusterwiseApplDetailsProvider
                                            .clusterApplDetails[0].lAYOUTNAME ??
                                        "",
                                    plotNo: plotNoController.text,
                                    areaExtent:
                                        netPlotAreaExtentController.text.trim(),
                                    plotAreaExtent:
                                        plotAreaExtentController.text.trim(),
                                    roadAreaExtent:
                                        roadEffectedAreaExtentController.text
                                            .trim(),
                                    masterplanZdp:
                                        clusterwiseApplDetailsProvider
                                                .selectedListMasterPlansZDP
                                                ?.landUseName ??
                                            "",
                                    sroCode: sroCode,
                                    layoutNmae: layoutNameController.text,
                                    applicationDetails:
                                        clusterwiseApplDetailsProvider
                                            .clusterApplDetails[0],
                                  );
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
          if (clusterwiseApplDetailsProvider.getLoaderVisibilityStatus ||
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
      final clusterwiseApplDetailsProvider =
          Provider.of<ClusterApplicationDetailsViewModel>(context,
              listen: false);

      if (!mounted) return;
      await clusterwiseApplDetailsProvider
          .getListOfMasterPlansZDPDetails(context);
      if (!mounted) return;
      await clusterwiseApplDetailsProvider.getClusterApplDetails(context);
      if (clusterwiseApplDetailsProvider.clusterApplDetails.isNotEmpty) {
        layoutNameController.text =
            clusterwiseApplDetailsProvider.clusterApplDetails[0].lAYOUTNAME ??
                "";
        layoutOwnerController.text = clusterwiseApplDetailsProvider
                .clusterApplDetails[0].lAYOUTOWNERNAME ??
            "";
        plotNoController.text =
            clusterwiseApplDetailsProvider.clusterApplDetails[0].pLOTNO ?? "";
        netPlotAreaExtentController.text = clusterwiseApplDetailsProvider
                .clusterApplDetails[0].totalNoAreaExtent ??
            "";
        plotAreaExtentController.text = (clusterwiseApplDetailsProvider
                        .clusterApplDetails[0].pLOTAREAEXTENT ??
                    "".trim())
                .isEmpty
            ? clusterwiseApplDetailsProvider.clusterApplDetails[0].aREAEXTENT ??
                ""
            : clusterwiseApplDetailsProvider
                    .clusterApplDetails[0].pLOTAREAEXTENT ??
                "";
        villageNameController.text =
            clusterwiseApplDetailsProvider.clusterApplDetails[0].vILLAGENAME ??
                "";
        localityController.text =
            clusterwiseApplDetailsProvider.clusterApplDetails[0].lOCALITY ?? "";
        surveyNoController.text =
            clusterwiseApplDetailsProvider.clusterApplDetails[0].sURVEYNUMBER ??
                "";
        var officersCommentsList = clusterwiseApplDetailsProvider
                .clusterApplDetails[0].officersComments ??
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
        /*   officerApprovalController.text = (clusterwiseApplDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (clusterwiseApplDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].aPPROVALFLAG ??
                "")
            : "";
        creartedByController.text = (clusterwiseApplDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (clusterwiseApplDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].cREATEDBY ??
                "")
            : "";
        notesAddedController.text = (clusterwiseApplDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (clusterwiseApplDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].aDDNOTES ??
                "")
            : ""; */

        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            clusterwiseApplDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            clusterwiseApplDetailsProvider
                    .clusterApplDetails[0].sALEDEEDNUMBER ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.checkListKey,
            clusterwiseApplDetailsProvider.clusterApplDetails[0].strCHECKLIST ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            clusterwiseApplDetailsProvider.clusterApplDetails[0].sALEDEEDYEAR ??
                "");
      }
    });
  }

  void clearSavedData(BuildContext context) {
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModelNew>(context, listen: false);
    captureGeoCoordinatesProvider.onClear(context);
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
}
