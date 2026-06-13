import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/igrs/igrs_application_response_model.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/search_bar.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_applications_list_view_model.dart';
import 'package:provider/provider.dart';

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
                                          await sharedpref.writeData(
                                              SharedPrefConstants.applicationNo,
                                              "${data?.aPPLICATIONID}");

                                          if (!context.mounted) return;
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.igrsAppDetails,
                                          );
                                          provider.resetApplications();
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
}
