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
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_application_details_view_model.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phase2RevertedApplicationDetails extends StatefulWidget {
  const Phase2RevertedApplicationDetails({super.key});

  @override
  State<Phase2RevertedApplicationDetails> createState() =>
      _Phase2RevertedApplicationDetailsState();
}

class _Phase2RevertedApplicationDetailsState
    extends State<Phase2RevertedApplicationDetails> {
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
    final phase2RevertedApplDetailsProvider =
        Provider.of<Phase2RevertedApplicationDetailsViewModel>(context);
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
              title: "Phase-2 Reverted Application Details",
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
                child: phase2RevertedApplDetailsProvider
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
                                          "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl:
                                            phase2RevertedApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sALEDEEDEC ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl:
                                            phase2RevertedApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .cOPYOFLAYOUT ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl:
                                            phase2RevertedApplDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .oTHERSDOC ??
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
                                            onChanged: (val) async {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setString(SharedPrefConstants.layoutNameKey, val);
                                            },
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
                                            onChanged: (val) async {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setString(SharedPrefConstants.plotNoKey, val);
                                            },
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
                                            onChanged: (p0) async {
                                              num plotArea =
                                                  num.tryParse(p0) ?? 0;
                                              num roadEffectedArea = num.tryParse(
                                                      roadEffectedAreaExtentController
                                                          .text) ??
                                                  0;
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setString(SharedPrefConstants.plotAreaExtentKey, p0);
                                              if (roadEffectedArea < plotArea) {
                                                if (plotArea -
                                                        roadEffectedArea >
                                                    0) {
                                                  num netplotArea = plotArea -
                                                      roadEffectedArea;
                                                  netPlotAreaExtentController
                                                      .text = "$netplotArea";
                                                  await prefs.setString(SharedPrefConstants.areaExtentKey, "$netplotArea");
                                                } else {
                                                  plotAreaExtentController
                                                      .clear();
                                                  netPlotAreaExtentController
                                                      .clear();
                                                  await prefs.setString(SharedPrefConstants.plotAreaExtentKey, "");
                                                  await prefs.setString(SharedPrefConstants.areaExtentKey, "");
                                                  if (!context.mounted) return;
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                              } else {
                                                roadEffectedAreaExtentController
                                                    .clear();
                                                netPlotAreaExtentController
                                                    .clear();
                                                await prefs.setString(SharedPrefConstants.roadAreaExtentKey, "");
                                                await prefs.setString(SharedPrefConstants.areaExtentKey, "");
                                                if (!context.mounted) return;
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
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setString(SharedPrefConstants.roadAreaExtentKey, value);

                                              if (plotArea > 0) {
                                                if (plotArea -
                                                        roadEffectedArea >
                                                    0) {
                                                  num netplotArea = plotArea -
                                                      roadEffectedArea;
                                                  final netPlotStr = netplotArea.toStringAsFixed(2);
                                                  netPlotAreaExtentController
                                                          .text = netPlotStr;
                                                  await prefs.setString(SharedPrefConstants.areaExtentKey, netPlotStr);
                                                } else {
                                                  roadEffectedAreaExtentController
                                                      .clear();
                                                  netPlotAreaExtentController
                                                      .clear();
                                                  await prefs.setString(SharedPrefConstants.roadAreaExtentKey, "");
                                                  await prefs.setString(SharedPrefConstants.areaExtentKey, "");
                                                  if (!context.mounted) return;
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
                                                await prefs.setString(SharedPrefConstants.roadAreaExtentKey, "");
                                                if (!context.mounted) return;
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
                                                items: phase2RevertedApplDetailsProvider
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
                                                  phase2RevertedApplDetailsProvider
                                                      .changeMasterPlanZDP(
                                                          newValue);
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  await prefs.setString(SharedPrefConstants.masterplanZdpKey, newValue?.landUseName ?? "");
                                                },
                                                selectedValue:
                                                    phase2RevertedApplDetailsProvider
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
                                          if ((phase2RevertedApplDetailsProvider
                                                  .clusterApplDetails)
                                              .isNotEmpty)
                                            if ((phase2RevertedApplDetailsProvider
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
                                    if (phase2RevertedApplDetailsProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag:
                                              phase2RevertedApplDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sroCodeEdit ??
                                                  "",
                                          callbackValue: (p0) async {
                                            phase2RevertedApplDetailsProvider
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
                                            "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
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
                                        if (phase2RevertedApplDetailsProvider
                                            .validateNewMobileNo(
                                                newMobileNoController,
                                                context)) {
                                          String mobileNumberNew =
                                              newMobileNoController.text;
                                          newMobileNoController.clear();
                                          phase2RevertedApplDetailsProvider
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
                                                      phase2RevertedApplDetailsProvider
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
                                      "${phase2RevertedApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID}");
                                  await sharedpref.writeData(
                                    SharedPrefConstants.totalAreaExtent,
                                    netPlotAreaExtentController.text,
                                  );
                                  final sroCode = await LocalStoreHelper()
                                      .readTheData(SharedPrefConstants.sroCode);
                                  if (!context.mounted) return;
                                  phase2RevertedApplDetailsProvider
                                      .navigateToUploadDocsScreen(
                                    context,
                                    applicationId:
                                        phase2RevertedApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .aPPLICATIONID ??
                                            "",
                                    layoutName:
                                        phase2RevertedApplDetailsProvider
                                                .clusterApplDetails[0]
                                                .lAYOUTNAME ??
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
                                        phase2RevertedApplDetailsProvider
                                                .selectedListMasterPlansZDP
                                                ?.landUseName ??
                                            "",
                                    sroCode: sroCode,
                                    layoutNmae: layoutNameController.text,
                                    applicationDetails:
                                        phase2RevertedApplDetailsProvider
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
          if (phase2RevertedApplDetailsProvider.getLoaderVisibilityStatus ||
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
      final phase2RevertedApplDetailsProvider =
          Provider.of<Phase2RevertedApplicationDetailsViewModel>(context,
              listen: false);

      if (!mounted) return;
      await phase2RevertedApplDetailsProvider
          .getListOfMasterPlansZDPDetails(context);
      if (!mounted) return;
      await phase2RevertedApplDetailsProvider.getClusterApplDetails(context);
      if (phase2RevertedApplDetailsProvider.clusterApplDetails.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final savedLayoutName = prefs.getString(SharedPrefConstants.layoutNameKey) ?? "";
        final savedPlotNo = prefs.getString(SharedPrefConstants.plotNoKey) ?? "";
        final savedPlotAreaExtent = prefs.getString(SharedPrefConstants.plotAreaExtentKey) ?? "";
        final savedRoadAreaExtent = prefs.getString(SharedPrefConstants.roadAreaExtentKey) ?? "";
        final savedAreaExtent = prefs.getString(SharedPrefConstants.areaExtentKey) ?? "";
        final savedZdp = prefs.getString(SharedPrefConstants.masterplanZdpKey) ?? "";

        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            phase2RevertedApplDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            phase2RevertedApplDetailsProvider
                    .clusterApplDetails[0].sALEDEEDNUMBER ??
                "");

        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            phase2RevertedApplDetailsProvider
                    .clusterApplDetails[0].sALEDEEDYEAR ??
                "");
        layoutNameController.text = (phase2RevertedApplDetailsProvider
                .clusterApplDetails[0].lAYOUTNAME ?? "").isNotEmpty
            ? phase2RevertedApplDetailsProvider.clusterApplDetails[0].lAYOUTNAME ?? ""
            : savedLayoutName;
        layoutOwnerController.text = phase2RevertedApplDetailsProvider
                .clusterApplDetails[0].lAYOUTOWNERNAME ??
            "";
        plotNoController.text = (phase2RevertedApplDetailsProvider.clusterApplDetails[0].pLOTNO ?? "").isNotEmpty
            ? phase2RevertedApplDetailsProvider.clusterApplDetails[0].pLOTNO ?? ""
            : savedPlotNo;
        netPlotAreaExtentController.text = (phase2RevertedApplDetailsProvider.clusterApplDetails[0].aREAEXTENT ?? "").isNotEmpty
            ? phase2RevertedApplDetailsProvider.clusterApplDetails[0].aREAEXTENT ?? ""
            : savedAreaExtent;
        plotAreaExtentController.text = (phase2RevertedApplDetailsProvider
                        .clusterApplDetails[0].pLOTAREAEXTENT ??
                    "".trim())
                .isEmpty
            ? ((phase2RevertedApplDetailsProvider.clusterApplDetails[0].aREAEXTENT ?? "").isNotEmpty
                ? phase2RevertedApplDetailsProvider.clusterApplDetails[0].aREAEXTENT ?? ""
                : savedPlotAreaExtent)
            : phase2RevertedApplDetailsProvider.clusterApplDetails[0].pLOTAREAEXTENT ?? "";
        roadEffectedAreaExtentController.text = (phase2RevertedApplDetailsProvider
                    .clusterApplDetails[0].rOADAREAEXTENT ?? "").isNotEmpty
            ? phase2RevertedApplDetailsProvider.clusterApplDetails[0].rOADAREAEXTENT ?? ""
            : savedRoadAreaExtent;
        villageNameController.text = phase2RevertedApplDetailsProvider
                .clusterApplDetails[0].vILLAGENAME ??
            "";
        localityController.text =
            phase2RevertedApplDetailsProvider.clusterApplDetails[0].lOCALITY ??
                "";
        surveyNoController.text = phase2RevertedApplDetailsProvider
                .clusterApplDetails[0].sURVEYNUMBER ??
            "";
        l1RemarksController.text =
            phase2RevertedApplDetailsProvider.clusterApplDetails[0].l1Remarks ??
                "";
        l2RemarksController.text =
            phase2RevertedApplDetailsProvider.clusterApplDetails[0].l2Remarks ??
                "";
        l3RemarksController.text =
            phase2RevertedApplDetailsProvider.clusterApplDetails[0].l3Remarks ??
                "";
        final zdp = (phase2RevertedApplDetailsProvider.clusterApplDetails[0].mASTERPLANZDP ?? "").isNotEmpty
            ? phase2RevertedApplDetailsProvider.clusterApplDetails[0].mASTERPLANZDP ?? ""
            : savedZdp;
        if (zdp.isNotEmpty) {
          phase2RevertedApplDetailsProvider.selectedListMasterPlansZDP =
              phase2RevertedApplDetailsProvider.listMasterPlansZDP.firstWhere(
            (element) {
              return (element.landUseId == zdp ||
                  element.landUseName?.toLowerCase() == zdp.toLowerCase());
            },
            orElse: () =>
                phase2RevertedApplDetailsProvider.listMasterPlansZDP[0],
          );
        }
        var officersCommentsList = phase2RevertedApplDetailsProvider
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

        await LocalStoreHelper().writeData(
            SharedPrefConstants.sroCode,
            phase2RevertedApplDetailsProvider
                    .clusterApplDetails[0].sROCODEFOURDIGITS ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedNo,
            phase2RevertedApplDetailsProvider
                    .clusterApplDetails[0].sALEDEEDNUMBER ??
                "");
        await LocalStoreHelper().writeData(
            SharedPrefConstants.saleDeedYear,
            phase2RevertedApplDetailsProvider
                    .clusterApplDetails[0].sALEDEEDYEAR ??
                "");

        final apiChecklist = (phase2RevertedApplDetailsProvider
                        .clusterApplDetails[0].listSaveDatas !=
                    null &&
                (phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].listSaveDatas?.length ??
                        0) !=
                    0)
            ? jsonEncode(phase2RevertedApplDetailsProvider
                .clusterApplDetails[0].listSaveDatas)
            : "";
        final savedChecklist = prefs.getString(SharedPrefConstants.checkListKey) ?? "";
        await prefs.setString(
            SharedPrefConstants.checkListKey,
            apiChecklist.isNotEmpty ? apiChecklist : savedChecklist);

        final apiLayoutDoc = phase2RevertedApplDetailsProvider.clusterApplDetails[0].lAYOUTDOC ?? "";
        final savedLayoutDoc = prefs.getString(SharedPrefConstants.layoutSelectedDocKey) ?? "";
        await prefs.setString(
            SharedPrefConstants.layoutSelectedDocKey,
            apiLayoutDoc.isNotEmpty ? apiLayoutDoc : savedLayoutDoc);

        final apiEcDoc = phase2RevertedApplDetailsProvider.clusterApplDetails[0].eCDOC ?? "";
        final savedEcDoc = prefs.getString(SharedPrefConstants.ecSelectedDocKey) ?? "";
        await prefs.setString(
            SharedPrefConstants.ecSelectedDocKey,
            apiEcDoc.isNotEmpty ? apiEcDoc : savedEcDoc);

        final apiOwnershipDoc = phase2RevertedApplDetailsProvider.clusterApplDetails[0].oWNERSHIPDOC ?? "";
        final savedOwnershipDoc = prefs.getString(SharedPrefConstants.ownershipSelectedDocKey) ?? "";
        await prefs.setString(
            SharedPrefConstants.ownershipSelectedDocKey,
            apiOwnershipDoc.isNotEmpty ? apiOwnershipDoc : savedOwnershipDoc);

        final apiPhoto1 = phase2RevertedApplDetailsProvider.clusterApplDetails[0].pHOTO1 ?? "";
        final savedPhoto1 = prefs.getString(SharedPrefConstants.plot1Img) ?? "";
        await prefs.setString(
            SharedPrefConstants.plot1Img,
            apiPhoto1.isNotEmpty ? apiPhoto1 : savedPhoto1);

        final apiPhoto2 = phase2RevertedApplDetailsProvider.clusterApplDetails[0].pHOTO2 ?? "";
        final savedPhoto2 = prefs.getString(SharedPrefConstants.plot2Img) ?? "";
        await prefs.setString(
            SharedPrefConstants.plot2Img,
            apiPhoto2.isNotEmpty ? apiPhoto2 : savedPhoto2);

        final apiPhoto3 = phase2RevertedApplDetailsProvider.clusterApplDetails[0].pHOTO3 ?? "";
        final savedPhoto3 = prefs.getString(SharedPrefConstants.plot3Img) ?? "";
        await prefs.setString(
            SharedPrefConstants.plot3Img,
            apiPhoto3.isNotEmpty ? apiPhoto3 : savedPhoto3);

        final apiPhoto4 = phase2RevertedApplDetailsProvider.clusterApplDetails[0].pHOTO4 ?? "";
        final savedPhoto4 = prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt) ?? "";
        await prefs.setString(
            SharedPrefConstants.plot4ImgMasterPlanExt,
            apiPhoto4.isNotEmpty ? apiPhoto4 : savedPhoto4);

        final apiGisCoordinate = phase2RevertedApplDetailsProvider.clusterApplDetails[0].gISCORDINATE ?? "";
        final savedGisCoordinate = prefs.getString(SharedPrefConstants.gisCoordinatesList) ?? "";
        await prefs.setString(
            SharedPrefConstants.gisCoordinatesList,
            apiGisCoordinate.isNotEmpty ? apiGisCoordinate : savedGisCoordinate);

        final apiMvEditFlag = phase2RevertedApplDetailsProvider.clusterApplDetails[0].mvEditFlag ?? "";
        final savedMvEditFlag = prefs.getString(SharedPrefConstants.mvEditFlagKey) ?? "";
        await prefs.setString(SharedPrefConstants.mvEditFlagKey, apiMvEditFlag.isNotEmpty ? apiMvEditFlag : savedMvEditFlag);

        final apiMvRate2020 = phase2RevertedApplDetailsProvider.clusterApplDetails[0].mVRATE2020 ?? "";
        final savedMvRate2020 = prefs.getString(SharedPrefConstants.mvRate2020Key) ?? "";
        await prefs.setString(SharedPrefConstants.mvRate2020Key, apiMvRate2020.isNotEmpty ? apiMvRate2020 : savedMvRate2020);

        final apiMvRateDoc = phase2RevertedApplDetailsProvider.clusterApplDetails[0].mVRATEDOCUMET ?? "";
        final savedMvRateDoc = prefs.getString(SharedPrefConstants.mvRateDocumentKey) ?? "";
        await prefs.setString(SharedPrefConstants.mvRateDocumentKey, apiMvRateDoc.isNotEmpty ? apiMvRateDoc : savedMvRateDoc);

        final apiConversionCharges = phase2RevertedApplDetailsProvider.clusterApplDetails[0].conversionCharges ?? "";
        final savedConversionCharges = prefs.getString(SharedPrefConstants.conversionChargesKey) ?? "";
        await prefs.setString(SharedPrefConstants.conversionChargesKey, apiConversionCharges.isNotEmpty ? apiConversionCharges : savedConversionCharges);
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
