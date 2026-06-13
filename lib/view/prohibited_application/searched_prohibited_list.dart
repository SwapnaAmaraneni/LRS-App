import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_search_view_model.dart';
import 'package:provider/provider.dart';

class SearchProhibitedApplicationList extends StatefulWidget {
  const SearchProhibitedApplicationList({super.key});

  @override
  State<SearchProhibitedApplicationList> createState() =>
      _SearchProhibitedApplicationListState();
}

class _SearchProhibitedApplicationListState
    extends State<SearchProhibitedApplicationList> {
  @override
  Widget build(BuildContext context) {
    final searchApplListProvider =
        Provider.of<ProhibitedSearchViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Prohibited Applications",
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
                  child: searchApplListProvider.searchApplicationList.isNotEmpty
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            final data = searchApplListProvider
                                .searchApplicationList[index];
                            return GestureDetector(
                              onTap: () async {
                                LocalStoreHelper sharedpref =
                                    LocalStoreHelper();
                                await sharedpref.writeData(
                                    SharedPrefConstants.applicationNo,
                                    "${data.aPPLICATIONID}");
                                final userType = await LocalStoreHelper()
                                    .readTheData(SharedPrefConstants.userType);
                                if (!context.mounted) return;
                                if (userType.toString().toLowerCase() == "tp") {
                                  if (AppConstants.isLayoutPlot == "L") {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes
                                          .layoutClusterApplicationsDetails,
                                    );
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.clusterApplicationDetails,
                                    );
                                  }
                                } else {
                                  Navigator.pushNamed(context,
                                      AppRoutes.revenueApplicationDetails);
                                }
                              },
                              child: buildVillageCard(
                                data.applicantName ?? "",
                                data.cLUSTERID ?? "",
                                data.aPPLICATIONID ?? "",
                                data.vILLAGENAME ?? "",
                                data.sURVEYNUMBER ?? "",
                                data.pLOTEXTENT ?? "",
                              ),
                            );
                          },
                          itemCount: searchApplListProvider
                              .searchApplicationList.length,
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
        if (searchApplListProvider.getLoaderVisibilityStatus)
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
      String plotExtent) {
    return Card(
      elevation: 4.0, // Adds a shadow effect to the card
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabelValueRow("Applicant Name", applicantName),
            buildLabelValueRow("Application ID", applicationID),
            buildLabelValueRow("Cluster ID", clusterID),
            buildLabelValueRow("Village Name", villageName),
            buildLabelValueRow("Survey Number", surveyNo),
            buildLabelValueRow("Plot Extent", plotExtent),
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
}
