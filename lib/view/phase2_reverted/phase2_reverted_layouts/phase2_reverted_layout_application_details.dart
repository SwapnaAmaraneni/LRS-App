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
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phase2RevertedLayoutApplicationDetails extends StatefulWidget {
  const Phase2RevertedLayoutApplicationDetails({super.key});

  @override
  State<Phase2RevertedLayoutApplicationDetails> createState() =>
      _Phase2RevertedLayoutApplicationDetailsState();
}

class _Phase2RevertedLayoutApplicationDetailsState
    extends State<Phase2RevertedLayoutApplicationDetails> {
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
    final phase2RevertedLayoutAppDetailsProvider =
        Provider.of<Phase2RevertedLayoutApplicationDetailsViewModel>(context);
    final updateMobileProvider = Provider.of<UpdateMobileNoViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
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
                child: phase2RevertedLayoutAppDetailsProvider
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
                                          "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID}"),
                                      buildLabelValueRow("Applicant Name",
                                          "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].lAYOUTOWNERNAME}"),
                                    ],
                                  ),
                                  children: [
                                    buildLabelValueRow("Aadhar No",
                                        "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].aADHARNUMBER}"),
                                    buildLabelValueRow("Owner Mobile Number",
                                        "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
                                    buildLabelValueRow("Address",
                                        "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICANTADDRESS}"),
                                    buildLabelValueRow("District Name",
                                        "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].dISTRICTNAME}"),
                                    buildLabelValueRow("Pincode",
                                        "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].pINCODE}"),
                                    BuildDocumentView(
                                        title: "Sales Deed Document",
                                        pdfUrl:
                                            phase2RevertedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .sALEDEEDEC ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Layout Document",
                                        pdfUrl:
                                            phase2RevertedLayoutAppDetailsProvider
                                                    .clusterApplDetails[0]
                                                    .cOPYOFLAYOUT ??
                                                ""),
                                    BuildDocumentView(
                                        title: "Other Document",
                                        pdfUrl:
                                            phase2RevertedLayoutAppDetailsProvider
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
                                          QuestionTile(
                                            question:
                                                "Do you want to enter Unsold plot Details",
                                            selectedAnswer:
                                                phase2RevertedLayoutAppDetailsProvider
                                                    .selectedUnsoldPlotDetails,
                                            onChanged: (value) async {
                                              phase2RevertedLayoutAppDetailsProvider
                                                  .totalNoOfPlotsController
                                                  .clear();
                                              phase2RevertedLayoutAppDetailsProvider
                                                  .soldPlotsController
                                                  .clear();
                                              phase2RevertedLayoutAppDetailsProvider
                                                  .unsoldPlotsController
                                                  .clear();
                                              phase2RevertedLayoutAppDetailsProvider
                                                  .changeUnsoldPlotDetails(
                                                      value ?? "");
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setString(SharedPrefConstants.selectedUnsoldPlotKey, value ?? "");
                                              await prefs.setString(SharedPrefConstants.totalNoOfPlotsKey, "");
                                              await prefs.setString(SharedPrefConstants.soldPlotsKey, "");
                                              await prefs.setString(SharedPrefConstants.unsoldPlotsKey, "");
                                            },
                                          ),
                                          AppInputTextfield(
                                            hintText: "Total No of Plots",
                                            length: 10,
                                            nameController:
                                                phase2RevertedLayoutAppDetailsProvider
                                                    .totalNoOfPlotsController,
                                            inputType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onChanged: (p0) async {
                                              phase2RevertedLayoutAppDetailsProvider
                                                  .soldPlotsController
                                                  .clear();
                                              phase2RevertedLayoutAppDetailsProvider
                                                  .unsoldPlotsController
                                                  .clear();
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setString(SharedPrefConstants.totalNoOfPlotsKey, p0);
                                              await prefs.setString(SharedPrefConstants.soldPlotsKey, "");
                                              await prefs.setString(SharedPrefConstants.unsoldPlotsKey, "");
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
                                                phase2RevertedLayoutAppDetailsProvider
                                                    .soldPlotsController,
                                            onChanged: (p0) async {
                                              final totalPlots = (int.tryParse(
                                                      phase2RevertedLayoutAppDetailsProvider
                                                          .totalNoOfPlotsController
                                                          .text) ??
                                                  0);
                                              final soldPlots = (int.tryParse(
                                                      p0) ??
                                                  0);
                                              if (totalPlots > soldPlots) {
                                                final unsoldPlotsVal = (totalPlots - soldPlots).toString();
                                                phase2RevertedLayoutAppDetailsProvider
                                                        .unsoldPlotsController
                                                        .text = unsoldPlotsVal;
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                await prefs.setString(SharedPrefConstants.soldPlotsKey, p0);
                                                await prefs.setString(SharedPrefConstants.unsoldPlotsKey, unsoldPlotsVal);
                                              } else {
                                                ErrorCustomCupertinoAlert()
                                                    .showAlert(
                                                  context,
                                                  message:
                                                      "Sold plots cannot be greater than total No.of plots",
                                                  onPressed: () {
                                                    phase2RevertedLayoutAppDetailsProvider
                                                        .unsoldPlotsController
                                                        .clear();
                                                    phase2RevertedLayoutAppDetailsProvider
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
                                                phase2RevertedLayoutAppDetailsProvider
                                                    .unsoldPlotsController,
                                          ),
                                          phase2RevertedLayoutAppDetailsProvider
                                                      .selectedUnsoldPlotDetails ==
                                                  'N'
                                              ? AppInputTextfield(
                                                  length: 10,
                                                  hintText:
                                                      "Total Unsold Plots Area(Sq.Yrds)",
                                                  nameController:
                                                      phase2RevertedLayoutAppDetailsProvider
                                                          .totalUnsoldPlotAreaController,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d+\.?\d{0,2}')),
                                                  ],
                                                  inputType: const TextInputType
                                                      .numberWithOptions(
                                                      decimal: true),
                                                  onChanged: (val) async {
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    await prefs.setString(SharedPrefConstants.totalunsoldPlotAreakey, val);
                                                  },
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
                                                items: phase2RevertedLayoutAppDetailsProvider
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
                                                  phase2RevertedLayoutAppDetailsProvider
                                                      .changeMasterPlanZDP(
                                                          newValue);
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  await prefs.setString(SharedPrefConstants.masterplanZdpKey, newValue?.landUseName ?? "");
                                                },
                                                selectedValue:
                                                    phase2RevertedLayoutAppDetailsProvider
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
                                          if ((phase2RevertedLayoutAppDetailsProvider
                                                  .clusterApplDetails)
                                              .isNotEmpty)
                                            if ((phase2RevertedLayoutAppDetailsProvider
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
                                    if (phase2RevertedLayoutAppDetailsProvider
                                        .clusterApplDetails.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: DocumentDownload(
                                          sroEditFlag:
                                              phase2RevertedLayoutAppDetailsProvider
                                                      .clusterApplDetails[0]
                                                      .sroCodeEdit ??
                                                  "",
                                          callbackValue: (p0) async {
                                            phase2RevertedLayoutAppDetailsProvider
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
                                            "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].oWNERMOBILENUMBER}"),
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
                                        if (phase2RevertedLayoutAppDetailsProvider
                                            .validateNewMobileNo(
                                                newMobileNoController,
                                                context)) {
                                          String mobileNumberNew =
                                              newMobileNoController.text;
                                          newMobileNoController.clear();
                                          phase2RevertedLayoutAppDetailsProvider
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
                                                      phase2RevertedLayoutAppDetailsProvider
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
                                      "${phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].aPPLICATIONID}");
                                  final sroCode = await LocalStoreHelper()
                                      .readTheData(SharedPrefConstants.sroCode);
                                  if (!context.mounted) return;
                                  phase2RevertedLayoutAppDetailsProvider
                                      .navigateToUploadDocsScreen(
                                    context,
                                    applicationId:
                                        phase2RevertedLayoutAppDetailsProvider
                                                .clusterApplDetails[0]
                                                .aPPLICATIONID ??
                                            "",
                                    layoutName: layoutNameController.text,
                                    /*   plotNo: phase2RevertedLayoutAppDetailsProvider
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
                                        phase2RevertedLayoutAppDetailsProvider
                                                .selectedListMasterPlansZDP
                                                ?.landUseName ??
                                            "",
                                    sroCode: sroCode,
                                    layoutNmae: layoutNameController.text,
                                    applicationDetails:
                                        phase2RevertedLayoutAppDetailsProvider
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
          if (phase2RevertedLayoutAppDetailsProvider
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
      final phase2RevertedLayoutAppDetailsProvider =
          Provider.of<Phase2RevertedLayoutApplicationDetailsViewModel>(context,
              listen: false);
      phase2RevertedLayoutAppDetailsProvider.setLoaderVisibleStatus(true);
      final uploadPlotDetailsProvider =
          Provider.of<Phase2RevertedUploadPlotDetailsViewModel>(context,
              listen: false);
      final locEnabled =
          await uploadPlotDetailsProvider.handleLocationPermission(context);
      if (locEnabled) {
        final currentPos = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
        );
        if (!mounted) return;
        await phase2RevertedLayoutAppDetailsProvider
            .getListOfMasterPlansZDPDetails(context);
        if (!mounted) return;
        await phase2RevertedLayoutAppDetailsProvider.getClusterApplDetails(
          context,
        );
        if (phase2RevertedLayoutAppDetailsProvider
            .clusterApplDetails.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final savedLayoutName = prefs.getString(SharedPrefConstants.layoutNameKey) ?? "";
          final savedTotalNoOfPlots = prefs.getString(SharedPrefConstants.totalNoOfPlotsKey) ?? "";
          final savedSoldPlots = prefs.getString(SharedPrefConstants.soldPlotsKey) ?? "";
          final savedUnsoldPlots = prefs.getString(SharedPrefConstants.unsoldPlotsKey) ?? "";
          final savedTotalUnsoldPlotArea = prefs.getString(SharedPrefConstants.totalunsoldPlotAreakey) ?? "";
          final savedZdp = prefs.getString(SharedPrefConstants.masterplanZdpKey) ?? "";
          final savedUnsoldPlotRadio = prefs.getString(SharedPrefConstants.selectedUnsoldPlotKey) ?? "";

          unsoldPlotsList = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].listUnsoldPlots ??
              [];
          if (savedUnsoldPlotRadio.isNotEmpty) {
            phase2RevertedLayoutAppDetailsProvider.changeUnsoldPlotDetails(savedUnsoldPlotRadio);
          } else if (unsoldPlotsList.isNotEmpty) {
            phase2RevertedLayoutAppDetailsProvider.changeUnsoldPlotDetails('Y');
          } else {
            phase2RevertedLayoutAppDetailsProvider.changeUnsoldPlotDetails('N');
          }
          await LocalStoreHelper().writeData(
              SharedPrefConstants.sroCode,
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].sROCODEFOURDIGITS ??
                  "");
          await LocalStoreHelper().writeData(
              SharedPrefConstants.saleDeedNo,
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].sALEDEEDNUMBER ??
                  "");

          await LocalStoreHelper().writeData(
              SharedPrefConstants.saleDeedYear,
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].sALEDEEDYEAR ??
                  "");
          layoutNameController.text = (phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].lAYOUTNAME ?? "").isNotEmpty
              ? phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].lAYOUTNAME ?? ""
              : savedLayoutName;
          layoutOwnerController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          ownerMobileNoController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].oWNERMOBILENUMBER ??
              "";
          plotNoController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].pLOTNO ??
              "";

          addressController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].aPPLICANTADDRESS ??
              "";

          //layout
          phase2RevertedLayoutAppDetailsProvider.totalNoOfPlotsController.text =
              (phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].totalNoPlots ?? "").isNotEmpty
              ? phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].totalNoPlots ?? ""
              : savedTotalNoOfPlots;
          phase2RevertedLayoutAppDetailsProvider.soldPlotsController.text =
              (phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].totalNoSoldPlots ?? "").isNotEmpty
              ? phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].totalNoSoldPlots ?? ""
              : savedSoldPlots;
          phase2RevertedLayoutAppDetailsProvider.unsoldPlotsController.text =
              (phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].totalNoUnSoldPlots ?? "").isNotEmpty
              ? phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].totalNoUnSoldPlots ?? ""
              : savedUnsoldPlots;
          phase2RevertedLayoutAppDetailsProvider.totalUnsoldPlotAreaController.text =
              (phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].totalNoAreaExtent ?? "").isNotEmpty
              ? phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].totalNoAreaExtent ?? ""
              : savedTotalUnsoldPlotArea;

          //layout
          villageNameController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          localityController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].lOCALITY ??
              "";
          surveyNoController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].sURVEYNUMBER ??
              "";
          // application details
          applicationNoController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          applicantNameController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          fatherOrSpouseNameController.text =
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].fATHERHUSBANDNAME ??
                  "";
          aadharNumberController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].aADHARNUMBER ??
              "";
          genderController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].gENDER ??
              "";
          houseNoController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].hNODOORNO ??
              "";
          streetOrColonyController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].sTREETCOLONY ??
              "";
          applicantLocalityController.text =
              phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].lOCALITY ??
              "";
          townController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          applicationNoController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          zdpController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].mASTERPLANZDP ??
              "";

          l1RemarksController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].l1Remarks ??
              "";
          l2RemarksController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].l2Remarks ??
              "";
          l3RemarksController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].l3Remarks ??
              "";

          final zdp = (phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].mASTERPLANZDP ?? "").isNotEmpty
              ? phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].mASTERPLANZDP ?? ""
              : savedZdp;
          if (zdp.isNotEmpty) {
            phase2RevertedLayoutAppDetailsProvider.selectedListMasterPlansZDP =
                phase2RevertedLayoutAppDetailsProvider.listMasterPlansZDP
                    .firstWhere(
              (element) {
                return (element.landUseId == zdp ||
                    element.landUseName?.toLowerCase() == zdp.toLowerCase());
              },
              orElse: () =>
                  phase2RevertedLayoutAppDetailsProvider.listMasterPlansZDP[0],
            );
          }
          districtController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].dISTRICTNAME ??
              "";
          pincodeController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].pINCODE ??
              "";
          applicantMobileNoController.text =
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].oWNERMOBILENUMBER ??
                  "";
          emailIdController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].eMAILID ??
              "";
          alternateMobileNoController.text =
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].aLTERMOBILENO ??
              "";
          latitudeController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].latitude ??
              "${currentPos.latitude}";
          longitudeController.text = phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].longitude ??
              "${currentPos.longitude}";
          var officersCommentsList = phase2RevertedLayoutAppDetailsProvider
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
          final apiChecklist = (phase2RevertedLayoutAppDetailsProvider
                          .clusterApplDetails[0].listSaveDatas !=
                      null &&
                  (phase2RevertedLayoutAppDetailsProvider
                              .clusterApplDetails[0].listSaveDatas?.length ??
                          0) !=
                      0)
              ? jsonEncode(phase2RevertedLayoutAppDetailsProvider
                  .clusterApplDetails[0].listSaveDatas)
              : "";
          final savedChecklist = prefs.getString(SharedPrefConstants.checkListKey) ?? "";
          await prefs.setString(
              SharedPrefConstants.checkListKey,
              apiChecklist.isNotEmpty ? apiChecklist : savedChecklist);

          final apiLayoutDoc = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].lAYOUTDOC ?? "";
          final savedLayoutDoc = prefs.getString(SharedPrefConstants.layoutSelectedDocKey) ?? "";
          await prefs.setString(
              SharedPrefConstants.layoutSelectedDocKey,
              apiLayoutDoc.isNotEmpty ? apiLayoutDoc : savedLayoutDoc);

          final apiEcDoc = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].eCDOC ?? "";
          final savedEcDoc = prefs.getString(SharedPrefConstants.ecSelectedDocKey) ?? "";
          await prefs.setString(
              SharedPrefConstants.ecSelectedDocKey,
              apiEcDoc.isNotEmpty ? apiEcDoc : savedEcDoc);

          final apiOwnershipDoc = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].oWNERSHIPDOC ?? "";
          final savedOwnershipDoc = prefs.getString(SharedPrefConstants.ownershipSelectedDocKey) ?? "";
          await prefs.setString(
              SharedPrefConstants.ownershipSelectedDocKey,
              apiOwnershipDoc.isNotEmpty ? apiOwnershipDoc : savedOwnershipDoc);

          final apiPhoto1 = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].pHOTO1 ?? "";
          final savedPhoto1 = prefs.getString(SharedPrefConstants.plot1Img) ?? "";
          await prefs.setString(
              SharedPrefConstants.plot1Img,
              apiPhoto1.isNotEmpty ? apiPhoto1 : savedPhoto1);

          final apiPhoto2 = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].pHOTO2 ?? "";
          final savedPhoto2 = prefs.getString(SharedPrefConstants.plot2Img) ?? "";
          await prefs.setString(
              SharedPrefConstants.plot2Img,
              apiPhoto2.isNotEmpty ? apiPhoto2 : savedPhoto2);

          final apiPhoto3 = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].pHOTO3 ?? "";
          final savedPhoto3 = prefs.getString(SharedPrefConstants.plot3Img) ?? "";
          await prefs.setString(
              SharedPrefConstants.plot3Img,
              apiPhoto3.isNotEmpty ? apiPhoto3 : savedPhoto3);

          final apiPhoto4 = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].pHOTO4 ?? "";
          final savedPhoto4 = prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt) ?? "";
          await prefs.setString(
              SharedPrefConstants.plot4ImgMasterPlanExt,
              apiPhoto4.isNotEmpty ? apiPhoto4 : savedPhoto4);

          final apiGisCoordinate = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].gISCORDINATE ?? "";
          final savedGisCoordinate = prefs.getString(SharedPrefConstants.gisCoordinatesList) ?? "";
          await prefs.setString(
              SharedPrefConstants.gisCoordinatesList,
              apiGisCoordinate.isNotEmpty ? apiGisCoordinate : savedGisCoordinate);

          final apiMvEditFlag = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].mvEditFlag ?? "";
          final savedMvEditFlag = prefs.getString(SharedPrefConstants.mvEditFlagKey) ?? "";
          await prefs.setString(SharedPrefConstants.mvEditFlagKey, apiMvEditFlag.isNotEmpty ? apiMvEditFlag : savedMvEditFlag);

          final apiMvRate2020 = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].mVRATE2020 ?? "";
          final savedMvRate2020 = prefs.getString(SharedPrefConstants.mvRate2020Key) ?? "";
          await prefs.setString(SharedPrefConstants.mvRate2020Key, apiMvRate2020.isNotEmpty ? apiMvRate2020 : savedMvRate2020);

          final apiMvRateDoc = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].mVRATEDOCUMET ?? "";
          final savedMvRateDoc = prefs.getString(SharedPrefConstants.mvRateDocumentKey) ?? "";
          await prefs.setString(SharedPrefConstants.mvRateDocumentKey, apiMvRateDoc.isNotEmpty ? apiMvRateDoc : savedMvRateDoc);

          final apiConversionCharges = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].conversionCharges ?? "";
          final savedConversionCharges = prefs.getString(SharedPrefConstants.conversionChargesKey) ?? "";
          await prefs.setString(SharedPrefConstants.conversionChargesKey, apiConversionCharges.isNotEmpty ? apiConversionCharges : savedConversionCharges);

          await prefs.setString(
              SharedPrefConstants.applicationNo,
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].aPPLICATIONID ??
                  "");
          await prefs.setString(
              SharedPrefConstants.areaExtentKey,
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].aREAEXTENT ??
                  "");
          await prefs.setString(
              SharedPrefConstants.totalunsoldPlotAreakey,
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].totalNoAreaExtent ??
                  "");
          AppConstants.maxCoordinatesCount =
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].maxCoordinatesCount ??
                  "";
          AppConstants.minCoordinatesCount =
              phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].minCoordinatesCount ??
                  "";
          if ((phase2RevertedLayoutAppDetailsProvider
                      .clusterApplDetails[0].officersComments ??
                  [])
              .isNotEmpty) {
            final apiRec = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].officersComments?[0].aPPROVALFLAG ?? "";
            final savedRec = prefs.getString(SharedPrefConstants.recommendationsKey) ?? "";
            await prefs.setString(SharedPrefConstants.recommendationsKey, apiRec.isNotEmpty ? apiRec : savedRec);

            final apiNotes = phase2RevertedLayoutAppDetailsProvider.clusterApplDetails[0].officersComments?[0].aDDNOTES ?? "";
            final savedNotes = prefs.getString(SharedPrefConstants.notesKey) ?? "";
            await prefs.setString(SharedPrefConstants.notesKey, apiNotes.isNotEmpty ? apiNotes : savedNotes);
          }

          setState(() {});
        }
      }
    });
  }

  void clearSavedData(BuildContext context) {
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModelNew>(context, listen: false);
    final phase2RevertedLayoutAppDetailsProvider =
        Provider.of<Phase2RevertedLayoutApplicationDetailsViewModel>(context,
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

    phase2RevertedLayoutAppDetailsProvider.soldPlotsController.clear();
    phase2RevertedLayoutAppDetailsProvider.unsoldPlotsController.clear();
    phase2RevertedLayoutAppDetailsProvider.totalNoOfPlotsController.clear();
    phase2RevertedLayoutAppDetailsProvider.selectedUnsoldPlotDetails = null;
    phase2RevertedLayoutAppDetailsProvider.totalUnsoldPlotAreaController
        .clear();
  }
}
