import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/models/plots_layouts/villagewise_applications_count_response.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/search_applicant.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view_model/plots_layouts/villagewise_applications_list_view_model.dart';
import 'package:lrsofficer/view_model/search_view_model.dart';
import 'package:provider/provider.dart';

class VillageWiseSurveyNumbersList extends StatefulWidget {
  const VillageWiseSurveyNumbersList({super.key});

  @override
  State<VillageWiseSurveyNumbersList> createState() =>
      _VillageWiseSurveyNumbersListState();
}

class _VillageWiseSurveyNumbersListState
    extends State<VillageWiseSurveyNumbersList> {
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<VillageWiseSurveyNumbersListViewModel>(context);
    final searchProvider = Provider.of<SearchViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Village wise Survey Numbers",
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
                        child: provider.applications.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  VillageWiseSurveyNumbers applicationsData =
                                      provider.applications[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          AppRoutes.surveyNoWiseClustersList,
                                          arguments:
                                              applicationsData.vILLAGEID);
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          buildLabelValueRow(
                                            "villageName".tr(),
                                            applicationsData.vILLAGENAME,
                                          ),
                                          buildLabelValueRow(
                                            "No of survey numbers",
                                            applicationsData.sURVEYNUMBER,
                                          ),
                                          buildLabelValueRow(
                                            "No of Applications",
                                            applicationsData.aPPCOUNT,
                                          ),
                                          buildLabelValueRow(
                                            "Total Extent",
                                            applicationsData.pLOTEXTENT,
                                          ),

                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          // buildBadgeRow(
                                          //   applicationsData.vILLAGENAME ?? "",
                                          //   applicationsData.sURVEYNUMBER ?? "",
                                          //   applicationsData.aPPCOUNT ?? "",
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: provider.applications.length,
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (provider.getLoaderVisibilityStatus ||
            searchProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
      ],
    );
  }

  Widget buildLabelValueRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 160, // Fixed width for the label
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

  Widget buildBadgeRow(
      String villageName, String surveyNumber, String appCount) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 10.0, right: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  villageName,
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  surveyNumber,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: AppColors.appBarColor,
                  ),
                ),
              ],
            ),
          ),
          // Container for the round badge
          Container(
            width: 55,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.appBarColor, width: 1),
              shape: BoxShape.circle,
            ),
            child: Text(
              appCount,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
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
      final provider = Provider.of<VillageWiseSurveyNumbersListViewModel>(
          context,
          listen: false);
      await provider.getVillagewiseApplicationsCount(context);
    });
  }
}
