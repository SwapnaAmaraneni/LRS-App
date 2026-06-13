import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';
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
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_application_details_view_model.dart';
import 'dart:async';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/plots_layouts/upload_plot_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortfallIrReApplicationDetails extends StatefulWidget {
  const ShortfallIrReApplicationDetails({super.key});

  @override
  State<ShortfallIrReApplicationDetails> createState() =>
      _ShortfallIrReApplicationDetailsState();
}

class _ShortfallIrReApplicationDetailsState
    extends State<ShortfallIrReApplicationDetails> {
  ScrollController? scrollBarController;
  List<UnSoldPlots> unsoldPlotsList = [];

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
    final shortFallIrReApplDetailsProvider =
        Provider.of<ShortfallApplicationDetailsViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);

    var layoutNameController = shortFallIrReApplDetailsProvider.layoutNameController;
    var layoutOwnerController = shortFallIrReApplDetailsProvider.layoutOwnerController;
    var ownerMobileNoController = shortFallIrReApplDetailsProvider.ownerMobileNoController;
    var plotNoController = shortFallIrReApplDetailsProvider.plotNoController;
    var plotAreaExtentController = shortFallIrReApplDetailsProvider.plotAreaExtentController;
    var roadEffectedAreaExtentController = shortFallIrReApplDetailsProvider.roadEffectedAreaExtentController;
    var netPlotAreaExtentController = shortFallIrReApplDetailsProvider.netPlotAreaExtentController;
    var totalNoOfLayoutPlotsController = shortFallIrReApplDetailsProvider.totalNoOfLayoutPlotsController;
    var soldLayoutPlotsController = shortFallIrReApplDetailsProvider.soldLayoutPlotsController;
    var unSoldLayoutPlotsController = shortFallIrReApplDetailsProvider.unSoldLayoutPlotsController;
    var totalUnsoldLayoutPlotsAreaController = shortFallIrReApplDetailsProvider.totalUnsoldLayoutPlotsAreaController;
    var villageNameController = shortFallIrReApplDetailsProvider.villageNameController;
    var localityController = shortFallIrReApplDetailsProvider.localityController;
    var surveyNoController = shortFallIrReApplDetailsProvider.surveyNoController;
    var zdpController = shortFallIrReApplDetailsProvider.zdpController;
    var latitudeController = shortFallIrReApplDetailsProvider.latitudeController;
    var longitudeController = shortFallIrReApplDetailsProvider.longitudeController;
    var applicationNoController = shortFallIrReApplDetailsProvider.applicationNoController;
    var applicantNameController = shortFallIrReApplDetailsProvider.applicantNameController;
    var fatherOrSpouseNameController = shortFallIrReApplDetailsProvider.fatherOrSpouseNameController;
    var aadharNumberController = shortFallIrReApplDetailsProvider.aadharNumberController;
    var genderController = shortFallIrReApplDetailsProvider.genderController;
    var addressController = shortFallIrReApplDetailsProvider.addressController;
    var houseNoController = shortFallIrReApplDetailsProvider.houseNoController;
    var streetOrColonyController = shortFallIrReApplDetailsProvider.streetOrColonyController;
    var applicantLocalityController = shortFallIrReApplDetailsProvider.applicantLocalityController;
    var townController = shortFallIrReApplDetailsProvider.townController;
    var districtController = shortFallIrReApplDetailsProvider.districtController;
    var pincodeController = shortFallIrReApplDetailsProvider.pincodeController;
    var applicantMobileNoController = shortFallIrReApplDetailsProvider.applicantMobileNoController;
    var emailIdController = shortFallIrReApplDetailsProvider.emailIdController;
    var alternateMobileNoController = shortFallIrReApplDetailsProvider.alternateMobileNoController;
    var totalPlotAreaController = shortFallIrReApplDetailsProvider.totalPlotAreaController;
    var conversionChargesController = shortFallIrReApplDetailsProvider.conversionChargesController;
    var mvAsOn26082020Controller = shortFallIrReApplDetailsProvider.mvAsOn26082020Controller;
    var mvAsonDateOfRegistraionController = shortFallIrReApplDetailsProvider.mvAsonDateOfRegistraionController;
    var regularizationChargesController = shortFallIrReApplDetailsProvider.regularizationChargesController;
    var openSpaceChargesController = shortFallIrReApplDetailsProvider.openSpaceChargesController;
    var totalRegularizationChargesController = shortFallIrReApplDetailsProvider.totalRegularizationChargesController;
    var initialAmountPaidController = shortFallIrReApplDetailsProvider.initialAmountPaidController;
    var l1RemarksController = shortFallIrReApplDetailsProvider.l1RemarksController;
    var l2RemarksController = shortFallIrReApplDetailsProvider.l2RemarksController;
    var l3RemarksController = shortFallIrReApplDetailsProvider.l3RemarksController;
    var officerApprovalControllers = shortFallIrReApplDetailsProvider.officerApprovalControllers;
    var createdByControllers = shortFallIrReApplDetailsProvider.createdByControllers;
    var notesAddedControllers = shortFallIrReApplDetailsProvider.notesAddedControllers;
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Shortfall Application Details",
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
                                                      if (shortFallIrReApplDetailsProvider
                                                          .clusterApplDetails
                                                          .isNotEmpty)
                                                        Column(
                                                          children: [
                                                            BuildDocumentView(
                                                                title:
                                                                    "Sales Deed Document",
                                                                pdfUrl: shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sALEDEEDEC ??
                                                                    ""),
                                                            BuildDocumentView(
                                                                title:
                                                                    "Layout Document",
                                                                pdfUrl: shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .cOPYOFLAYOUT ??
                                                                    ""),
                                                            BuildDocumentView(
                                                                title:
                                                                    "Other Document",
                                                                pdfUrl: shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .oTHERSDOC ??
                                                                    ""),
                                                            if ((shortFallIrReApplDetailsProvider.clusterApplDetails[0].sLAYOUTDOC != null && shortFallIrReApplDetailsProvider.clusterApplDetails[0].sLAYOUTDOC != "") ||
                                                                (shortFallIrReApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .sECDOC !=
                                                                        null &&
                                                                    shortFallIrReApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .sECDOC !=
                                                                        "") ||
                                                                (shortFallIrReApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .sOWNERSHIPDOC !=
                                                                        null &&
                                                                    shortFallIrReApplDetailsProvider
                                                                            .clusterApplDetails[0]
                                                                            .sOWNERSHIPDOC !=
                                                                        ""))
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            8.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    "Citizen Updated Document",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            if (shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sLAYOUTDOC !=
                                                                    null &&
                                                                shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sLAYOUTDOC !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Shortfall Layout Document",
                                                                  pdfUrl: shortFallIrReApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .sLAYOUTDOC ??
                                                                      ""),
                                                            if (shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sECDOC !=
                                                                    null &&
                                                                shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sECDOC !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Shortfall EC Document",
                                                                  pdfUrl: shortFallIrReApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .sECDOC ??
                                                                      ""),
                                                            if (shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sOWNERSHIPDOC !=
                                                                    null &&
                                                                shortFallIrReApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sOWNERSHIPDOC !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Shortfall Ownership Document",
                                                                  pdfUrl: shortFallIrReApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .sOWNERSHIPDOC ??
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
                                                                          UnSoldPlots
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
                                                      if ((shortFallIrReApplDetailsProvider
                                                              .clusterApplDetails)
                                                          .isNotEmpty)
                                                        if ((shortFallIrReApplDetailsProvider
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
                                                                  notesAddedControllers),
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
                                  : ((shortFallIrReApplDetailsProvider
                                              .clusterApplDetails)
                                          .isNotEmpty)
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.98,
                                          child: Card(
                                            elevation: 4.0,
                                            child: Column(
                                              children: [
                                                getTitleCard(
                                                  "Sale Deed Document Download",
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: DocumentDownload(
                                                    sroEditFlag:
                                                        shortFallIrReApplDetailsProvider
                                                                .clusterApplDetails[
                                                                    0]
                                                                .sroCodeEdit ??
                                                            "",
                                                    callbackValue: (p0) async {
                                                      shortFallIrReApplDetailsProvider
                                                          .setSroEdited(p0);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container();
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
                  shortFallIrReApplDetailsProvider.revenueNavigation(
                    applicationNo: applicationNoController.text,
                    layoutName: layoutNameController.text,
                    plotNo: plotNoController.text,
                    netPlotAreaExtent: netPlotAreaExtentController.text,
                    plotAreaExtent: plotAreaExtentController.text,
                    roadEffectedAreaExtent:
                        roadEffectedAreaExtentController.text,
                    zdp: zdpController.text,
                    layoutSelectedDoc: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].lAYOUTDOC ??
                        "",
                    ownershipSelectedDoc: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].oWNERSHIPDOC ??
                        "",
                    ecSelectedDoc: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].eCDOC ??
                        "",
                    captureLocScreenshot: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].pHOTO5 ??
                        "",
                    plot1Img: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].pHOTO1 ??
                        "",
                    plot2Img: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].pHOTO2 ??
                        "",
                    plot3Img: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].pHOTO3 ??
                        "",
                    plot4Img: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].pHOTO4 ??
                        "",
                    gisCoordinates: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].gISCORDINATE ??
                        "",
                    gisCoordinatesCount: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].gISCOUNT ??
                        "",
                    context: context,
                    conversionCharges: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].conversionCharges ??
                        "",
                    mVRATE2020: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].mVRATE2020 ??
                        "",
                    mVRATEDOCUMET: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].mVRATEDOCUMET ??
                        "",
                    srdpRdp: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].sROCODEFOURDIGITS ??
                        "",
                    rc: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].rC ??
                        "",
                    plotOpenspace: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].pLOTOPENSPACE ??
                        "",
                    trc: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].tRC ??
                        "",
                    vlt: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].vLT ??
                        "",
                    sroCode: sroCode,
                    saleDeedNo: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].sALEDEEDNUMBER ??
                        "",
                    saleDeedYear: shortFallIrReApplDetailsProvider
                            .clusterApplDetails[0].sALEDEEDYEAR ??
                        "",
                    latitude: latitudeController.text,
                    longitude: longitudeController.text,
                  );
                }),
          ),
        ),
        if (shortFallIrReApplDetailsProvider.getLoaderVisibilityStatus ||
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
      final shortFallIrReApplDetailsProvider =
          Provider.of<ShortfallApplicationDetailsViewModel>(context,
              listen: false);
      activeMeterIndex = 0;
      shortFallIrReApplDetailsProvider.setLoaderVisibleStatus(true);
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
        await shortFallIrReApplDetailsProvider.getListOfMasterPlansZDPDetails(
          context,
        );
        if (!mounted) return;
        await shortFallIrReApplDetailsProvider.getClusterApplDetails(
          context,
        );

        if (shortFallIrReApplDetailsProvider.isInitialized) return;

        var unsoldPlotsList = this.unsoldPlotsList;
        var layoutNameController = shortFallIrReApplDetailsProvider.layoutNameController;
        var layoutOwnerController = shortFallIrReApplDetailsProvider.layoutOwnerController;
        var ownerMobileNoController = shortFallIrReApplDetailsProvider.ownerMobileNoController;
        var plotNoController = shortFallIrReApplDetailsProvider.plotNoController;
        var plotAreaExtentController = shortFallIrReApplDetailsProvider.plotAreaExtentController;
        var roadEffectedAreaExtentController = shortFallIrReApplDetailsProvider.roadEffectedAreaExtentController;
        var netPlotAreaExtentController = shortFallIrReApplDetailsProvider.netPlotAreaExtentController;
        var totalNoOfLayoutPlotsController = shortFallIrReApplDetailsProvider.totalNoOfLayoutPlotsController;
        var soldLayoutPlotsController = shortFallIrReApplDetailsProvider.soldLayoutPlotsController;
        var unSoldLayoutPlotsController = shortFallIrReApplDetailsProvider.unSoldLayoutPlotsController;
        var totalUnsoldLayoutPlotsAreaController = shortFallIrReApplDetailsProvider.totalUnsoldLayoutPlotsAreaController;
        var villageNameController = shortFallIrReApplDetailsProvider.villageNameController;
        var localityController = shortFallIrReApplDetailsProvider.localityController;
        var surveyNoController = shortFallIrReApplDetailsProvider.surveyNoController;
        var zdpController = shortFallIrReApplDetailsProvider.zdpController;
        var latitudeController = shortFallIrReApplDetailsProvider.latitudeController;
        var longitudeController = shortFallIrReApplDetailsProvider.longitudeController;
        var applicationNoController = shortFallIrReApplDetailsProvider.applicationNoController;
        var applicantNameController = shortFallIrReApplDetailsProvider.applicantNameController;
        var fatherOrSpouseNameController = shortFallIrReApplDetailsProvider.fatherOrSpouseNameController;
        var aadharNumberController = shortFallIrReApplDetailsProvider.aadharNumberController;
        var genderController = shortFallIrReApplDetailsProvider.genderController;
        var addressController = shortFallIrReApplDetailsProvider.addressController;
        var houseNoController = shortFallIrReApplDetailsProvider.houseNoController;
        var streetOrColonyController = shortFallIrReApplDetailsProvider.streetOrColonyController;
        var applicantLocalityController = shortFallIrReApplDetailsProvider.applicantLocalityController;
        var townController = shortFallIrReApplDetailsProvider.townController;
        var districtController = shortFallIrReApplDetailsProvider.districtController;
        var pincodeController = shortFallIrReApplDetailsProvider.pincodeController;
        var applicantMobileNoController = shortFallIrReApplDetailsProvider.applicantMobileNoController;
        var emailIdController = shortFallIrReApplDetailsProvider.emailIdController;
        var alternateMobileNoController = shortFallIrReApplDetailsProvider.alternateMobileNoController;
        var totalPlotAreaController = shortFallIrReApplDetailsProvider.totalPlotAreaController;
        var conversionChargesController = shortFallIrReApplDetailsProvider.conversionChargesController;
        var mvAsOn26082020Controller = shortFallIrReApplDetailsProvider.mvAsOn26082020Controller;
        var mvAsonDateOfRegistraionController = shortFallIrReApplDetailsProvider.mvAsonDateOfRegistraionController;
        var regularizationChargesController = shortFallIrReApplDetailsProvider.regularizationChargesController;
        var openSpaceChargesController = shortFallIrReApplDetailsProvider.openSpaceChargesController;
        var totalRegularizationChargesController = shortFallIrReApplDetailsProvider.totalRegularizationChargesController;
        var initialAmountPaidController = shortFallIrReApplDetailsProvider.initialAmountPaidController;
        var l1RemarksController = shortFallIrReApplDetailsProvider.l1RemarksController;
        var l2RemarksController = shortFallIrReApplDetailsProvider.l2RemarksController;
        var l3RemarksController = shortFallIrReApplDetailsProvider.l3RemarksController;
        var officerApprovalControllers = shortFallIrReApplDetailsProvider.officerApprovalControllers;
        var createdByControllers = shortFallIrReApplDetailsProvider.createdByControllers;
        var notesAddedControllers = shortFallIrReApplDetailsProvider.notesAddedControllers;
        if (shortFallIrReApplDetailsProvider.clusterApplDetails.isNotEmpty) {
          unsoldPlotsList = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].unSoldPlotsList ??
              [];
          layoutNameController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].lAYOUTNAME ??
              "";
          layoutOwnerController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          ownerMobileNoController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].oWNERMOBILENUMBER ??
              "";
          plotNoController.text =
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].pLOTNO ??
                  "";
          netPlotAreaExtentController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].aREAEXTENT ??
              "";
          plotAreaExtentController.text = (shortFallIrReApplDetailsProvider
                          .clusterApplDetails[0].pLOTAREAEXTENT ??
                      "".trim())
                  .isEmpty
              ? shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].aREAEXTENT ??
                  ""
              : shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].pLOTAREAEXTENT ??
                  "";
          roadEffectedAreaExtentController.text =
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].rOADAREAEXTENT ??
                  "";
          roadEffectedAreaExtentController.text =
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].rOADAREAEXTENT ??
                  "";
          addressController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].aPPLICANTADDRESS ??
              "";

          //layout
          totalNoOfLayoutPlotsController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].totalNoPlots ??
              "";
          soldLayoutPlotsController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].totalNoPlots ??
              "";
          unSoldLayoutPlotsController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].totalNoOfUnSoldPlots ??
              "";
          totalUnsoldLayoutPlotsAreaController.text =
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].totalNoAreaExtent ??
                  "";

          //layout
          villageNameController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          localityController.text =
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].lOCALITY ??
                  "";
          surveyNoController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].sURVEYNUMBER ??
              "";
          // application details
          applicationNoController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          applicantNameController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          fatherOrSpouseNameController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].fATHERHUSBANDNAME ??
              "";
          aadharNumberController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].aADHARNUMBER ??
              "";
          genderController.text =
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].gENDER ??
                  "";
          houseNoController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].hNODOORNO ??
              "";
          streetOrColonyController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].sTREETCOLONY ??
              "";
          applicantLocalityController.text =
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].lOCALITY ??
                  "";
          townController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          applicationNoController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          final zdp = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].mASTERPLANZDP ??
              "";
          if (zdp.isNotEmpty) {
            shortFallIrReApplDetailsProvider.selectedListMasterPlansZDP =
                shortFallIrReApplDetailsProvider.listMasterPlansZDP.firstWhere(
              (element) {
                return (element.landUseId == zdp ||
                    element.landUseName?.toLowerCase() == zdp.toLowerCase());
              },
              orElse: () =>
                  shortFallIrReApplDetailsProvider.listMasterPlansZDP[0],
            );
          }
          zdpController.text = shortFallIrReApplDetailsProvider
                  .selectedListMasterPlansZDP?.landUseName ??
              "";

          districtController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].dISTRICTNAME ??
              "";
          pincodeController.text =
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].pINCODE ??
                  "";
          applicantMobileNoController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].oWNERMOBILENUMBER ??
              "";
          emailIdController.text =
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].eMAILID ??
                  "";
          alternateMobileNoController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].aLTERMOBILENO ??
              "";
          totalPlotAreaController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].pLOTAREAEXTENT ??
              "";
          // payment details
          conversionChargesController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].conversionCharges ??
              "";
          mvAsOn26082020Controller.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].mVRATE2020 ??
              "";
          mvAsonDateOfRegistraionController.text =
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].mVRATEDOCUMET ??
                  "";
          regularizationChargesController.text =
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].rC ?? "";
          openSpaceChargesController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].pLOTOPENSPACE ??
              "";
          totalRegularizationChargesController.text =
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].tRC ?? "";
          initialAmountPaidController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].iNITIALPAYMENTAMOUNT ??
              "";
          latitudeController.text = (shortFallIrReApplDetailsProvider
                          .clusterApplDetails[0].latitude ??
                      "${currentPos.latitude}")
                  .isNotEmpty
              ? shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].latitude ??
                  "${currentPos.latitude}"
              : "${currentPos.latitude}";
          longitudeController.text = (shortFallIrReApplDetailsProvider
                          .clusterApplDetails[0].longitude ??
                      "${currentPos.longitude}")
                  .isNotEmpty
              ? shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].longitude ??
                  "${currentPos.longitude}"
              : "${currentPos.longitude}";
          l1RemarksController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].l1Remarks ??
              "";
          l2RemarksController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].l2Remarks ??
              "";
          l3RemarksController.text = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].l3Remarks ??
              "";
          var officersCommentsList = shortFallIrReApplDetailsProvider
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
          /*  officerApprovalController.text = (shortFallIrReApplDetailsProvider
                          .clusterApplDetails[0].officersComments ??
                      [])
                  .isNotEmpty
              ? (shortFallIrReApplDetailsProvider.clusterApplDetails[0]
                      .officersComments?[0].aPPROVALFLAG ??
                  "")
              : "";
          creartedByController.text = (shortFallIrReApplDetailsProvider
                          .clusterApplDetails[0].officersComments ??
                      [])
                  .isNotEmpty
              ? (shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].officersComments?[0].cREATEDBY ??
                  "")
              : "";
          notesAddedController.text = (shortFallIrReApplDetailsProvider
                          .clusterApplDetails[0].officersComments ??
                      [])
                  .isNotEmpty
              ? (shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].officersComments?[0].aDDNOTES ??
                  "")
              : ""; */
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final checkListStr = (shortFallIrReApplDetailsProvider
                          .clusterApplDetails[0].checkList !=
                      null &&
                  (shortFallIrReApplDetailsProvider
                              .clusterApplDetails[0].checkList?.length ??
                          0) !=
                      0)
              ? jsonEncode(shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].checkList)
              : [];
          prefs.setString(
              SharedPrefConstants.checkListKey, checkListStr.toString());
          await LocalStoreHelper().writeData(
              SharedPrefConstants.sroCode,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].sROCODEFOURDIGITS ??
                  "");
          await LocalStoreHelper().writeData(
              SharedPrefConstants.saleDeedNo,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].sALEDEEDNUMBER ??
                  "");
          await LocalStoreHelper().writeData(
              SharedPrefConstants.saleDeedYear,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].sALEDEEDYEAR ??
                  "");
                  
          shortFallIrReApplDetailsProvider.isInitialized = true;
          prefs.setString(
              SharedPrefConstants.layoutSelectedDocKey,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].lAYOUTDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.ecSelectedDocKey,
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].eCDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.ownershipSelectedDocKey,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].oWNERSHIPDOC ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot1Img,
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].pHOTO1 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot2Img,
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].pHOTO2 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot3Img,
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].pHOTO3 ??
                  "");
          prefs.setString(
              SharedPrefConstants.plot4ImgMasterPlanExt,
              shortFallIrReApplDetailsProvider.clusterApplDetails[0].pHOTO4 ??
                  "");
          prefs.setString(
              SharedPrefConstants.gisCoordinatesList,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].gISCORDINATE ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvEditFlagKey,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].mvEditFlag ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvRate2020Key,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].mVRATE2020 ??
                  "");
          prefs.setString(
              SharedPrefConstants.mvRateDocumentKey,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].mVRATEDOCUMET ??
                  "");
          prefs.setString(
              SharedPrefConstants.conversionChargesKey,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].conversionCharges ??
                  "");
          prefs.setString(
              SharedPrefConstants.applicationNo,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].aPPLICATIONID ??
                  "");
          prefs.setString(
              SharedPrefConstants.areaExtentKey,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].aREAEXTENT ??
                  "");
          prefs.setString(
              SharedPrefConstants.totalunsoldPlotAreakey,
              shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].totalNoAreaExtent ??
                  "");
          AppConstants.maxCoordinatesCount = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].maxCoordinatesCount ??
              "";
          AppConstants.minCoordinatesCount = shortFallIrReApplDetailsProvider
                  .clusterApplDetails[0].minCoordinatesCount ??
              "";
          if ((shortFallIrReApplDetailsProvider
                      .clusterApplDetails[0].officersComments ??
                  [])
              .isNotEmpty) {
            prefs.setString(
                SharedPrefConstants.recommendationsKey,
                shortFallIrReApplDetailsProvider.clusterApplDetails[0]
                        .officersComments?[0].aPPROVALFLAG ??
                    "");
            prefs.setString(
                SharedPrefConstants.notesKey,
                shortFallIrReApplDetailsProvider
                        .clusterApplDetails[0].officersComments?[0].aDDNOTES ??
                    "");
          }
          setState(() {
            activeMeterIndex = 1;
            updateExpansionTile();
          });
          shortFallIrReApplDetailsProvider.isInitialized = true;
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
