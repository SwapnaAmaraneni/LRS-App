import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/res/reusable_widgets/checklist_question_tile_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/dropdown_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/officer_approval_status_reusable_widget.dart';
import 'package:lrsofficer/res/reusable_widgets/otp_component.dart';
import 'package:lrsofficer/res/reusable_widgets/pdf_view_widget.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view/document_download.dart';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phase2ShortfallLayoutApplicationDetails extends StatefulWidget {
  const Phase2ShortfallLayoutApplicationDetails({super.key});

  @override
  State<Phase2ShortfallLayoutApplicationDetails> createState() =>
      _Phase2ShortfallLayoutApplicationDetailsState();
}

class _Phase2ShortfallLayoutApplicationDetailsState
    extends State<Phase2ShortfallLayoutApplicationDetails> {
  TextEditingController layoutNameController = TextEditingController();
  TextEditingController layoutOwnerController = TextEditingController();
  TextEditingController ownerMobileNoController = TextEditingController();
  TextEditingController plotNoController = TextEditingController();
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
  TextEditingController emailIdController = TextEditingController();
  TextEditingController alternateMobileNoController = TextEditingController();
  List<TextEditingController> officerApprovalControllers = [];
  List<TextEditingController> createdByControllers = [];
  List<TextEditingController> notesAddedControllers = [];
  TextEditingController l1RemarksController = TextEditingController();
  TextEditingController l2RemarksController = TextEditingController();
  TextEditingController l3RemarksController = TextEditingController();
  bool isExpanded = false;
  List<ListUnsoldPlots> unsoldPlotsList = [];
  TextEditingController newMobileNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final phase2ShortfallLayoutAppDetailsProvider =
        Provider.of<Phase2ShortfallLayoutApplicationDetailsViewModel>(context);
    final updateMobileProvider = Provider.of<UpdateMobileNoViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails.isNotEmpty
              ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                  context,
                  message:
                      "Data of the Application ID : ${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
              title: "Phase-2 Shortfall Application Details",
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  phase2ShortfallLayoutAppDetailsProvider
                          .clusterApplDetails.isNotEmpty
                      ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                          context,
                          message:
                              "Data of the Application ID : ${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
                child: phase2ShortfallLayoutAppDetailsProvider
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
                                          "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl:
                                            phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sALEDEEDEC ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl:
                                            phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .cOPYOFLAYOUT ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl:
                                            phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .oTHERSDOC ??
                                                ""),
                                    if ((phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                null &&
                                            phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                "") ||
                                        (phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sECDOC !=
                                                null &&
                                            phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sECDOC !=
                                                "") ||
                                        (phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                null &&
                                            phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                "") ||
                                        (phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sDOCOTHERS !=
                                                null &&
                                            phase2ShortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sDOCOTHERS !=
                                                ""))
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Citizen Updated Documents(Shortfall)",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            null &&
                                        phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Layout Document",
                                          pdfUrl:
                                              phase2ShortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sLAYOUTDOC ??
                                                  ""),
                                    if (phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            null &&
                                        phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall EC Document",
                                          pdfUrl:
                                              phase2ShortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sECDOC ??
                                                  ""),
                                    if (phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            null &&
                                        phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Ownership Document",
                                          pdfUrl:
                                              phase2ShortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sOWNERSHIPDOC ??
                                                  ""),
                                    if (phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sDOCOTHERS !=
                                            null &&
                                        phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sDOCOTHERS !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Other Document",
                                          pdfUrl:
                                              phase2ShortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sDOCOTHERS ??
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
                                          QuestionTile(
                                            question:
                                                "Do you want to enter Unsold plot Details",
                                            selectedAnswer:
                                                phase2ShortfallLayoutAppDetailsProvider
                                                    .selectedUnsoldPlotDetails,
                                            onChanged: (value) {
                                              phase2ShortfallLayoutAppDetailsProvider
                                                  .totalNoOfPlotsController
                                                  .clear();
                                              phase2ShortfallLayoutAppDetailsProvider
                                                  .soldPlotsController
                                                  .clear();
                                              phase2ShortfallLayoutAppDetailsProvider
                                                  .unsoldPlotsController
                                                  .clear();
                                              phase2ShortfallLayoutAppDetailsProvider
                                                  .changeUnsoldPlotDetails(
                                                      value);
                                            },
                                          ),
                                          AppInputTextfield(
                                            hintText: "Total No of Plots",
                                            length: 10,
                                            nameController:
                                                phase2ShortfallLayoutAppDetailsProvider
                                                    .totalNoOfPlotsController,
                                            inputType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onChanged: (p0) {
                                              phase2ShortfallLayoutAppDetailsProvider
                                                  .soldPlotsController
                                                  .clear();
                                              phase2ShortfallLayoutAppDetailsProvider
                                                  .unsoldPlotsController
                                                  .clear();
                                            },
                                          ),
                                          AppInputTextfield(
                                            length: 10,
                                            hintText: "Sold Plots",
                                            inputType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            nameController:
                                                phase2ShortfallLayoutAppDetailsProvider
                                                    .soldPlotsController,
                                            onChanged: (p0) {
                                              final totalPlots = (int.tryParse(
                                                      phase2ShortfallLayoutAppDetailsProvider
                                                          .totalNoOfPlotsController
                                                          .text) ??
                                                  0);
                                              final soldPlots = (int.tryParse(
                                                      phase2ShortfallLayoutAppDetailsProvider
                                                          .soldPlotsController
                                                          .text) ??
                                                  0);
                                              if (totalPlots > soldPlots) {
                                                phase2ShortfallLayoutAppDetailsProvider
                                                        .unsoldPlotsController
                                                        .text =
                                                    (totalPlots - soldPlots)
                                                        .toString();
                                              } else {
                                                ErrorCustomCupertinoAlert()
                                                    .showAlert(
                                                  context,
                                                  message:
                                                      "Sold plots cannot be greater than total No.of plots",
                                                  onPressed: () {
                                                    phase2ShortfallLayoutAppDetailsProvider
                                                        .unsoldPlotsController
                                                        .clear();
                                                    phase2ShortfallLayoutAppDetailsProvider
                                                        .soldPlotsController
                                                        .clear();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          AppInputTextfield(
                                            length: 10,
                                            isReadOnly: true,
                                            hintText: "Unsold Plots",
                                            nameController:
                                                phase2ShortfallLayoutAppDetailsProvider
                                                    .unsoldPlotsController,
                                          ),
                                          phase2ShortfallLayoutAppDetailsProvider
                                                      .selectedUnsoldPlotDetails ==
                                                  'N'
                                              ? AppInputTextfield(
                                                  length: 10,
                                                  hintText:
                                                      "Total Unsold Plots Area(Sq.Yrds)",
                                                  nameController:
                                                      phase2ShortfallLayoutAppDetailsProvider
                                                          .totalUnsoldPlotAreaController,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d+\.?\d{0,2}')),
                                                  ],
                                                  inputType: const TextInputType
                                                      .numberWithOptions(
                                                      decimal: true),
                                                )
                                              : Container(),
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
                                                items: phase2ShortfallLayoutAppDetailsProvider
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
                                                  phase2ShortfallLayoutAppDetailsProvider
                                                      .changeMasterPlanZDP(
                                                          newValue);
                                                },
                                                selectedValue:
                                                    phase2ShortfallLayoutAppDetailsProvider
                                                        .selectedListMasterPlansZDP,
                                                isEnabled: true),
                                          ),
                                          if (l1RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L1 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  l1RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if (l2RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L2 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  l2RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if (l3RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L3 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  l3RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if ((phase2ShortfallLayoutAppDetailsProvider
                                                  .clusterApplDetails)
                                              .isNotEmpty)
                                            if ((phase2ShortfallLayoutAppDetailsProvider
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
                                    if (phase2ShortfallLayoutAppDetailsProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag:
                                              phase2ShortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sroCodeEdit ??
                                                  "",
                                          callbackValue: (p0) async {
                                            phase2ShortfallLayoutAppDetailsProvider
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
                                            "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
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
                                        if (phase2ShortfallLayoutAppDetailsProvider
                                            .validateNewMobileNo(
                                                newMobileNoController,
                                                context)) {
                                          String mobileNumberNew =
                                              newMobileNoController.text;
                                          newMobileNoController.clear();
                                          phase2ShortfallLayoutAppDetailsProvider
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
                                                      phase2ShortfallLayoutAppDetailsProvider
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
                                      "${phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID}");
                                  final sroCode = await LocalStoreHelper()
                                      .readTheData(SharedPrefConstants.sroCode);
                                  if (!context.mounted) return;
                                  phase2ShortfallLayoutAppDetailsProvider
                                      .navigateToUploadDocsScreen(
                                    context,
                                    applicationId:
                                        phase2ShortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .aPPLICATIONID ??
                                            "",
                                    layoutName: layoutNameController.text,
                                    /*   plotNo: phase2ShortfallLayoutAppDetailsProvider
                                            .clusterApplDetails[0].pLOTNO ??
                                        "", */
                                    // areaExtent:
                                    //     netPlotAreaExtentController.text.trim(),
                                    // plotAreaExtent:
                                    //     plotAreaExtentController.text.trim(),
                                    // roadAreaExtent:
                                    //     roadEffectedAreaExtentController.text
                                    //         .trim(),
                                    masterplanZdp:
                                        phase2ShortfallLayoutAppDetailsProvider
                                                .selectedListMasterPlansZDP
                                                ?.landUseName ??
                                            "",
                                    sroCode: sroCode,
                                    layoutNmae: layoutNameController.text,
                                    applicationDetails:
                                        phase2ShortfallLayoutAppDetailsProvider
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
          if (phase2ShortfallLayoutAppDetailsProvider
                  .getLoaderVisibilityStatus ||
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
      final phase2ShortfallLayoutAppDetailsProvider =
          Provider.of<Phase2ShortfallLayoutApplicationDetailsViewModel>(context,
              listen: false);
      phase2ShortfallLayoutAppDetailsProvider.setLoaderVisibleStatus(true);
      final uploadPlotDetailsProvider =
          Provider.of<Phase2ShortfallUploadPlotDetailsViewModel>(context,
              listen: false);
      final locEnabled =
          await uploadPlotDetailsProvider.handleLocationPermission(context);
      if (locEnabled) {
        final currentPos = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
        );
        if (!mounted) return;
        await phase2ShortfallLayoutAppDetailsProvider
            .getListOfMasterPlansZDPDetails(context);
        if (!mounted) return;
        await phase2ShortfallLayoutAppDetailsProvider.getClusterApplDetails(
          context,
        );
        if (phase2ShortfallLayoutAppDetailsProvider
            .clusterApplDetails.isNotEmpty) {
          unsoldPlotsList = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].listUnsoldPlots ??
              [];
          if (unsoldPlotsList.isNotEmpty) {
            phase2ShortfallLayoutAppDetailsProvider
                .changeUnsoldPlotDetails('Y');
          } else {
            phase2ShortfallLayoutAppDetailsProvider
                .changeUnsoldPlotDetails('N');
          }
          await LocalStoreHelper().writeData(
              SharedPrefConstants.sroCode,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].sROCODEFOURDIGITS ??
                  "");
          await LocalStoreHelper().writeData(
              SharedPrefConstants.saleDeedNo,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].sALEDEEDNUMBER ??
                  "");

          await LocalStoreHelper().writeData(
              SharedPrefConstants.saleDeedYear,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].sALEDEEDYEAR ??
                  "");
          layoutNameController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].lAYOUTNAME ??
              "";
          layoutOwnerController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          ownerMobileNoController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].oWNERMOBILENUMBER ??
              "";
          plotNoController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].pLOTNO ??
              "";

          addressController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].aPPLICANTADDRESS ??
              "";

          //layout
          phase2ShortfallLayoutAppDetailsProvider.totalNoOfPlotsController
              .text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].totalNoPlots ??
              "";
          phase2ShortfallLayoutAppDetailsProvider.soldPlotsController.text =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].totalNoSoldPlots ??
                  "";
          phase2ShortfallLayoutAppDetailsProvider.unsoldPlotsController.text =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].totalNoUnSoldPlots ??
                  "";
          phase2ShortfallLayoutAppDetailsProvider.totalUnsoldPlotAreaController
              .text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].totalNoAreaExtent ??
              "";

          //layout
          villageNameController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          localityController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].lOCALITY ??
              "";
          surveyNoController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].sURVEYNUMBER ??
              "";
          // application details
          applicationNoController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          applicantNameController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          fatherOrSpouseNameController.text =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].fATHERHUSBANDNAME ??
                  "";
          aadharNumberController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].aADHARNUMBER ??
              "";
          genderController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].gENDER ??
              "";
          houseNoController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].hNODOORNO ??
              "";
          streetOrColonyController.text =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].sTREETCOLONY ??
                  "";
          applicantLocalityController.text =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].lOCALITY ??
                  "";
          townController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          applicationNoController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          zdpController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].mASTERPLANZDP ??
              "";

          l1RemarksController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].l1Remarks ??
              "";
          l2RemarksController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].l2Remarks ??
              "";
          l3RemarksController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].l3Remarks ??
              "";
          if (zdpController.text.isNotEmpty) {
            phase2ShortfallLayoutAppDetailsProvider.selectedListMasterPlansZDP =
                phase2ShortfallLayoutAppDetailsProvider.listMasterPlansZDP
                    .firstWhere(
              (element) {
                return (element.landUseName?.toLowerCase() ==
                        zdpController.text.toLowerCase() ||
                    element.landUseId == zdpController.text);
              },
              orElse: () =>
                  phase2ShortfallLayoutAppDetailsProvider.listMasterPlansZDP[0],
            );
          }
          districtController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].dISTRICTNAME ??
              "";
          pincodeController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].pINCODE ??
              "";
          applicantMobileNoController.text =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].oWNERMOBILENUMBER ??
                  "";
          emailIdController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].eMAILID ??
              "";
          alternateMobileNoController.text =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].aLTERMOBILENO ??
                  "";
          latitudeController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].latitude ??
              "${currentPos.latitude}";
          longitudeController.text = phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].longitude ??
              "${currentPos.longitude}";
          var officersCommentsList = phase2ShortfallLayoutAppDetailsProvider
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final checkListStr = (phase2ShortfallLayoutAppDetailsProvider
                          .clusterApplDetails[0].listSaveDatas !=
                      null &&
                  (phase2ShortfallLayoutAppDetailsProvider
                              .clusterApplDetails[0].listSaveDatas?.length ??
                          0) !=
                      0)
              ? jsonEncode(phase2ShortfallLayoutAppDetailsProvider
                  .clusterApplDetails[0].listSaveDatas)
              : [];
          prefs.setString(
              SharedPrefConstants.checkListKey, checkListStr.toString());
          prefs.setString(
              SharedPrefConstants.layoutSelectedDocKey,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].lAYOUTDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.ecSelectedDocKey,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].eCDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.ownershipSelectedDocKey,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].oWNERSHIPDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot1Img,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].pHOTO1 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot2Img,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].pHOTO2 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot3Img,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].pHOTO3 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot4ImgMasterPlanExt,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].pHOTO4 ??
                  "");

          prefs.setString(
              SharedPrefConstants.gisCoordinatesList,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].gISCORDINATE ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvEditFlagKey,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].mvEditFlag ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvRate2020Key,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].mVRATE2020 ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvRateDocumentKey,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].mVRATEDOCUMET ??
                  "");
          prefs.setString(
              SharedPrefConstants.conversionChargesKey,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].conversionCharges ??
                  "");
          prefs.setString(
              SharedPrefConstants.applicationNo,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].aPPLICATIONID ??
                  "");
          prefs.setString(
              SharedPrefConstants.areaExtentKey,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].aREAEXTENT ??
                  "");
          prefs.setString(
              SharedPrefConstants.totalunsoldPlotAreakey,
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].totalNoAreaExtent ??
                  "");
          AppConstants.maxCoordinatesCount =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].maxCoordinatesCount ??
                  "";
          AppConstants.minCoordinatesCount =
              phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].minCoordinatesCount ??
                  "";
          if ((phase2ShortfallLayoutAppDetailsProvider
                      .clusterApplDetails[0].officersComments ??
                  [])
              .isNotEmpty) {
            prefs.setString(
                SharedPrefConstants.recommendationsKey,
                phase2ShortfallLayoutAppDetailsProvider.clusterApplDetails[0]
                        .officersComments?[0].aPPROVALFLAG ??
                    "");
            prefs.setString(
                SharedPrefConstants.notesKey,
                phase2ShortfallLayoutAppDetailsProvider
                        .clusterApplDetails[0].officersComments?[0].aDDNOTES ??
                    "");
          }

          setState(() {});
        }
      }
    });
  }

  void clearSavedData(BuildContext context) {
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModelNew>(context, listen: false);
    final phase2ShortfallLayoutAppDetailsProvider =
        Provider.of<Phase2ShortfallLayoutApplicationDetailsViewModel>(context,
            listen: false);
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
    LocalStoreHelper().removeData(SharedPrefConstants.totalAreaExtent);

    phase2ShortfallLayoutAppDetailsProvider.soldPlotsController.clear();
    phase2ShortfallLayoutAppDetailsProvider.unsoldPlotsController.clear();
    phase2ShortfallLayoutAppDetailsProvider.totalNoOfPlotsController.clear();
    phase2ShortfallLayoutAppDetailsProvider.selectedUnsoldPlotDetails = null;
    phase2ShortfallLayoutAppDetailsProvider.totalUnsoldPlotAreaController
        .clear();
  }
}
