import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/search_applicant.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/view_model/plots_layouts/cluster_list_count_view_model.dart';
import 'package:lrsofficer/view_model/search_view_model.dart';
import 'package:provider/provider.dart';

class SurveyNoWiseClustersList extends StatefulWidget {
  const SurveyNoWiseClustersList({super.key});

  @override
  State<SurveyNoWiseClustersList> createState() =>
      _SurveyNoWiseClustersListState();
}

class _SurveyNoWiseClustersListState extends State<SurveyNoWiseClustersList> {
  @override
  Widget build(BuildContext context) {
    final clusterListCountProvider =
        Provider.of<SurveyNumberWiseClustersListViewModel>(context);
    final searchProvider = Provider.of<SearchViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Survey number wise clusters",
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
                  child: Column(
                    children: [
                      const SearchApplicant(),
                      Expanded(
                        child: clusterListCountProvider
                                .clusterListCountApplications.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final data = clusterListCountProvider
                                      .clusterListCountApplications[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          AppRoutes.clusterwiseApplicationList,
                                          arguments: data.cLUSTERID);
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          buildVillageCard(
                                            data.vILLAGEID ?? "",
                                            data.cLUSTERID ?? "",
                                            // data.aPPLICATIONID ?? "",
                                            data.vILLAGENAME ?? "",
                                            data.sURVEYNUMBER ?? "",
                                            data.aPPCOUNT ?? "",
                                            data.pLOTEXTENT ?? "",
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: clusterListCountProvider
                                    .clusterListCountApplications.length,
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (clusterListCountProvider.getLoaderVisibilityStatus ||
            searchProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
      ],
    );
  }

  Widget buildVillageCard(
      String villageID,
      String clusterID,
      // String applicationID,
      String villageName,
      String surveyNo,
      String appCount,
      String plotExtent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // buildLabelValueRow("Village ID", villageID),
          buildLabelValueRow("Cluster ID", clusterID),
          // buildLabelValueRow("Application ID", applicationID),
          buildLabelValueRow("Village Name", villageName),
          buildLabelValueRow("Survey No", surveyNo),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildLabelValueRow("No of Applications", appCount),
                    buildLabelValueRow("Total Extent", plotExtent),
                  ],
                ),
              ),
              if (AppConstants.userType.toLowerCase() != "tp")
                ReusableButton(
                  buttonText: "Bulk Update",
                  padding: EdgeInsets.all(0.0),
                  width: MediaQuery.of(context).size.width * 0.3,
                  onPressed: () {
                    AppConstants.isBulkUpdate = "y";
                    AppConstants.clusterId = clusterID;
                    if (!kReleaseMode) {
                      debugPrint(
                          "ClusterId:: ${AppConstants.clusterId} && isBulkUpdate:: ${AppConstants.isBulkUpdate}");
                    }
                    Navigator.pushNamed(context, AppRoutes.checkDetails);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLabelValueRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, // Fixed width for the label
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
    AppConstants.isBulkUpdate = "";
    AppConstants.clusterId = "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final clusterListCountProvider =
          Provider.of<SurveyNumberWiseClustersListViewModel>(context,
              listen: false);
      String villageID = ModalRoute.of(context)?.settings.arguments as String;
      await clusterListCountProvider.getClusterListCount(context, villageID);
    });
  }
}
