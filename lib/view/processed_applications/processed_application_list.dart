import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view_model/processed_applications_view_model/processed_application_list_view_model.dart';
import 'package:provider/provider.dart';

class ProcessedApplicationList extends StatefulWidget {
  const ProcessedApplicationList({super.key});

  @override
  State<ProcessedApplicationList> createState() =>
      _ProcessedApplicationListState();
}

class _ProcessedApplicationListState extends State<ProcessedApplicationList> {
  @override
  Widget build(BuildContext context) {
    final processedApplListProvider =
        Provider.of<ProcessedApplicationListViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Processed Applications",
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
                  child: processedApplListProvider
                          .processedAppliListResponse.isNotEmpty
                      ? Column(
                          children: [
                            processedApplListProvider.buildSearchField(),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final data = processedApplListProvider
                                          .getSearchProcessedAppliListResponse[
                                      index];
                                  return GestureDetector(
                                    child: buildVillageCard(
                                        data.aPPLICATIONID ?? "",
                                        data.pROCESSED ?? "",
                                        data.iSLAYOUTPLOT ?? ""),
                                  );
                                },
                                itemCount: processedApplListProvider
                                    .getSearchProcessedAppliListResponse.length,
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
        if (processedApplListProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
      ],
    );
  }

  Widget buildVillageCard(
      String applicationID, String processed, String isLayoutPlot) {
    return Card(
      elevation: 4.0, // Adds a shadow effect to the card
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabelValueRow("Applicant ID", applicationID),
            buildLabelValueRow("Application Status", processed),
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
              style: TextStyle(
                  color: value.toLowerCase() == "approved"
                      ? Colors.green
                      : value.toLowerCase() == "rejected"
                          ? Colors.red
                          : value.toLowerCase() == "shortfall"
                              ? Colors.amber
                              : Colors.black),
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
      final processedApplListProvider =
          Provider.of<ProcessedApplicationListViewModel>(context,
              listen: false);
      processedApplListProvider.searchQueryController.clear();
      await processedApplListProvider.getProcessedApplicationListCount(
        context,
      );
    });
  }
}
