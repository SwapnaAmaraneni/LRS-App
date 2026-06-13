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
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_application_details_view_model.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';

class ShortfallApplicationDetails extends StatefulWidget {
  const ShortfallApplicationDetails({super.key});

  @override
  State<ShortfallApplicationDetails> createState() =>
      _ShortfallApplicationDetailsState();
}

class _ShortfallApplicationDetailsState
    extends State<ShortfallApplicationDetails> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final shortfallApplDetailsProvider =
        Provider.of<ShortfallApplicationDetailsViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    final updateMobileProvider = Provider.of<UpdateMobileNoViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          /* shortfallApplDetailsProvider.clusterApplDetails.isNotEmpty
              ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                  context,
                  message:
                      "Data of the Application ID : ${shortfallApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
              title: "Shortfall Application Details",
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  /* shortfallApplDetailsProvider.clusterApplDetails.isNotEmpty
                      ? WarningCustomCupertinoAlertTwoButtons().showAlert(
                          context,
                          message:
                              "Data of the Application ID : ${shortfallApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
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
                child: shortfallApplDetailsProvider
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
                                          "${shortfallApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${shortfallApplDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${shortfallApplDetailsProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${shortfallApplDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${shortfallApplDetailsProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${shortfallApplDetailsProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${shortfallApplDetailsProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl: shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .sALEDEEDEC ??
                                            ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl: shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .cOPYOFLAYOUT ??
                                            ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl: shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .oTHERSDOC ??
                                            ""),
                                    if ((shortfallApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                null &&
                                            shortfallApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sLAYOUTDOC !=
                                                "") ||
                                        (shortfallApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sECDOC !=
                                                null &&
                                            shortfallApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sECDOC !=
                                                "") ||
                                        (shortfallApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                null &&
                                            shortfallApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sOWNERSHIPDOC !=
                                                "") ||
                                        (shortfallApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sDocOthers !=
                                                null &&
                                            shortfallApplDetailsProvider
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
                                    if (shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            null &&
                                        shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .sLAYOUTDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Layout Document",
                                          pdfUrl: shortfallApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .sLAYOUTDOC ??
                                              ""),
                                    if (shortfallApplDetailsProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            null &&
                                        shortfallApplDetailsProvider
                                                .clusterApplDetails[0].sECDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall EC Document",
                                          pdfUrl: shortfallApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .sECDOC ??
                                              ""),
                                    if (shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            null &&
                                        shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .sOWNERSHIPDOC !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Ownership Document",
                                          pdfUrl: shortfallApplDetailsProvider
                                                  .clusterApplDetails[0]
                                                  .sOWNERSHIPDOC ??
                                              ""),
                                    if (shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .sDocOthers !=
                                            null &&
                                        shortfallApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .sDocOthers !=
                                            "")
                                      BuildDocumentView(
                                          title: "Shortfall Other Document",
                                          pdfUrl: shortfallApplDetailsProvider
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
                                                shortfallApplDetailsProvider
                                                    .layoutNameController,
                                          ),
                                          AppInputTextfield(
                                            hintText:
                                                "Layout Owner/Plot owner Name",
                                            nameController:
                                                shortfallApplDetailsProvider
                                                    .layoutOwnerController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Plot No",
                                            nameController:
                                                shortfallApplDetailsProvider
                                                    .plotNoController,
                                          ),
                                          AppInputTextfield(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            hintText:
                                                "Plot Area Extent Sq.Yards(As on Ground)*",
                                            nameController:
                                                shortfallApplDetailsProvider
                                                    .plotAreaExtentController,
                                            inputType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            onChanged: (p0) {
                                              num plotArea =
                                                  num.tryParse(p0) ?? 0;
                                              num roadEffectedArea = num.tryParse(
                                                      shortfallApplDetailsProvider
                                                          .roadEffectedAreaExtentController
                                                          .text) ??
                                                  0;
                                              if (roadEffectedArea < plotArea) {
                                                if (plotArea -
                                                        roadEffectedArea >
                                                    0) {
                                                  num netplotArea = plotArea -
                                                      roadEffectedArea;
                                                  shortfallApplDetailsProvider
                                                      .netPlotAreaExtentController
                                                      .text = "$netplotArea";
                                                } else {
                                                  shortfallApplDetailsProvider
                                                      .plotAreaExtentController
                                                      .clear();
                                                  shortfallApplDetailsProvider
                                                      .netPlotAreaExtentController
                                                      .clear();
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                              } else {
                                                shortfallApplDetailsProvider
                                                    .roadEffectedAreaExtentController
                                                    .clear();
                                                shortfallApplDetailsProvider
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
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            hintText:
                                                "Road Effected Area Extent Sq.Yards*",
                                            nameController:
                                                shortfallApplDetailsProvider
                                                    .roadEffectedAreaExtentController,
                                            inputType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            onChanged: (value) async {
                                              num plotArea = num.tryParse(
                                                      shortfallApplDetailsProvider
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
                                                  shortfallApplDetailsProvider
                                                          .netPlotAreaExtentController
                                                          .text =
                                                      netplotArea
                                                          .toStringAsFixed(2);
                                                } else {
                                                  shortfallApplDetailsProvider
                                                      .roadEffectedAreaExtentController
                                                      .clear();
                                                  shortfallApplDetailsProvider
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
                                                shortfallApplDetailsProvider
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
                                            hintText:
                                                "Net plot Area Extent Sq.Yards",
                                            nameController:
                                                shortfallApplDetailsProvider
                                                    .netPlotAreaExtentController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Village Name",
                                            nameController:
                                                shortfallApplDetailsProvider
                                                    .villageNameController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Locality",
                                            nameController:
                                                shortfallApplDetailsProvider
                                                    .localityController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          AppInputTextfield(
                                            hintText: "Survey Number",
                                            maxLines: null,
                                            // height: 80,
                                            nameController:
                                                shortfallApplDetailsProvider
                                                    .surveyNoController,
                                            isReadOnly: true,
                                            textColor: Colors.grey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: DropdownReusable<
                                                    ListMasterPlansZDP>(
                                                label:
                                                    "Land use as per Master Plan/ZDP *",
                                                items: shortfallApplDetailsProvider
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
                                                  shortfallApplDetailsProvider
                                                      .changeMasterPlanZDP(
                                                          newValue);
                                                },
                                                selectedValue:
                                                    shortfallApplDetailsProvider
                                                        .selectedListMasterPlansZDP,
                                                isEnabled: true),
                                          ),
                                          if (shortfallApplDetailsProvider
                                              .l1RemarksController
                                              .text
                                              .isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L1 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  shortfallApplDetailsProvider
                                                      .l1RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if (shortfallApplDetailsProvider
                                              .l2RemarksController
                                              .text
                                              .isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L2 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  shortfallApplDetailsProvider
                                                      .l2RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if (shortfallApplDetailsProvider
                                              .l3RemarksController
                                              .text
                                              .isNotEmpty)
                                            AppInputTextfield(
                                              hintText: "L3 Remarks",
                                              maxLines: null,
                                              // height: 80,
                                              nameController:
                                                  shortfallApplDetailsProvider
                                                      .l3RemarksController,
                                              isReadOnly: true,
                                              textColor: Colors.grey,
                                            ),
                                          if ((shortfallApplDetailsProvider
                                                  .clusterApplDetails)
                                              .isNotEmpty)
                                            if ((shortfallApplDetailsProvider
                                                        .clusterApplDetails[0]
                                                        .officersComments ??
                                                    [])
                                                .isNotEmpty)
                                              OfficerApprovalStatusReusableWidget(
                                                  officerApprovalStatus:
                                                      shortfallApplDetailsProvider
                                                          .officerApprovalControllers,
                                                  officerIds:
                                                      shortfallApplDetailsProvider
                                                          .createdByControllers,
                                                  officerRemarks:
                                                      shortfallApplDetailsProvider
                                                          .notesAddedControllers),
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
                                    if (shortfallApplDetailsProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag:
                                              shortfallApplDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sroCodeEdit ??
                                                  "",
                                          callbackValue: (p0) async {
                                            shortfallApplDetailsProvider
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
                                            "${shortfallApplDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    AppInputTextfield(
                                      nameController:
                                          shortfallApplDetailsProvider
                                              .newMobileNoController,
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
                                        if (shortfallApplDetailsProvider
                                            .validateNewMobileNo(
                                                shortfallApplDetailsProvider
                                                    .newMobileNoController,
                                                context)) {
                                          String mobileNumberNew =
                                              shortfallApplDetailsProvider
                                                  .newMobileNoController.text;
                                          shortfallApplDetailsProvider
                                              .newMobileNoController
                                              .clear();
                                          shortfallApplDetailsProvider
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
                                                      shortfallApplDetailsProvider
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
                                      "${shortfallApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID}");
                                  await sharedpref.writeData(
                                    SharedPrefConstants.totalAreaExtent,
                                    shortfallApplDetailsProvider
                                        .netPlotAreaExtentController.text,
                                  );
                                  final sroCode = await LocalStoreHelper()
                                      .readTheData(SharedPrefConstants.sroCode);
                                  if (!context.mounted) return;
                                  shortfallApplDetailsProvider
                                      .navigateToUploadDocsScreen(
                                    context,
                                    applicationId: shortfallApplDetailsProvider
                                            .clusterApplDetails[0]
                                            .aPPLICATIONID ??
                                        "",
                                    layoutName: shortfallApplDetailsProvider
                                            .clusterApplDetails[0].lAYOUTNAME ??
                                        "",
                                    plotNo: shortfallApplDetailsProvider
                                        .plotNoController.text,
                                    areaExtent: shortfallApplDetailsProvider
                                        .netPlotAreaExtentController.text
                                        .trim(),
                                    plotAreaExtent: shortfallApplDetailsProvider
                                        .plotAreaExtentController.text
                                        .trim(),
                                    roadAreaExtent: shortfallApplDetailsProvider
                                        .roadEffectedAreaExtentController.text
                                        .trim(),
                                    masterplanZdp: shortfallApplDetailsProvider
                                            .selectedListMasterPlansZDP
                                            ?.landUseName ??
                                        "",
                                    sroCode: sroCode,
                                    layoutNmae: shortfallApplDetailsProvider
                                        .layoutNameController.text,
                                    applicationDetails:
                                        shortfallApplDetailsProvider
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
          if (shortfallApplDetailsProvider.getLoaderVisibilityStatus ||
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
      final shortfallApplDetailsProvider =
          Provider.of<ShortfallApplicationDetailsViewModel>(context,
              listen: false);

      if (shortfallApplDetailsProvider.isInitialized) return;

      if (!mounted) return;
      await shortfallApplDetailsProvider
          .getListOfMasterPlansZDPDetails(context);
      if (!mounted) return;
      await shortfallApplDetailsProvider.getClusterApplDetails(context);
      if (shortfallApplDetailsProvider.clusterApplDetails.isNotEmpty) {
        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            shortfallApplDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            shortfallApplDetailsProvider.clusterApplDetails[0].sALEDEEDNUMBER ??
                "");

        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            shortfallApplDetailsProvider.clusterApplDetails[0].sALEDEEDYEAR ??
                "");
        shortfallApplDetailsProvider.layoutNameController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].lAYOUTNAME ?? "";
        shortfallApplDetailsProvider.layoutOwnerController.text =
            shortfallApplDetailsProvider
                    .clusterApplDetails[0].lAYOUTOWNERNAME ??
                "";
        shortfallApplDetailsProvider.plotNoController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].pLOTNO ?? "";
        shortfallApplDetailsProvider.netPlotAreaExtentController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].aREAEXTENT ?? "";
        shortfallApplDetailsProvider
            .plotAreaExtentController.text = (shortfallApplDetailsProvider
                        .clusterApplDetails[0].pLOTAREAEXTENT ??
                    "".trim())
                .isEmpty
            ? shortfallApplDetailsProvider.clusterApplDetails[0].aREAEXTENT ??
                ""
            : shortfallApplDetailsProvider
                    .clusterApplDetails[0].pLOTAREAEXTENT ??
                "";
        shortfallApplDetailsProvider.roadEffectedAreaExtentController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].rOADAREAEXTENT ??
                "";
        shortfallApplDetailsProvider.villageNameController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].vILLAGENAME ??
                "";
        shortfallApplDetailsProvider.localityController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].lOCALITY ?? "";
        shortfallApplDetailsProvider.surveyNoController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].sURVEYNUMBER ??
                "";
        shortfallApplDetailsProvider.l1RemarksController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].l1Remarks ?? "";
        shortfallApplDetailsProvider.l2RemarksController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].l2Remarks ?? "";
        shortfallApplDetailsProvider.l3RemarksController.text =
            shortfallApplDetailsProvider.clusterApplDetails[0].l3Remarks ?? "";
        var officersCommentsList = shortfallApplDetailsProvider
                .clusterApplDetails[0].officersComments ??
            [];

        for (var comment in officersCommentsList) {
          // Create a controller for each field in officersCommentsList
          shortfallApplDetailsProvider.officerApprovalControllers
              .add(TextEditingController(text: comment.aPPROVALFLAG ?? ""));
          shortfallApplDetailsProvider.createdByControllers
              .add(TextEditingController(text: comment.cREATEDBY ?? ""));
          shortfallApplDetailsProvider.notesAddedControllers
              .add(TextEditingController(text: comment.aDDNOTES ?? ""));
        }
        /*  officerApprovalController.text = (shortfallApplDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (shortfallApplDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].aPPROVALFLAG ??
                "")
            : "";
        creartedByController.text = (shortfallApplDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (shortfallApplDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].cREATEDBY ??
                "")
            : "";
        notesAddedController.text = (shortfallApplDetailsProvider
                        .clusterApplDetails[0].officersComments ??
                    [])
                .isNotEmpty
            ? (shortfallApplDetailsProvider
                    .clusterApplDetails[0].officersComments?[0].aDDNOTES ??
                "")
            : ""; */

        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            shortfallApplDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            shortfallApplDetailsProvider.clusterApplDetails[0].sALEDEEDNUMBER ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.checkListKey,
            shortfallApplDetailsProvider.clusterApplDetails[0].strCHECKLIST ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            shortfallApplDetailsProvider.clusterApplDetails[0].sALEDEEDYEAR ??
                "");

        shortfallApplDetailsProvider.isInitialized = true;
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
  }
}
