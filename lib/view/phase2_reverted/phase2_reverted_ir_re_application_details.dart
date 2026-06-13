import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/res/reusable_widgets/officer_approval_status_reusable_widget.dart';
import 'package:lrsofficer/res/reusable_widgets/pdf_view_widget.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view/document_download.dart';
import 'dart:async';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_application_details_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/upload_plot_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phase2RevertedIrReApplicationDetails extends StatefulWidget {
  const Phase2RevertedIrReApplicationDetails({super.key});

  @override
  State<Phase2RevertedIrReApplicationDetails> createState() =>
      _Phase2RevertedIrReApplicationDetailsState();
}

class _Phase2RevertedIrReApplicationDetailsState
    extends State<Phase2RevertedIrReApplicationDetails> {
  ScrollController? scrollBarController;
  List<ListUnsoldPlots> unsoldPlotsList = [];
  TextEditingController layoutNameController = TextEditingController();
  TextEditingController layoutOwnerController = TextEditingController();
  TextEditingController ownerMobileNoController = TextEditingController();
  TextEditingController plotNoController = TextEditingController();
  TextEditingController plotAreaExtentController = TextEditingController();
  TextEditingController roadEffectedAreaExtentController =
      TextEditingController();
  TextEditingController netPlotAreaExtentController = TextEditingController();
  TextEditingController totalNoOfLayoutPlotsController =
      TextEditingController();
  TextEditingController soldLayoutPlotsController = TextEditingController();
  TextEditingController unSoldLayoutPlotsController = TextEditingController();
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
  TextEditingController emailIdController = TextEditingController();
  TextEditingController alternateMobileNoController = TextEditingController();
  TextEditingController totalPlotAreaController = TextEditingController();

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

  List titleList = [
    "SavedApplicationDetails".tr(),
    "plotDetails".tr(),
    "Document"
  ];
  int? activeMeterIndex;
  // Expansion Panel
  final StreamController activeMeterIndexStreamControl =
      StreamController.broadcast();

  Stream get onUpdateActiveIndex => activeMeterIndexStreamControl.stream;

  void updateExpansionTile() =>
      activeMeterIndexStreamControl.sink.add(activeMeterIndex);

  @override
  Widget build(BuildContext context) {
    final phase2RevertedApplDetailsProvider =
        Provider.of<Phase2RevertedApplicationDetailsViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Phase-2 Reverted Application Details",
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
                                          headerBuilder: (BuildContext context,
                                              bool isExpanded) {
                                            return ListTile(
                                                title:
                                                    getTitleCard(titleList[i]));
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
                                                            "aplicantName".tr(),
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
                                                            emailIdController,
                                                        isReadOnly: true,
                                                      ),
                                                      AppInputTextfield(
                                                        hintText:
                                                            "Alternate Mobile Number",
                                                        nameController:
                                                            alternateMobileNoController,
                                                        isReadOnly: true,
                                                      ),
                                                      AppInputTextfield(
                                                        hintText:
                                                            "Total Plot Area/Extent in Sq.Yards",
                                                        nameController:
                                                            totalPlotAreaController,
                                                        isReadOnly: true,
                                                      ),
                                                      if (phase2RevertedApplDetailsProvider
                                                          .clusterApplDetails
                                                          .isNotEmpty)
                                                        Column(
                                                          children: [
                                                            BuildDocumentView(
                                                                title:
                                                                    "Sales Deed Document",
                                                                pdfUrl: phase2RevertedApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sALEDEEDEC ??
                                                                    ""),
                                                            BuildDocumentView(
                                                                title:
                                                                    "Layout Document",
                                                                pdfUrl: phase2RevertedApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .cOPYOFLAYOUT ??
                                                                    ""),
                                                            BuildDocumentView(
                                                                title:
                                                                    "Other Document",
                                                                pdfUrl: phase2RevertedApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .oTHERSDOC ??
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
                                                        hintText: "Layout Name",
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
                                                        textColor: Colors.grey,
                                                      ),
                                                      AppInputTextfield(
                                                        hintText:
                                                            "Owner Mobile Number",
                                                        nameController:
                                                            ownerMobileNoController,
                                                        isReadOnly: true,
                                                        textColor: Colors.grey,
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
                                                              isReadOnly: true,
                                                              nameController:
                                                                  plotNoController,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0),
                                                                  child:
                                                                      AppInputTextfield(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    hintText:
                                                                        "Plot Area Extent Sq.Yards",
                                                                    isReadOnly:
                                                                        true,
                                                                    nameController:
                                                                        plotAreaExtentController,
                                                                  ),
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
                                                                    height: 40,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            AppInputTextfield(
                                                              hintText:
                                                                  "Road Effected Area Extent Sq.Yards",
                                                              isReadOnly: true,
                                                              nameController:
                                                                  roadEffectedAreaExtentController,
                                                            ),
                                                            AppInputTextfield(
                                                              hintText:
                                                                  "Net plot Area Extent Sq.Yards",
                                                              nameController:
                                                                  netPlotAreaExtentController,
                                                              isReadOnly: true,
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
                                                            AppInputTextfield(
                                                              hintText:
                                                                  "Total No of Plots",
                                                              nameController:
                                                                  totalNoOfLayoutPlotsController,
                                                              isReadOnly: true,
                                                              textColor:
                                                                  Colors.grey,
                                                            ),
                                                            AppInputTextfield(
                                                              hintText:
                                                                  "Sold Plots",
                                                              nameController:
                                                                  soldLayoutPlotsController,
                                                              isReadOnly: true,
                                                              textColor:
                                                                  Colors.grey,
                                                            ),
                                                            AppInputTextfield(
                                                              hintText:
                                                                  "Unsold Plots",
                                                              nameController:
                                                                  unSoldLayoutPlotsController,
                                                              isReadOnly: true,
                                                              textColor:
                                                                  Colors.grey,
                                                            ),
                                                            if (unsoldPlotsList
                                                                .isNotEmpty)
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border
                                                                        .all(),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0), // Optional: rounded corners
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                8.0,
                                                                            left:
                                                                                8.0),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              Text(
                                                                            "Unsold Plots List",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      ListView
                                                                          .builder(
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            unsoldPlotsList.length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          ListUnsoldPlots
                                                                              plotsDetails =
                                                                              unsoldPlotsList[index];
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(6.0),
                                                                            child:
                                                                                Card(
                                                                              color: Colors.white,
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                                                          child: buildLabelValueRow(
                                                                                            "Plot No",
                                                                                            "${plotsDetails.plotNo}",
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                                                          child: buildLabelValueRow(
                                                                                            "Plot Area Extent",
                                                                                            "${plotsDetails.plotAreaExtent}",
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            Row(
                                                              children: [
                                                                AppInputTextfield(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8,
                                                                  hintText:
                                                                      "Total Unsold Plots Area(Sq.Yrds)",
                                                                  nameController:
                                                                      totalUnsoldLayoutPlotsAreaController,
                                                                  isReadOnly:
                                                                      true,
                                                                  textColor:
                                                                      Colors
                                                                          .grey,
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
                                                                    height: 40,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      AppInputTextfield(
                                                        hintText:
                                                            "Village Name",
                                                        nameController:
                                                            villageNameController,
                                                        isReadOnly: true,
                                                        textColor: Colors.grey,
                                                      ),
                                                      AppInputTextfield(
                                                        hintText: "Locality",
                                                        nameController:
                                                            localityController,
                                                        isReadOnly: true,
                                                        textColor: Colors.grey,
                                                      ),
                                                      AppInputTextfield(
                                                        hintText:
                                                            "Survey Number",
                                                        nameController:
                                                            surveyNoController,
                                                        isReadOnly: true,
                                                        textColor: Colors.grey,
                                                      ),
                                                      AppInputTextfield(
                                                        hintText:
                                                            "Land use as per Master Plan/ZDP",
                                                        nameController:
                                                            zdpController,
                                                        isReadOnly: true,
                                                      ),
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
                                                      if ((phase2RevertedApplDetailsProvider
                                                              .clusterApplDetails)
                                                          .isNotEmpty)
                                                        if ((phase2RevertedApplDetailsProvider
                                                                    .clusterApplDetails[
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
                                                                  notesAddedControllers)
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
                                      width: MediaQuery.of(context).size.width *
                                          0.98,
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
                                                              .clusterApplDetails[
                                                                  0]
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
                  phase2RevertedApplDetailsProvider.revenueNavigation(
                    applicationNo: applicationNoController.text,
                    layoutName: layoutNameController.text,
                    plotNo: plotNoController.text,
                    netPlotAreaExtent: netPlotAreaExtentController.text,
                    plotAreaExtent: plotAreaExtentController.text,
                    roadEffectedAreaExtent:
                        roadEffectedAreaExtentController.text,
                    zdp: zdpController.text,
                    layoutSelectedDoc: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].lAYOUTDOC ??
                        "",
                    ownershipSelectedDoc: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].oWNERSHIPDOC ??
                        "",
                    ecSelectedDoc: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].eCDOC ??
                        "",
                    captureLocScreenshot: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].pHOTO5 ??
                        "",
                    plot1Img: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].pHOTO1 ??
                        "",
                    plot2Img: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].pHOTO2 ??
                        "",
                    plot3Img: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].pHOTO3 ??
                        "",
                    plot4Img: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].pHOTO4 ??
                        "",
                    gisCoordinates: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].gISCORDINATE ??
                        "",
                    gisCoordinatesCount: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].gISCOUNT ??
                        "",
                    context: context,
                    conversionCharges: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].conversionCharges ??
                        "",
                    mVRATE2020: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].mVRATE2020 ??
                        "",
                    mVRATEDOCUMET: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].mVRATEDOCUMET ??
                        "",
                    srdpRdp: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].sROCODEFOURDIGITS ??
                        "",
                    rc: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].rC ??
                        "",
                    plotOpenspace: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].pLOTOPENSPACE ??
                        "",
                    trc: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].tRC ??
                        "",
                    vlt: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].vLT ??
                        "",
                    sroCode: sroCode,
                    saleDeedNo: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].sALEDEEDNUMBER ??
                        "",
                    saleDeedYear: phase2RevertedApplDetailsProvider
                            .clusterApplDetails[0].sALEDEEDYEAR ??
                        "",
                    latitude: latitudeController.text,
                    longitude: longitudeController.text,
                  );
                }),
          ),
        ),
        if (phase2RevertedApplDetailsProvider.getLoaderVisibilityStatus ||
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
      final phase2RevertedApplDetailsProvider =
          Provider.of<Phase2RevertedApplicationDetailsViewModel>(context,
              listen: false);
      activeMeterIndex = 0;
      phase2RevertedApplDetailsProvider.setLoaderVisibleStatus(true);
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
        await phase2RevertedApplDetailsProvider.getListOfMasterPlansZDPDetails(
          context,
        );
        if (!mounted) return;
        await phase2RevertedApplDetailsProvider.getClusterApplDetails(
          context,
        );
        if (phase2RevertedApplDetailsProvider.clusterApplDetails.isNotEmpty) {
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
          unsoldPlotsList = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].listUnsoldPlots ??
              [];
          layoutNameController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].lAYOUTNAME ??
              "";
          layoutOwnerController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          ownerMobileNoController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].oWNERMOBILENUMBER ??
              "";
          plotNoController.text =
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].pLOTNO ??
                  "";
          netPlotAreaExtentController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].aREAEXTENT ??
              "";
          plotAreaExtentController.text = (phase2RevertedApplDetailsProvider
                          .clusterApplDetails[0].pLOTAREAEXTENT ??
                      "".trim())
                  .isEmpty
              ? phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].aREAEXTENT ??
                  ""
              : phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].pLOTAREAEXTENT ??
                  "";
          roadEffectedAreaExtentController.text =
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].rOADAREAEXTENT ??
                  "";
          roadEffectedAreaExtentController.text =
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].rOADAREAEXTENT ??
                  "";
          addressController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].aPPLICANTADDRESS ??
              "";

          //layout
          totalNoOfLayoutPlotsController.text =
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].totalNoPlots ??
                  "";
          soldLayoutPlotsController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].totalNoPlots ??
              "";
          unSoldLayoutPlotsController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].totalNoUnSoldPlots ??
              "";
          totalUnsoldLayoutPlotsAreaController.text =
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].totalNoAreaExtent ??
                  "";

          //layout
          villageNameController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          localityController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].lOCALITY ??
              "";
          surveyNoController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].sURVEYNUMBER ??
              "";
          // application details
          applicationNoController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          applicantNameController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          fatherOrSpouseNameController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].fATHERHUSBANDNAME ??
              "";
          aadharNumberController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].aADHARNUMBER ??
              "";
          genderController.text =
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].gENDER ??
                  "";
          houseNoController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].hNODOORNO ??
              "";
          streetOrColonyController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].sTREETCOLONY ??
              "";
          applicantLocalityController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].lOCALITY ??
              "";
          townController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          applicationNoController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          final zdp = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].mASTERPLANZDP ??
              "";
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
          zdpController.text = phase2RevertedApplDetailsProvider
                  .selectedListMasterPlansZDP?.landUseName ??
              "";
          districtController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].dISTRICTNAME ??
              "";
          pincodeController.text =
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].pINCODE ??
                  "";
          applicantMobileNoController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].oWNERMOBILENUMBER ??
              "";
          emailIdController.text =
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].eMAILID ??
                  "";
          alternateMobileNoController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].aLTERMOBILENO ??
              "";
          totalPlotAreaController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].pLOTAREAEXTENT ??
              "";
          // payment details
          conversionChargesController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].conversionCharges ??
              "";
          mvAsOn26082020Controller.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].mVRATE2020 ??
              "";
          mvAsonDateOfRegistraionController.text =
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].mVRATEDOCUMET ??
                  "";
          regularizationChargesController.text =
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].rC ?? "";
          openSpaceChargesController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].pLOTOPENSPACE ??
              "";
          totalRegularizationChargesController.text =
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].tRC ?? "";
          initialAmountPaidController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].iNITIALPAYMENTAMOUNT ??
              "";
          latitudeController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].latitude
                  ?.toString() ??
              currentPos.latitude.toString();
          longitudeController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].longitude
                  ?.toString() ??
              currentPos.longitude.toString();
          l1RemarksController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].l1Remarks ??
              "";
          l2RemarksController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].l2Remarks ??
              "";
          l3RemarksController.text = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].l3Remarks ??
              "";

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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final checkListStr = (phase2RevertedApplDetailsProvider
                          .clusterApplDetails[0].listSaveDatas !=
                      null &&
                  (phase2RevertedApplDetailsProvider
                              .clusterApplDetails[0].listSaveDatas?.length ??
                          0) !=
                      0)
              ? jsonEncode(phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].listSaveDatas)
              : [];
          prefs.setString(
              SharedPrefConstants.checkListKey, checkListStr.toString());
          prefs.setString(
              SharedPrefConstants.layoutSelectedDocKey,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].lAYOUTDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.ecSelectedDocKey,
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].eCDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.ownershipSelectedDocKey,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].oWNERSHIPDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot1Img,
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].pHOTO1 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot2Img,
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].pHOTO2 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot3Img,
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].pHOTO3 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot4ImgMasterPlanExt,
              phase2RevertedApplDetailsProvider.clusterApplDetails[0].pHOTO4 ??
                  "");
          prefs.setString(
              SharedPrefConstants.gisCoordinatesList,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].gISCORDINATE ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvEditFlagKey,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].mvEditFlag ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvRate2020Key,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].mVRATE2020 ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvRateDocumentKey,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].mVRATEDOCUMET ??
                  "");
          prefs.setString(
              SharedPrefConstants.conversionChargesKey,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].conversionCharges ??
                  "");
          prefs.setString(
              SharedPrefConstants.applicationNo,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].aPPLICATIONID ??
                  "");
          prefs.setString(
              SharedPrefConstants.areaExtentKey,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].aREAEXTENT ??
                  "");
          prefs.setString(
              SharedPrefConstants.totalunsoldPlotAreakey,
              phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].totalNoAreaExtent ??
                  "");
          AppConstants.maxCoordinatesCount = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].maxCoordinatesCount ??
              "";
          AppConstants.minCoordinatesCount = phase2RevertedApplDetailsProvider
                  .clusterApplDetails[0].minCoordinatesCount ??
              "";
          if ((phase2RevertedApplDetailsProvider
                      .clusterApplDetails[0].officersComments ??
                  [])
              .isNotEmpty) {
            prefs.setString(
                SharedPrefConstants.recommendationsKey,
                phase2RevertedApplDetailsProvider.clusterApplDetails[0]
                        .officersComments?[0].aPPROVALFLAG ??
                    "");
            prefs.setString(
                SharedPrefConstants.notesKey,
                phase2RevertedApplDetailsProvider
                        .clusterApplDetails[0].officersComments?[0].aDDNOTES ??
                    "");
          }
          activeMeterIndex = 1;
          updateExpansionTile();
          setState(() {});
        }
      }
    });
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
