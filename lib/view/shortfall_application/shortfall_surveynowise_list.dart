import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_search_applicant.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_search_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_surveynowise_list_view_model.dart';
import 'package:provider/provider.dart';

class ShortfallSurveyNowiseList extends StatefulWidget {
  const ShortfallSurveyNowiseList({super.key});

  @override
  State<ShortfallSurveyNowiseList> createState() =>
      _ShortfallSurveyNowiseListState();
}

class _ShortfallSurveyNowiseListState extends State<ShortfallSurveyNowiseList> {
  @override
  Widget build(BuildContext context) {
    final shortfallSurveyNowiseListProvider =
        Provider.of<ShortfallSurveyNowiseListViewModel>(context);
    final searchProvider = Provider.of<ShortfallSearchViewModel>(context);
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
                      const ShortfallSearchApplicant(),
                      Expanded(
                        child: shortfallSurveyNowiseListProvider
                                .clusterListCountApplications.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final data = shortfallSurveyNowiseListProvider
                                      .clusterListCountApplications[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          AppRoutes.shortfallClusterwiseList,
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
                                itemCount: shortfallSurveyNowiseListProvider
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
        if (shortfallSurveyNowiseListProvider.getLoaderVisibilityStatus ||
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
      final shortfallSurveyNowiseListProvider =
          Provider.of<ShortfallSurveyNowiseListViewModel>(context,
              listen: false);
      String villageID = ModalRoute.of(context)?.settings.arguments as String;
      await shortfallSurveyNowiseListProvider.getClusterListCount(
          context, villageID);
    });
  }
}
