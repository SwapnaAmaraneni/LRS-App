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
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_layout_app_details_view_model.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';

class ShortfallLayoutApplicationDetails extends StatefulWidget {
  const ShortfallLayoutApplicationDetails({super.key});

  @override
  State<ShortfallLayoutApplicationDetails> createState() =>
      _ShortfallLayoutApplicationDetailsState();
}

class _ShortfallLayoutApplicationDetailsState
    extends State<ShortfallLayoutApplicationDetails> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final shortfallLayoutAppDetailsProvider =
        Provider.of<ShortfallLayoutApplicationDetailsViewModel>(context);
    final updateMobileProvider = Provider.of<UpdateMobileNoViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          /* shortfallLayoutAppDetailsProvider.clusterApplDetails.isNotEmpty
              ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                  context,
                  message:
                      "Data of the Application ID : ${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
              title: "Shortfall Application Details",
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  /* shortfallLayoutAppDetailsProvider
                          .clusterApplDetails.isNotEmpty
                      ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                          context,
                          message:
                              "Data of the Application ID : ${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
                child: shortfallLayoutAppDetailsProvider
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
                                          "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl:
                                            shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sALEDEEDEC ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl:
                                            shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .cOPYOFLAYOUT ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl:
                                            shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .oTHERSDOC ??
                                                ""),
                                    if ((shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                null &&
                                            shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                "") ||
                                        (shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sECDOC !=
                                                null &&
                                            shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sECDOC !=
                                                "") ||
                                        (shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                null &&
                                            shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                "") ||
                                        (shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sDocOthers !=
                                                null &&
                                            shortfallLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sDocOthers !=
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
                                    if (shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            null &&
                                        shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Layout Document",
                                          pdfUrl:
                                              shortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sLAYOUTDOC ??
                                                  ""),
                                    if (shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            null &&
                                        shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall EC Document",
                                          pdfUrl:
                                              shortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sECDOC ??
                                                  ""),
                                    if (shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            null &&
                                        shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Ownership Document",
                                          pdfUrl:
                                              shortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sOWNERSHIPDOC ??
                                                  ""),
                                    if (shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sDocOthers !=
                                            null &&
                                        shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .sDocOthers !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Other Document",
                                          pdfUrl:
                                              shortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sDocOthers ??
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
                                                shortfallLayoutAppDetailsProvider.layoutNameController,
                                          ),
                                          AppInputTextfield(
                                            hintText:
                                                "Layout Owner/Plot owner Name",
                                            nameController:
                                                shortfallLayoutAppDetailsProvider.layoutOwnerController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          QuestionTile(
                                            question:
                                                "Do you want to enter Unsold plot Details",
                                            selectedAnswer:
                                                shortfallLayoutAppDetailsProvider
                                                    .selectedUnsoldPlotDetails,
                                            onChanged: (value) {
                                              shortfallLayoutAppDetailsProvider
                                                  .totalNoOfPlotsController
                                                  .clear();
                                              shortfallLayoutAppDetailsProvider
                                                  .soldPlotsController
                                                  .clear();
                                              shortfallLayoutAppDetailsProvider
                                                  .unsoldPlotsController
                                                  .clear();
                                              shortfallLayoutAppDetailsProvider
                                                  .changeUnsoldPlotDetails(
                                                      value);
                                            },
                                          ),
                                          AppInputTextfield(
                                            hintText: "Total No of Plots",
                                            length: 10,
                                            nameController:
                                                shortfallLayoutAppDetailsProvider
                                                    .totalNoOfPlotsController,
                                            inputType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onChanged: (p0) {
                                              shortfallLayoutAppDetailsProvider
                                                  .soldPlotsController
                                                  .clear();
                                              shortfallLayoutAppDetailsProvider
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
                                                shortfallLayoutAppDetailsProvider
                                                    .soldPlotsController,
                                            onChanged: (p0) {
                                              final totalPlots = (int.tryParse(
                                                      shortfallLayoutAppDetailsProvider
                                                          .totalNoOfPlotsController
                                                          .text) ??
                                                  0);
                                              final soldPlots = (int.tryParse(
                                                      shortfallLayoutAppDetailsProvider
                                                          .soldPlotsController
                                                          .text) ??
                                                  0);
                                              if (totalPlots > soldPlots) {
                                                shortfallLayoutAppDetailsProvider
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
                                                    shortfallLayoutAppDetailsProvider
                                                        .unsoldPlotsController
                                                        .clear();
                                                    shortfallLayoutAppDetailsProvider
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
                                                shortfallLayoutAppDetailsProvider
                                                    .unsoldPlotsController,
                                          ),
                                          shortfallLayoutAppDetailsProvider
                                                      .selectedUnsoldPlotDetails ==
                                                  'N'
                                              ? AppInputTextfield(
                                                  length: 10,
                                                  hintText:
                                                      "Total Unsold Plots Area(Sq.Yrds)",
                                                  nameController:
                                                      shortfallLayoutAppDetailsProvider
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
                                                shortfallLayoutAppDetailsProvider.villageNameController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Locality",
                                            nameController: shortfallLayoutAppDetailsProvider.localityController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Survey Number",
                                            maxLines: null,
                                            // height: 80,
                                            nameController: shortfallLayoutAppDetailsProvider.surveyNoController,
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
                                                items: shortfallLayoutAppDetailsProvider
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
                                                  shortfallLayoutAppDetailsProvider
                                                      .changeMasterPlanZDP(
                                                          newValue);
                                                },
                                                selectedValue:
                                                    shortfallLayoutAppDetailsProvider
                                                        .selectedListMasterPlansZDP,
                                                isEnabled: true),
                                          ),
                                          if (shortfallLayoutAppDetailsProvider.l1RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L1 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  shortfallLayoutAppDetailsProvider.l1RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if (shortfallLayoutAppDetailsProvider.l2RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L2 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  shortfallLayoutAppDetailsProvider.l2RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if (shortfallLayoutAppDetailsProvider.l3RemarksController
                                              .text.isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L3 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  shortfallLayoutAppDetailsProvider.l3RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if ((shortfallLayoutAppDetailsProvider
                                                  .clusterApplDetails)
                                              .isNotEmpty)
                                            if ((shortfallLayoutAppDetailsProvider
                                                        .clusterApplDetails[0]
                                                        .officersComments ??
                                                    [])
                                                .isNotEmpty)
                                              OfficerApprovalStatusReusableWidget(
                                                  officerApprovalStatus:
                                                      shortfallLayoutAppDetailsProvider.officerApprovalControllers,
                                                  officerIds:
                                                      shortfallLayoutAppDetailsProvider.createdByControllers,
                                                  officerRemarks:
                                                      shortfallLayoutAppDetailsProvider.notesAddedControllers),
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
                                    if (shortfallLayoutAppDetailsProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag:
                                              shortfallLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sroCodeEdit ??
                                                  "",
                                          callbackValue: (p0) async {
                                            shortfallLayoutAppDetailsProvider
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
                                            "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    AppInputTextfield(
                                      nameController: shortfallLayoutAppDetailsProvider.newMobileNoController,
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
                                        if (shortfallLayoutAppDetailsProvider
                                            .validateNewMobileNo(
                                                shortfallLayoutAppDetailsProvider.newMobileNoController,
                                                context)) {
                                          String mobileNumberNew =
                                              shortfallLayoutAppDetailsProvider.newMobileNoController.text;
                                          shortfallLayoutAppDetailsProvider.newMobileNoController.clear();
                                          shortfallLayoutAppDetailsProvider
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
                                                      shortfallLayoutAppDetailsProvider
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
                                      "${shortfallLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID}");
                                  final sroCode = await LocalStoreHelper()
                                      .readTheData(SharedPrefConstants.sroCode);
                                  if (!context.mounted) return;
                                  shortfallLayoutAppDetailsProvider
                                      .navigateToUploadDocsScreen(
                                    context,
                                    applicationId:
                                        shortfallLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .aPPLICATIONID ??
                                            "",
                                    layoutName: shortfallLayoutAppDetailsProvider.layoutNameController.text,
                                    /*   plotNo: shortfallLayoutAppDetailsProvider
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
                                        shortfallLayoutAppDetailsProvider
                                                .selectedListMasterPlansZDP
                                                ?.landUseName ??
                                            "",
                                    sroCode: sroCode,
                                    layoutNmae: shortfallLayoutAppDetailsProvider.layoutNameController.text,
                                    applicationDetails:
                                        shortfallLayoutAppDetailsProvider
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
          if (shortfallLayoutAppDetailsProvider.getLoaderVisibilityStatus ||
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
      final shortfallLayoutAppDetailsProvider =
          Provider.of<ShortfallLayoutApplicationDetailsViewModel>(context,
              listen: false);
      if (shortfallLayoutAppDetailsProvider.isInitialized) return;

      if (!mounted) return;
      await shortfallLayoutAppDetailsProvider
          .getListOfMasterPlansZDPDetails(context);
      if (!mounted) return;
      await shortfallLayoutAppDetailsProvider.getClusterApplDetails(context);
      if (shortfallLayoutAppDetailsProvider.clusterApplDetails.isNotEmpty) {
        shortfallLayoutAppDetailsProvider.layoutNameController.text = shortfallLayoutAppDetailsProvider
                .clusterApplDetails[0].lAYOUTNAME ??
            "";
        shortfallLayoutAppDetailsProvider.layoutOwnerController.text = shortfallLayoutAppDetailsProvider
                .clusterApplDetails[0].lAYOUTOWNERNAME ??
            "";
        shortfallLayoutAppDetailsProvider.villageNameController.text = shortfallLayoutAppDetailsProvider
                .clusterApplDetails[0].vILLAGENAME ??
            "";
        shortfallLayoutAppDetailsProvider.localityController.text =
            shortfallLayoutAppDetailsProvider.clusterApplDetails[0].lOCALITY ??
                "";
        shortfallLayoutAppDetailsProvider.surveyNoController.text = shortfallLayoutAppDetailsProvider
                .clusterApplDetails[0].sURVEYNUMBER ??
            "";
        shortfallLayoutAppDetailsProvider.l1RemarksController.text =
            shortfallLayoutAppDetailsProvider.clusterApplDetails[0].l1Remarks ??
                "";
        shortfallLayoutAppDetailsProvider.l2RemarksController.text =
            shortfallLayoutAppDetailsProvider.clusterApplDetails[0].l2Remarks ??
                "";
        shortfallLayoutAppDetailsProvider.l3RemarksController.text =
            shortfallLayoutAppDetailsProvider.clusterApplDetails[0].l3Remarks ??
                "";
        var officersCommentsList = shortfallLayoutAppDetailsProvider
                .clusterApplDetails[0].officersComments ??
            [];

        for (var comment in officersCommentsList) {
          // Create a controller for each field in officersCommentsList
          shortfallLayoutAppDetailsProvider.officerApprovalControllers
              .add(TextEditingController(text: comment.aPPROVALFLAG ?? ""));
          shortfallLayoutAppDetailsProvider.createdByControllers
              .add(TextEditingController(text: comment.cREATEDBY ?? ""));
          shortfallLayoutAppDetailsProvider.notesAddedControllers
              .add(TextEditingController(text: comment.aDDNOTES ?? ""));
        }

        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            shortfallLayoutAppDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            shortfallLayoutAppDetailsProvider
                    .clusterApplDetails[0].sALEDEEDNUMBER ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            shortfallLayoutAppDetailsProvider
                    .clusterApplDetails[0].sALEDEEDYEAR ??
                "");
                
        shortfallLayoutAppDetailsProvider.isInitialized = true;
      }
    });
  }

  void clearSavedData(BuildContext context) {
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModelNew>(context, listen: false);
    final shortfallLayoutAppDetailsProvider =
        Provider.of<ShortfallLayoutApplicationDetailsViewModel>(context,
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

    shortfallLayoutAppDetailsProvider.soldPlotsController.clear();
    shortfallLayoutAppDetailsProvider.unsoldPlotsController.clear();
    shortfallLayoutAppDetailsProvider.totalNoOfPlotsController.clear();
    shortfallLayoutAppDetailsProvider.selectedUnsoldPlotDetails = null;
    shortfallLayoutAppDetailsProvider.totalUnsoldPlotAreaController.clear();
  }
}
