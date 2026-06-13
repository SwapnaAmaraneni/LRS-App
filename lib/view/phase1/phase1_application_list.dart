import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/application_status_widget.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_application_list_view_model.dart';
import 'package:provider/provider.dart';

class Phase1ApplicationList extends StatefulWidget {
  const Phase1ApplicationList({super.key});

  @override
  State<Phase1ApplicationList> createState() => _Phase1ApplicationListState();
}

class _Phase1ApplicationListState extends State<Phase1ApplicationList> {
  @override
  Widget build(BuildContext context) {
    final phase1ApplListProvider =
        Provider.of<Phase1ApplicationListViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: AppConstants.isLayoutPlot == "L"
                ? "Phase-1 Layout Applications"
                : "Phase-1 Plot Applications",
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
                  child: phase1ApplListProvider
                          .clusterwiseAppliListResponse.isNotEmpty
                      ? Column(
                          children: [
                            // Phase1SearchApplicant(),
                            phase1ApplListProvider.buildSearchField(),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final data = phase1ApplListProvider
                                      .getSearchedList[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      LocalStoreHelper sharedpref =
                                          LocalStoreHelper();
                                      await sharedpref.writeData(
                                          SharedPrefConstants.applicationNo,
                                          "${data.aPPLICATIONID}");
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
                                                .phase1LayoutApplicationDetails,
                                          );
                                        } else {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes
                                                .phase1TpApplicationDetails,
                                          );
                                        }
                                      } else {
                                        Navigator.pushNamed(
                                            context,
                                            AppRoutes
                                                .phase1IrReApplicationDetails);
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
                                itemCount: phase1ApplListProvider
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
        if (phase1ApplListProvider.getLoaderVisibilityStatus)
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
      final phase1ApplListProvider =
          Provider.of<Phase1ApplicationListViewModel>(context, listen: false);
      phase1ApplListProvider.searchQueryController.clear();
      await phase1ApplListProvider.getClusterwiseApplicationListCount(
        context,
      );
    });
  }
}
