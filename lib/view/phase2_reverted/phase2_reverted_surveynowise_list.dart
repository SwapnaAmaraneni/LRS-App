import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view/phase2_Reverted/phase2_Reverted_search_applicant.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_search_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_surveynowise_list_view_model.dart';
import 'package:provider/provider.dart';

class Phase2RevertedSurveyNowiseList extends StatefulWidget {
  const Phase2RevertedSurveyNowiseList({super.key});

  @override
  State<Phase2RevertedSurveyNowiseList> createState() =>
      _Phase2RevertedSurveyNowiseListState();
}

class _Phase2RevertedSurveyNowiseListState
    extends State<Phase2RevertedSurveyNowiseList> {
  @override
  Widget build(BuildContext context) {
    final phase2RevertedSurveyNowiseListProvider =
        Provider.of<Phase2RevertedSurveyNowiseListViewModel>(context);
    final searchProvider = Provider.of<Phase2RevertedSearchViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Phase-2 Reverted Survey number wise clusters",
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
                      const Phase2RevertedSearchApplicant(),
                      Expanded(
                        child: phase2RevertedSurveyNowiseListProvider
                                .clusterListCountApplications.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final data =
                                      phase2RevertedSurveyNowiseListProvider
                                          .clusterListCountApplications[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context,
                                          AppRoutes
                                              .phase2RevertedClusterWiseList,
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
                                itemCount:
                                    phase2RevertedSurveyNowiseListProvider
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
        if (phase2RevertedSurveyNowiseListProvider.getLoaderVisibilityStatus ||
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
          buildLabelValueRow("No of Applications", appCount),
          buildLabelValueRow("Total Extent", plotExtent),
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final phase2RevertedSurveyNowiseListProvider =
          Provider.of<Phase2RevertedSurveyNowiseListViewModel>(context,
              listen: false);
      String villageID = ModalRoute.of(context)?.settings.arguments as String;
      await phase2RevertedSurveyNowiseListProvider.getClusterListCount(
          context, villageID);
    });
  }
}
