import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
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
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';

class ProhibitedLayoutApplicationDetails extends StatefulWidget {
  const ProhibitedLayoutApplicationDetails({super.key});

  @override
  State<ProhibitedLayoutApplicationDetails> createState() =>
      _ProhibitedLayoutApplicationDetailsState();
}

class _ProhibitedLayoutApplicationDetailsState
    extends State<ProhibitedLayoutApplicationDetails> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final prohibitedLayoutAppDetailsProvider =
        Provider.of<ProhibitedLayoutApplicationDetailsViewModel>(context);
    final updateMobileProvider = Provider.of<UpdateMobileNoViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          /* prohibitedLayoutAppDetailsProvider.clusterApplDetails.isNotEmpty
              ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                  context,
                  message:
                      "Data of the Application ID : ${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
              :  */Navigator.pop(context);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
              title: "Prohibited Application Details",
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  /* prohibitedLayoutAppDetailsProvider
                          .clusterApplDetails.isNotEmpty
                      ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                          context,
                          message:
                              "Data of the Application ID : ${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
                      : */ Navigator.pop(context);
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
                child: prohibitedLayoutAppDetailsProvider
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
                                          "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl:
                                            prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sALEDEEDEC ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl:
                                            prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .cOPYOFLAYOUT ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl:
                                            prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .oTHERSDOC ??
                                                ""),
                                    if ((prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc1 !=
                                                null &&
                                            prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc1 !=
                                                "") ||
                                        (prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc2 !=
                                                null &&
                                            prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc2 !=
                                                "") ||
                                        (prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc3 !=
                                                null &&
                                            prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc3 !=
                                                "") ||
                                        (prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc4 !=
                                                null &&
                                            prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc4 !=
                                                "") ||
                                        (prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc5 !=
                                                null &&
                                            prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc5 !=
                                                "") ||
                                        (prohibitedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .prohibitedDoc6 !=
                                                null &&
                                            prohibitedLayoutAppDetailsProvider
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
                                    if (prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc1 !=
                                            null &&
                                        prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc1 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Sale Deed Document",
                                          pdfUrl:
                                              prohibitedLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .prohibitedDoc1 ??
                                                  ""),
                                    if (prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc2 !=
                                            null &&
                                        prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc2 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Link Document",
                                          pdfUrl:
                                              prohibitedLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .prohibitedDoc2 ??
                                                  ""),
                                    if (prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc3 !=
                                            null &&
                                        prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc3 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Layout Copy",
                                          pdfUrl:
                                              prohibitedLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .prohibitedDoc3 ??
                                                  ""),
                                    if (prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc4 !=
                                            null &&
                                        prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc4 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Plot site plan",
                                          pdfUrl:
                                              prohibitedLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .prohibitedDoc4 ??
                                                  ""),
                                    if (prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc5 !=
                                            null &&
                                        prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc5 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Other Document 1",
                                          pdfUrl:
                                              prohibitedLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .prohibitedDoc5 ??
                                                  ""),
                                    if (prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc6 !=
                                            null &&
                                        prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .prohibitedDoc6 !=
                                            "")
                                      BuildDocumentView(
                                          title: "Other Document 2",
                                          pdfUrl:
                                              prohibitedLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .prohibitedDoc6 ??
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
                                                prohibitedLayoutAppDetailsProvider.layoutNameController,
                                          ),
                                          AppInputTextfield(
                                            hintText:
                                                "Layout Owner/Plot owner Name",
                                            nameController:
                                                prohibitedLayoutAppDetailsProvider.layoutOwnerController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          QuestionTile(
                                            question:
                                                "Do you want to enter Unsold plot Details",
                                            selectedAnswer:
                                                prohibitedLayoutAppDetailsProvider
                                                    .selectedUnsoldPlotDetails,
                                            onChanged: (value) {
                                              prohibitedLayoutAppDetailsProvider
                                                  .totalNoOfPlotsController
                                                  .clear();
                                              prohibitedLayoutAppDetailsProvider
                                                  .soldPlotsController
                                                  .clear();
                                              prohibitedLayoutAppDetailsProvider
                                                  .unsoldPlotsController
                                                  .clear();
                                              prohibitedLayoutAppDetailsProvider
                                                  .changeUnsoldPlotDetails(
                                                      value);
                                            },
                                          ),
                                          AppInputTextfield(
                                            hintText: "Total No of Plots",
                                            length: 10,
                                            nameController:
                                                prohibitedLayoutAppDetailsProvider
                                                    .totalNoOfPlotsController,
                                            inputType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onChanged: (p0) {
                                              prohibitedLayoutAppDetailsProvider
                                                  .soldPlotsController
                                                  .clear();
                                              prohibitedLayoutAppDetailsProvider
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
                                                prohibitedLayoutAppDetailsProvider
                                                    .soldPlotsController,
                                            onChanged: (p0) {
                                              final totalPlots = (int.tryParse(
                                                      prohibitedLayoutAppDetailsProvider
                                                          .totalNoOfPlotsController
                                                          .text) ??
                                                  0);
                                              final soldPlots = (int.tryParse(
                                                      prohibitedLayoutAppDetailsProvider
                                                          .soldPlotsController
                                                          .text) ??
                                                  0);
                                              if (totalPlots > soldPlots) {
                                                prohibitedLayoutAppDetailsProvider
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
                                                    prohibitedLayoutAppDetailsProvider
                                                        .unsoldPlotsController
                                                        .clear();
                                                    prohibitedLayoutAppDetailsProvider
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
                                                prohibitedLayoutAppDetailsProvider
                                                    .unsoldPlotsController,
                                          ),
                                          prohibitedLayoutAppDetailsProvider
                                                      .selectedUnsoldPlotDetails ==
                                                  'N'
                                              ? AppInputTextfield(
                                                  length: 10,
                                                  hintText:
                                                      "Total Unsold Plots Area(Sq.Yrds)",
                                                  nameController:
                                                      prohibitedLayoutAppDetailsProvider
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
                                                prohibitedLayoutAppDetailsProvider.villageNameController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Locality",
                                            nameController: prohibitedLayoutAppDetailsProvider.localityController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Survey Number",
                                            maxLines: null,
                                            nameController: prohibitedLayoutAppDetailsProvider.surveyNoController,
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
                                                items: prohibitedLayoutAppDetailsProvider
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
                                                  prohibitedLayoutAppDetailsProvider
                                                      .changeMasterPlanZDP(
                                                          newValue);
                                                },
                                                selectedValue:
                                                    prohibitedLayoutAppDetailsProvider
                                                        .selectedListMasterPlansZDP,
                                                isEnabled: true),
                                          ),
                                          if ((prohibitedLayoutAppDetailsProvider
                                                  .clusterApplDetails)
                                              .isNotEmpty)
                                            if ((prohibitedLayoutAppDetailsProvider
                                                        .clusterApplDetails[0]
                                                        .officersComments ??
                                                    [])
                                                .isNotEmpty)
                                              OfficerApprovalStatusReusableWidget(
                                                  officerApprovalStatus:
                                                      prohibitedLayoutAppDetailsProvider.officerApprovalControllers,
                                                  officerIds:
                                                      prohibitedLayoutAppDetailsProvider.createdByControllers,
                                                  officerRemarks:
                                                      prohibitedLayoutAppDetailsProvider.notesAddedControllers),
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
                                    if (prohibitedLayoutAppDetailsProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag:
                                              prohibitedLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sroCodeEdit ??
                                                  "",
                                          callbackValue: (p0) {
                                            prohibitedLayoutAppDetailsProvider
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
                                            "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    AppInputTextfield(
                                      nameController: prohibitedLayoutAppDetailsProvider.newMobileNoController,
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
                                        if (prohibitedLayoutAppDetailsProvider
                                            .validateNewMobileNo(
                                                prohibitedLayoutAppDetailsProvider.newMobileNoController,
                                                context)) {
                                          String mobileNumberNew =
                                              prohibitedLayoutAppDetailsProvider.newMobileNoController.text;
                                          prohibitedLayoutAppDetailsProvider.newMobileNoController.clear();
                                          prohibitedLayoutAppDetailsProvider
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
                                                      prohibitedLayoutAppDetailsProvider
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
                                      "${prohibitedLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID}");
                                  final sroCode = await LocalStoreHelper()
                                      .readTheData(SharedPrefConstants.sroCode);
                                  if (!context.mounted) return;
                                  prohibitedLayoutAppDetailsProvider
                                      .navigateToUploadDocsScreen(
                                    context,
                                    applicationId:
                                        prohibitedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .aPPLICATIONID ??
                                            "",
                                    layoutName: prohibitedLayoutAppDetailsProvider.layoutNameController.text,
                                    masterplanZdp:
                                        prohibitedLayoutAppDetailsProvider
                                                .selectedListMasterPlansZDP
                                                ?.landUseName ??
                                            "",
                                    sroCode: sroCode,
                                    layoutNmae: prohibitedLayoutAppDetailsProvider.layoutNameController.text,
                                    applicationDetails:
                                        prohibitedLayoutAppDetailsProvider
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
          if (prohibitedLayoutAppDetailsProvider.getLoaderVisibilityStatus ||
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
      final prohibitedLayoutAppDetailsProvider =
          Provider.of<ProhibitedLayoutApplicationDetailsViewModel>(context,
              listen: false);
      if (prohibitedLayoutAppDetailsProvider.isInitialized) return;

      if (!mounted) return;
      await prohibitedLayoutAppDetailsProvider
          .getListOfMasterPlansZDPDetails(context);
      if (!mounted) return;
      await prohibitedLayoutAppDetailsProvider.getClusterApplDetails(context);
      if (prohibitedLayoutAppDetailsProvider.clusterApplDetails.isNotEmpty) {
        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].sALEDEEDNUMBER ??
                "");

        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].sALEDEEDYEAR ??
                "");
        prohibitedLayoutAppDetailsProvider.layoutNameController.text = prohibitedLayoutAppDetailsProvider
            .clusterApplDetails[0].lAYOUTNAME
            .toString();
        prohibitedLayoutAppDetailsProvider.layoutOwnerController.text = prohibitedLayoutAppDetailsProvider
            .clusterApplDetails[0].lAYOUTOWNERNAME
            .toString();
        prohibitedLayoutAppDetailsProvider.localityController.text = prohibitedLayoutAppDetailsProvider
            .clusterApplDetails[0].lOCALITY
            .toString();
        prohibitedLayoutAppDetailsProvider.surveyNoController.text = prohibitedLayoutAppDetailsProvider
            .clusterApplDetails[0].sURVEYNUMBER
            .toString();
        prohibitedLayoutAppDetailsProvider.villageNameController.text = prohibitedLayoutAppDetailsProvider
            .clusterApplDetails[0].vILLAGENAME
            .toString();
        var officersCommentsList = prohibitedLayoutAppDetailsProvider
                .clusterApplDetails[0].officersComments ??
            [];

        for (var comment in officersCommentsList) {
          // Create a controller for each field in officersCommentsList
          prohibitedLayoutAppDetailsProvider.officerApprovalControllers
              .add(TextEditingController(text: comment.aPPROVALFLAG ?? ""));
          prohibitedLayoutAppDetailsProvider.createdByControllers
              .add(TextEditingController(text: comment.cREATEDBY ?? ""));
          prohibitedLayoutAppDetailsProvider.notesAddedControllers
              .add(TextEditingController(text: comment.aDDNOTES ?? ""));
        }
        /*  officerApprovalController.text = (prohibitedLayoutAppDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].aPPROVALFLAG ??
                "")
            : "";
        creartedByController.text = (prohibitedLayoutAppDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].cREATEDBY ??
                "")
            : "";
        notesAddedController.text = (prohibitedLayoutAppDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].aDDNOTES ??
                "")
            : ""; */

        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].sALEDEEDNUMBER ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            prohibitedLayoutAppDetailsProvider
                    .clusterApplDetails[0].sALEDEEDYEAR ??
                "");
        
        prohibitedLayoutAppDetailsProvider.isInitialized = true;
      }
    });
  }

  void clearSavedData(BuildContext context) {
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModelNew>(context, listen: false);
    final prohibitedLayoutAppDetailsProvider =
        Provider.of<ProhibitedLayoutApplicationDetailsViewModel>(context,
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

    prohibitedLayoutAppDetailsProvider.soldPlotsController.clear();
    prohibitedLayoutAppDetailsProvider.unsoldPlotsController.clear();
    prohibitedLayoutAppDetailsProvider.totalNoOfPlotsController.clear();
    prohibitedLayoutAppDetailsProvider.selectedUnsoldPlotDetails = null;
    prohibitedLayoutAppDetailsProvider.totalUnsoldPlotAreaController.clear();
  }
}
