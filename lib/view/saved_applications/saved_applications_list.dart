import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/application_status_widget.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/saved_applications_list_view_model.dart';
import 'package:lrsofficer/view_model/search_view_model.dart';
import 'package:provider/provider.dart';

class SavedApplicationsList extends StatefulWidget {
  const SavedApplicationsList({super.key});

  @override
  State<SavedApplicationsList> createState() => _SavedApplicationsListState();
}

class _SavedApplicationsListState extends State<SavedApplicationsList> {
  @override
  Widget build(BuildContext context) {
    final savedApplicationListProvider =
        Provider.of<SavedApplicationsListViewModel>(context);
    final searchProvider = Provider.of<SearchViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Saved Applications List",
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
                  child: savedApplicationListProvider
                          .getSavedApplicationsList.isNotEmpty
                      ? Column(
                          children: [
                            savedApplicationListProvider.buildSearchField(),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final data = savedApplicationListProvider
                                      .getSearchedApplicationsList[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      LocalStoreHelper sharedpref =
                                          LocalStoreHelper();
                                      await sharedpref.writeData(
                                          SharedPrefConstants.applicationNo,
                                          "${data.aPPLICATIONID}");
                                      if (!context.mounted) return;
                                      Navigator.pushNamed(context,
                                          AppRoutes.savedApplicationDetails);
                                    },
                                    child: buildVillageCard(
                                      data.applicantName ?? "",
                                      data.cLUSTERID ?? "",
                                      data.aPPLICATIONID ?? "",
                                      data.vILLAGENAME ?? "",
                                      data.sURVEYNUMBER ?? "",
                                      data.pLOTEXTENT ?? "",
                                      data.tpFlag ?? "",
                                      data.irFlag ?? "",
                                      data.reFlag ?? "",
                                      data.prohibitedFlag ?? "",
                                      data.mobileNumber,
                                    ),
                                  );
                                },
                                itemCount: savedApplicationListProvider
                                    .getSearchedApplicationsList.length,
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
        if (savedApplicationListProvider.getLoaderVisibilityStatus ||
            searchProvider.getLoaderVisibilityStatus)
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
      String tpFlag,
      String irFlag,
      String reFlag,
      String? prohibitedFlag,
      String? mobileNumber) {
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
                  /* Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ApplicationStatusWidget(
                        tpFlag: tpFlag,
                        irFlag: irFlag,
                        reFlag: reFlag,
                        prohibitedFlag: prohibitedFlag),
                  ), */
                ],
              ),
            ),
            ApplicationStatusWidget(
              tpFlag: tpFlag,
              irFlag: irFlag,
              reFlag: reFlag,
              prohibitedFlag: prohibitedFlag,
            ),
          ],
        ),
      ),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final savedApplicationListProvider =
          Provider.of<SavedApplicationsListViewModel>(context, listen: false);
      savedApplicationListProvider.searchQueryController.clear();
      await savedApplicationListProvider.getSavedApplicationListApi(context);
    });
  }
}
