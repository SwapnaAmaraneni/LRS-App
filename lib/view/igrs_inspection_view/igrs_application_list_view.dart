import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/igrs/igrs_application_response_model.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/search_bar.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_applications_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IGRSApplicationListView extends StatefulWidget {
  const IGRSApplicationListView({super.key});

  @override
  State<IGRSApplicationListView> createState() =>
      _IGRSApplicationListViewState();
}

class _IGRSApplicationListViewState extends State<IGRSApplicationListView> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IGRSApplicationsListViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          provider.resetApplications();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
                title: "IGRS Applications",
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.dashboard);
                      provider.resetApplications();
                    },
                    icon: const Icon(Icons.arrow_back))),
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.appBg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          SearchField(
                              hintText:
                                  "Search by Application Id, Applicant Name, Mobile No",
                              controller: provider.searchQueryController,
                              onChanged: (value) {
                                provider.runFilter(searchedVal: value);
                              },
                              onClear: () {
                                provider.resetApplications();
                              }),
                          // provider.buildSearchField(),
                          (provider.searchedApplicationList ?? []).isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      final data = provider
                                          .searchedApplicationList?[index];
                                      return GestureDetector(
                                         onTap: () async {
                                           LocalStoreHelper sharedpref =
                                               LocalStoreHelper();
                                            String existingAppNo = (await sharedpref.readTheData(
                                                SharedPrefConstants.applicationNo) ?? "").toString();
                                           String selectedAppNo = "${data?.aPPLICATIONID}";

                                           if (existingAppNo.isNotEmpty && existingAppNo != selectedAppNo) {
                                             if (!context.mounted) return;
                                             WarningCustomCupertinoAlertTwoButtons().showAlert(
                                               context,
                                               message: "There is unsaved data for Application ID: $existingAppNo. Do you want to discard it and continue with $selectedAppNo?",
                                               onPressedOk: () async {
                                                 Navigator.pop(context);
                                                 await clearUnsavedData();
                                                 await sharedpref.writeData(
                                                     SharedPrefConstants.applicationNo,
                                                     selectedAppNo);
                                                 if (!context.mounted) return;
                                                 Navigator.pushNamed(
                                                   context,
                                                   AppRoutes.igrsAppDetails,
                                                 );
                                                 provider.resetApplications();
                                               },
                                               onPressedCancel: () {
                                                 Navigator.pop(context);
                                               },
                                             );
                                           } else {
                                             await sharedpref.writeData(
                                                 SharedPrefConstants.applicationNo,
                                                 selectedAppNo);

                                             if (!context.mounted) return;
                                             Navigator.pushNamed(
                                               context,
                                               AppRoutes.igrsAppDetails,
                                             );
                                             provider.resetApplications();
                                           }
                                         },
                                        child: buildIGRSCard(
                                            data?.aPPLICANTNAME ?? "",
                                            data?.aPPLICATIONID ?? "",
                                            data?.vILLAGENAME ?? "",
                                            data?.sURVEYNUMBER ?? "",
                                            // data?. ?? "",
                                            data?.mOBILENO ?? "",
                                            data),
                                      );
                                    },
                                    itemCount:
                                        (provider.searchedApplicationList ?? [])
                                            .length,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "No Results Found",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          if (provider.getLoaderVisibilityStatus) const LoaderComponent()
        ],
      ),
    );
  }

  Widget buildIGRSCard(
    String applicantName,
    String applicationID,
    String villageName,
    String surveyNo,
    // String plotExtent,
    String mobileNumber,
    IGRSApplicationList? data,
  ) {
    return Card(
      elevation: 4.0, // Adds a shadow effect to the card
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabelValueRow("Applicant Name", applicantName),
                  buildLabelValueRow("Application ID", applicationID),
                  buildLabelValueRow("Mobile Number", mobileNumber),
                  buildLabelValueRow("Village Name", villageName),
                  buildLabelValueRow("Survey Number", surveyNo),
                  // buildLabelValueRow("Plot Extent", plotExtent),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      _buildTableRow("Total Amount", "Rebate Amount",
                          "Amount paid", false),
                      _buildTableRow("${data?.tOTALREGCHARGES}",
                          "${data?.rEBATEAMTCAL}", "${data?.fEEPAID}", true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String col1, String col2, String col3, bool isValue) {
    return TableRow(
      children: [
        _buildTableCell(col1, isValue),
        _buildTableCell(col2, isValue),
        _buildTableCell(col3, isValue),
      ],
    );
  }

  Widget _buildTableCell(String text, bool isValue) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: isValue
            ? TextStyle(fontSize: 18, color: Colors.blue)
            : TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildLabelValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 2.0), // Provides spacing between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width to ensure consistent alignment
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value, // Default value if null
              softWrap: true, // Allows text to wrap
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
      final provider =
          Provider.of<IGRSApplicationsListViewModel>(context, listen: false);
      await provider.getIGRSApplications(
        context,
      );
    });
  }

  Future<void> clearUnsavedData() async {
    final localStore = LocalStoreHelper();
    await localStore.removeData(SharedPrefConstants.applicationNo);
    await localStore.removeData(SharedPrefConstants.layoutNameKey);
    await localStore.removeData(SharedPrefConstants.plotNoKey);
    await localStore.removeData(SharedPrefConstants.areaExtentKey);
    await localStore.removeData(SharedPrefConstants.plotAreaExtentKey);
    await localStore.removeData(SharedPrefConstants.roadAreaExtentKey);
    await localStore.removeData(SharedPrefConstants.masterplanZdpKey);
    await localStore.removeData(SharedPrefConstants.latitudeKey);
    await localStore.removeData(SharedPrefConstants.longitudeKey);

    await localStore.removeData(SharedPrefConstants.layoutSelectedDocKey);
    await localStore.removeData(SharedPrefConstants.ownershipSelectedDocKey);
    await localStore.removeData(SharedPrefConstants.ecSelectedDocKey);
    await localStore.removeData(SharedPrefConstants.plot1Img);
    await localStore.removeData(SharedPrefConstants.plot2Img);
    await localStore.removeData(SharedPrefConstants.plot3Img);
    await localStore.removeData(SharedPrefConstants.plot4ImgMasterPlanExt);
    await localStore.removeData(SharedPrefConstants.plot5ImgCaptureLocScreenshot);
    await localStore.removeData(SharedPrefConstants.layoutDocumentradioVal);
    await localStore.removeData(SharedPrefConstants.ownershipDocumetRadioVal);
    await localStore.removeData(SharedPrefConstants.ecDocumentRadioVal);
    await localStore.removeData(SharedPrefConstants.gisCoordinatesList);

    await localStore.removeData(SharedPrefConstants.checkListKey);
    await localStore.removeData(SharedPrefConstants.questionsChecklist);

    await localStore.removeData(SharedPrefConstants.srdpRdpKey);
    await localStore.removeData(SharedPrefConstants.conversionChargesKey);
    await localStore.removeData(SharedPrefConstants.mvRate2020Key);
    await localStore.removeData(SharedPrefConstants.mvRateDocumentKey);
    await localStore.removeData(SharedPrefConstants.rcKey);
    await localStore.removeData(SharedPrefConstants.vltKey);
    await localStore.removeData(SharedPrefConstants.plotOpenspaceKey);
    await localStore.removeData(SharedPrefConstants.trcKey);
    await localStore.removeData(SharedPrefConstants.mvEditFlagKey);
    await localStore.removeData(SharedPrefConstants.isCalculate);
    await localStore.removeData(SharedPrefConstants.marketValueFlag);
    await localStore.removeData(SharedPrefConstants.editedMv);
    await localStore.removeData(SharedPrefConstants.editedMvDateOfRegstn);
    await localStore.removeData(SharedPrefConstants.editedPlotAreaExtent);
    await localStore.removeData(SharedPrefConstants.editedRoadAffectedArea);
    await localStore.removeData(SharedPrefConstants.editedNetPlotArea);

    await localStore.removeData(SharedPrefConstants.additionalConditionKey);
    await localStore.removeData(SharedPrefConstants.notesKey);
    await localStore.removeData(SharedPrefConstants.conditionKey);
    await localStore.removeData(SharedPrefConstants.recommendationsKey);

    await localStore.removeData(SharedPrefConstants.totalNoOfPlotsKey);
    await localStore.removeData(SharedPrefConstants.selectedUnsoldPlotKey);
    await localStore.removeData(SharedPrefConstants.soldPlotsKey);
    await localStore.removeData(SharedPrefConstants.unsoldPlotsKey);
    await localStore.removeData(SharedPrefConstants.totalunsoldPlotAreakey);
    await localStore.removeData(SharedPrefConstants.unsoldPlotListKey);
    await localStore.removeData(SharedPrefConstants.totalAreaExtent);
  }
}
