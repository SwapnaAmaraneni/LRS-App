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
import 'dart:async';
import 'package:lrsofficer/view_model/plots_layouts/cluster_application_details_view_model.dart';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/plots_layouts/upload_plot_details_view_model.dart';
import 'package:provider/provider.dart';

class IrReApplicationDetails extends StatefulWidget {
  const IrReApplicationDetails({super.key});

  @override
  State<IrReApplicationDetails> createState() => _IrReApplicationDetailsState();
}

class _IrReApplicationDetailsState extends State<IrReApplicationDetails> {
  ScrollController? scrollBarController;
  List<UnSoldPlots> unsoldPlotsList = [];
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

  List titleList = ["appDetails".tr(), "plotDetails".tr(), "Document"];
  int? activeMeterIndex;
  // Expansion Panel
  final StreamController activeMeterIndexStreamControl =
      StreamController.broadcast();

  Stream get onUpdateActiveIndex => activeMeterIndexStreamControl.stream;

  void updateExpansionTile() =>
      activeMeterIndexStreamControl.sink.add(activeMeterIndex);

  @override
  Widget build(BuildContext context) {
    final clusterwiseApplDetailsProvider =
        Provider.of<ClusterApplicationDetailsViewModel>(context);
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "viewAppDetails".tr(),
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
                                                      if (clusterwiseApplDetailsProvider
                                                          .clusterApplDetails
                                                          .isNotEmpty)
                                                        Column(
                                                          children: [
                                                            BuildDocumentView(
                                                                title:
                                                                    "Sales Deed Document",
                                                                pdfUrl: clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .sALEDEEDEC ??
                                                                    ""),
                                                            BuildDocumentView(
                                                                title:
                                                                    "Layout Document",
                                                                pdfUrl: clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .cOPYOFLAYOUT ??
                                                                    ""),
                                                            BuildDocumentView(
                                                                title:
                                                                    "Other Document",
                                                                pdfUrl: clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .oTHERSDOC ??
                                                                    ""),
                                                            if ((clusterwiseApplDetailsProvider.clusterApplDetails[0].prohibitedDoc1 != null && clusterwiseApplDetailsProvider.clusterApplDetails[0].prohibitedDoc1 != "") ||
                                                                (clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc2 !=
                                                                        null &&
                                                                    clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc2 !=
                                                                        "") ||
                                                                (clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc3 !=
                                                                        null &&
                                                                    clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc3 !=
                                                                        "") ||
                                                                (clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc4 !=
                                                                        null &&
                                                                    clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc4 !=
                                                                        "") ||
                                                                (clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc5 !=
                                                                        null &&
                                                                    clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc5 !=
                                                                        "") ||
                                                                (clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibitedDoc6 !=
                                                                        null &&
                                                                    clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[0]
                                                                            .prohibitedDoc6 !=
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
                                                            if (clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc1 !=
                                                                    null &&
                                                                clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc1 !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Sale Deed Document",
                                                                  pdfUrl: clusterwiseApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .prohibitedDoc1 ??
                                                                      ""),
                                                            if (clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc2 !=
                                                                    null &&
                                                                clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc2 !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Link Document",
                                                                  pdfUrl: clusterwiseApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .prohibitedDoc2 ??
                                                                      ""),
                                                            if (clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc3 !=
                                                                    null &&
                                                                clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc3 !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Layout Copy",
                                                                  pdfUrl: clusterwiseApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .prohibitedDoc3 ??
                                                                      ""),
                                                            if (clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc4 !=
                                                                    null &&
                                                                clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc4 !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Plot site plan",
                                                                  pdfUrl: clusterwiseApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .prohibitedDoc4 ??
                                                                      ""),
                                                            if (clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc5 !=
                                                                    null &&
                                                                clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc5 !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Other Document 1",
                                                                  pdfUrl: clusterwiseApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .prohibitedDoc5 ??
                                                                      ""),
                                                            if (clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc6 !=
                                                                    null &&
                                                                clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibitedDoc6 !=
                                                                    "")
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Other Document 2",
                                                                  pdfUrl: clusterwiseApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .prohibitedDoc6 ??
                                                                      ""),
                                                            if ((clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibittedAdditionalDoc1 !=
                                                                        null &&
                                                                    clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibittedAdditionalDoc1 !=
                                                                        "") ||
                                                                (clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[
                                                                                0]
                                                                            .prohibittedAdditionalDoc2 !=
                                                                        null &&
                                                                    clusterwiseApplDetailsProvider
                                                                            .clusterApplDetails[0]
                                                                            .prohibittedAdditionalDoc2 !=
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
                                                                    "Additional Documents",
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
                                                            if ((clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibittedAdditionalDoc1 !=
                                                                    null &&
                                                                clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibittedAdditionalDoc1 !=
                                                                    ""))
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Additional Document",
                                                                  pdfUrl: clusterwiseApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .prohibittedAdditionalDoc1 ??
                                                                      ""),
                                                            if ((clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibittedAdditionalDoc2 !=
                                                                    null &&
                                                                clusterwiseApplDetailsProvider
                                                                        .clusterApplDetails[
                                                                            0]
                                                                        .prohibittedAdditionalDoc2 !=
                                                                    ""))
                                                              BuildDocumentView(
                                                                  title:
                                                                      "Additional Document",
                                                                  pdfUrl: clusterwiseApplDetailsProvider
                                                                          .clusterApplDetails[
                                                                              0]
                                                                          .prohibittedAdditionalDoc2 ??
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
                                                              SizedBox(
                                                                height: 150,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.95,
                                                                child: Card(
                                                                  color: Colors
                                                                      .white,
                                                                  elevation:
                                                                      6.0,
                                                                  child:
                                                                      Scrollbar(
                                                                    controller:
                                                                        scrollBarController, // Mandatory: ScrollController

                                                                    thumbVisibility:
                                                                        true, // For always showing Scroll Bar: Use this
                                                                    thickness:
                                                                        5, // Optional: Thickness
                                                                    radius: const Radius
                                                                        .circular(
                                                                        5), // Optional: Radius
                                                                    child: ListView
                                                                        .builder(
                                                                      controller:
                                                                          scrollBarController,
                                                                      itemCount:
                                                                          unsoldPlotsList
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        UnSoldPlots
                                                                            plotsDetails =
                                                                            unsoldPlotsList[index];
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              6.0),
                                                                          child:
                                                                              Card(
                                                                            color:
                                                                                Colors.white,
                                                                            child:
                                                                                Row(
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
                                                                  ),
                                                                ),
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
                                                                        "Total Unsold Plots Area(Sq.Yrds)",
                                                                    nameController:
                                                                        totalUnsoldLayoutPlotsAreaController,
                                                                    isReadOnly:
                                                                        true,
                                                                    textColor:
                                                                        Colors
                                                                            .grey,
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
                                                      if ((clusterwiseApplDetailsProvider
                                                              .clusterApplDetails)
                                                          .isNotEmpty)
                                                        if ((clusterwiseApplDetailsProvider
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
                                            if (clusterwiseApplDetailsProvider
                                                .clusterApplDetails.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: DocumentDownload(
                                                  sroEditFlag:
                                                      clusterwiseApplDetailsProvider
                                                              .clusterApplDetails[
                                                                  0]
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
                                    );
                            });
                      },
                    ),
                  ),
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
                clusterwiseApplDetailsProvider.revenueNavigation(
                  applicationNo: applicationNoController.text,
                  layoutName: layoutNameController.text,
                  plotNo: plotNoController.text,
                  netPlotAreaExtent: netPlotAreaExtentController.text,
                  plotAreaExtent: plotAreaExtentController.text,
                  roadEffectedAreaExtent: roadEffectedAreaExtentController.text,
                  zdp: zdpController.text,
                  layoutSelectedDoc: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].lAYOUTDOC ??
                      "",
                  ownershipSelectedDoc: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].oWNERSHIPDOC ??
                      "",
                  ecSelectedDoc: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].eCDOC ??
                      "",
                  captureLocScreenshot: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].pHOTO5 ??
                      "",
                  plot1Img: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].pHOTO1 ??
                      "",
                  plot2Img: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].pHOTO2 ??
                      "",
                  plot3Img: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].pHOTO3 ??
                      "",
                  plot4Img: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].pHOTO4 ??
                      "",
                  gisCoordinates: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].gISCORDINATE ??
                      "",
                  gisCoordinatesCount: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].gISCOUNT ??
                      "",
                  context: context,
                  conversionCharges: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].conversionCharges ??
                      "",
                  mVRATE2020: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].mVRATE2020 ??
                      "",
                  mVRATEDOCUMET: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].mVRATEDOCUMET ??
                      "",
                  srdpRdp: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].sROCODEFOURDIGITS ??
                      "",
                  rc: clusterwiseApplDetailsProvider.clusterApplDetails[0].rC ??
                      "",
                  plotOpenspace: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].pLOTOPENSPACE ??
                      "",
                  trc: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].tRC ??
                      "",
                  vlt: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].vLT ??
                      "",
                  sroCode: sroCode,
                  saleDeedNo: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].sALEDEEDNUMBER ??
                      "",
                  saleDeedYear: clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].sALEDEEDYEAR ??
                      "",
                  latitude: latitudeController.text,
                  longitude: longitudeController.text,
                );
              },
            ),
          ),
        ),
        if (clusterwiseApplDetailsProvider.getLoaderVisibilityStatus ||
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
      final clusterwiseApplDetailsProvider =
          Provider.of<ClusterApplicationDetailsViewModel>(context,
              listen: false);
      activeMeterIndex = 0;
      clusterwiseApplDetailsProvider.setLoaderVisibleStatus(true);
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
        await clusterwiseApplDetailsProvider
            .getListOfMasterPlansZDPDetails(context);
        if (!mounted) return;
        await clusterwiseApplDetailsProvider.getClusterApplDetails(
          context,
        );
        if (clusterwiseApplDetailsProvider.clusterApplDetails.isNotEmpty) {
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
              SharedPrefConstants.saleDeedYear,
              clusterwiseApplDetailsProvider
                      .clusterApplDetails[0].sALEDEEDYEAR ??
                  "");
          unsoldPlotsList = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].unSoldPlotsList ??
              [];
          layoutNameController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].lAYOUTNAME ??
                  "";
          layoutOwnerController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          ownerMobileNoController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].oWNERMOBILENUMBER ??
              "";
          plotNoController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].pLOTNO ?? "";
          netPlotAreaExtentController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].aREAEXTENT ??
                  "";
          plotAreaExtentController.text = (clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].pLOTAREAEXTENT ??
                      "".trim())
                  .isEmpty
              ? clusterwiseApplDetailsProvider
                      .clusterApplDetails[0].aREAEXTENT ??
                  ""
              : clusterwiseApplDetailsProvider
                      .clusterApplDetails[0].pLOTAREAEXTENT ??
                  "";
          roadEffectedAreaExtentController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].rOADAREAEXTENT ??
              "";
          addressController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].aPPLICANTADDRESS ??
              "";

          //layout
          totalNoOfLayoutPlotsController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].totalNoPlots ??
              "";
          soldLayoutPlotsController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].totalNoOfSoldPlots ??
              "";
          unSoldLayoutPlotsController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].totalNoOfUnSoldPlots ??
              "";
          totalUnsoldLayoutPlotsAreaController.text =
              clusterwiseApplDetailsProvider
                      .clusterApplDetails[0].totalNoAreaExtent ??
                  "";

          //layout
          villageNameController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          localityController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].lOCALITY ??
                  "";
          surveyNoController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].sURVEYNUMBER ??
              "";
          // application details
          applicationNoController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          applicantNameController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].lAYOUTOWNERNAME ??
              "";
          fatherOrSpouseNameController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].fATHERHUSBANDNAME ??
              "";
          aadharNumberController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].aADHARNUMBER ??
              "";
          genderController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].gENDER ?? "";
          houseNoController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].hNODOORNO ??
                  "";
          streetOrColonyController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].sTREETCOLONY ??
              "";
          applicantLocalityController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].lOCALITY ??
                  "";
          townController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].vILLAGENAME ??
              "";
          applicationNoController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].aPPLICATIONID ??
              "";
          zdpController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].mASTERPLANZDP ??
              "";
          districtController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].dISTRICTNAME ??
              "";
          pincodeController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].pINCODE ??
                  "";
          applicantMobileNoController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].oWNERMOBILENUMBER ??
              "";
          emailIdController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].eMAILID ??
                  "";
          alternateMobileNoController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].aLTERMOBILENO ??
              "";
          totalPlotAreaController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].pLOTAREAEXTENT ??
              "";
          // payment details
          conversionChargesController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].conversionCharges ??
              "";
          mvAsOn26082020Controller.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].mVRATE2020 ??
                  "";
          mvAsonDateOfRegistraionController.text =
              clusterwiseApplDetailsProvider
                      .clusterApplDetails[0].mVRATEDOCUMET ??
                  "";
          regularizationChargesController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].rC ?? "";
          openSpaceChargesController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].pLOTOPENSPACE ??
              "";
          totalRegularizationChargesController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].tRC ?? "";
          initialAmountPaidController.text = clusterwiseApplDetailsProvider
                  .clusterApplDetails[0].iNITIALPAYMENTAMOUNT ??
              "";
          latitudeController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].latitude ??
                  "${currentPos.latitude}";
          longitudeController.text =
              clusterwiseApplDetailsProvider.clusterApplDetails[0].longitude ??
                  "${currentPos.longitude}";
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
          /* officerApprovalController.text = (clusterwiseApplDetailsProvider
                          .clusterApplDetails[0].officersComments ??
                      [])
                  .isNotEmpty
              ? (clusterwiseApplDetailsProvider.clusterApplDetails[0]
                      .officersComments?[0].aPPROVALFLAG ??
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
              : "";
 */
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
