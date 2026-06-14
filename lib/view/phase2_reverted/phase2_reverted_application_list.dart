import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/application_status_widget.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_application_list_view_model.dart';
import 'package:provider/provider.dart';

class Phase2RevertedApplicationList extends StatefulWidget {
  const Phase2RevertedApplicationList({super.key});

  @override
  State<Phase2RevertedApplicationList> createState() =>
      _Phase2RevertedApplicationListState();
}

class _Phase2RevertedApplicationListState
    extends State<Phase2RevertedApplicationList> {
  @override
  Widget build(BuildContext context) {
    final phase2RevertedApplListProvider =
        Provider.of<Phase2RevertedApplicationListViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: AppConstants.isLayoutPlot == "L"
                ? "Phase-2 Reverted Layout Applications"
                : "Phase-2 Reverted Plot Applications",
          ),
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
                  child: phase2RevertedApplListProvider
                          .clusterwiseAppliListResponse.isNotEmpty
                      ? Column(
                          children: [
                            // Phase2RevertedSearchApplicant(),
                            phase2RevertedApplListProvider.buildSearchField(),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final data = phase2RevertedApplListProvider
                                      .getSearchedList[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      LocalStoreHelper sharedpref =
                                          LocalStoreHelper();
                                      String existingAppNo = (await sharedpref.readTheData(
                                          SharedPrefConstants.applicationNo) ?? "").toString();
                                      String selectedAppNo = "${data.aPPLICATIONID}";

                                      Future<void> navigateToDetails() async {
                                        final userType = await LocalStoreHelper()
                                            .readTheData(
                                                SharedPrefConstants.userType);
                                        if (!context.mounted) return;
                                        if (userType.toString().toLowerCase() ==
                                            "tp") {
                                          if (AppConstants.isLayoutPlot == "L") {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes
                                                  .phase2RevertedLayoutApplicationDetails,
                                            );
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes
                                                  .phase2RevertedTpApplicationDetails,
                                            );
                                          }
                                        } else {
                                          Navigator.pushNamed(
                                              context,
                                              AppRoutes
                                                  .phase2RevertedIrReApplicationDetails);
                                        }
                                      }

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
                                            await navigateToDetails();
                                          },
                                          onPressedCancel: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      } else {
                                        await sharedpref.writeData(
                                            SharedPrefConstants.applicationNo,
                                            selectedAppNo);
                                        await navigateToDetails();
                                      }
                                    },
                                    child: buildVillageCard(
                                      data.applicantName ?? "",
                                      data.cLUSTERID ?? "",
                                      data.aPPLICATIONID ?? "",
                                      data.vILLAGENAME ?? "",
                                      data.sURVEYNUMBER ?? "",
                                      data.pLOTEXTENT ?? "",
                                      data.plotNo ?? "",
                                      data.tpFlag ?? "",
                                      data.irFlag ?? "",
                                      data.reFlag ?? "",
                                      data.mobileNumber ?? "",
                                    ),
                                  );
                                },
                                itemCount: phase2RevertedApplListProvider
                                    .getSearchedList.length,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
        if (phase2RevertedApplListProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
      ],
    );
  }

  Widget buildVillageCard(
    String applicantName,
    String clusterID,
    String applicationID,
    String villageName,
    String surveyNo,
    String plotExtent,
    String plotNo,
    String tpFlag,
    String irFlag,
    String reFlag,
    String mobileNumber,
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
                  buildLabelValueRow("Cluster ID", clusterID),
                  buildLabelValueRow("Village Name", villageName),
                  buildLabelValueRow("Survey Number", surveyNo),
                  buildLabelValueRow("Plot Extent", plotExtent),
                  buildLabelValueRow("Plot No", plotNo),
                ],
              ),
            ),
            ApplicationStatusWidget(
                tpFlag: tpFlag, irFlag: irFlag, reFlag: reFlag),
          ],
        ),
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
      final phase2RevertedApplListProvider =
          Provider.of<Phase2RevertedApplicationListViewModel>(context,
              listen: false);
      phase2RevertedApplListProvider.searchQueryController.clear();
      await phase2RevertedApplListProvider.getClusterwiseApplicationListCount(
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
