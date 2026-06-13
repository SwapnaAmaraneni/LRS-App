import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/models/new_flow/fifp_applications_list_response.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/search_bar.dart';
import 'package:lrsofficer/view_model/new_flow/fee_initimated_unpaid_view_model.dart';
import 'package:provider/provider.dart';

class FeeUnpaidListView extends StatefulWidget {
  const FeeUnpaidListView({super.key});

  @override
  State<FeeUnpaidListView> createState() => _FeeUnpaidListViewState();
}

class _FeeUnpaidListViewState extends State<FeeUnpaidListView> {
  final Map<String, TextEditingController> _remarksControllers = {};

  @override
  void dispose() {
    // Dispose of all controllers
    for (var controller in _remarksControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeeInitimatedUnpaidViewModel>(context);
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
              title: "Fee Intimated Not Paid Applications",
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.dashboard);
                    provider.resetApplications();
                  },
                  icon: const Icon(Icons.arrow_back)),
              actions: (provider.getApplicationList != null &&
                      provider.getApplicationList != [])
                  ? [
                      IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          provider.setLoaderVisibleStatus(true);
                          if (provider.getApplicationList != null &&
                              provider.getApplicationList != []) {
                           await provider.downloadPdf(context,
                                provider.getFeePaidAppResponse?.downloadUrl);
                          }
                          provider.setLoaderVisibleStatus(false);
                        },
                      ),
                    ]
                  : [],
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
                          (provider.searchedApplicationList ?? []).isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    final data = provider
                                        .searchedApplicationList?[index];
                                    _remarksControllers.putIfAbsent(
                                        index.toString(),
                                        () => TextEditingController());
                                    if ((data?.l1Remarks ?? "").isNotEmpty) {
                                      _remarksControllers[index.toString()] =
                                          TextEditingController(
                                              text: data?.l1Remarks ?? "");
                                    }
                                    return GestureDetector(
                                      onTap: () async {
                                        /*        LocalStoreHelper sharedpref =
                                        LocalStoreHelper();
                                    await sharedpref.writeData(
                                        SharedPrefConstants.applicationNo,
                                        "${data?.aPPLICATIONID}");
 
                                    if (!context.mounted) return;
 
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.fifpAppDetails,
                                    ); */
                                      },
                                      child: buildFeePaidCard(
                                        data?.lAYOUTOWNERNAME ?? "",
                                        data?.aPPLICATIONID ?? "",
                                        data?.vILLAGENAME ?? "",
                                        data?.sURVEYNUMBER ?? "",
                                        data?.pLOTEXTENT ?? "",
                                        data?.oWNERMOBILENUMBER ?? "",
                                        data,
                                        _remarksControllers[index.toString()],
                                        () async {
                                          String remarks = _remarksControllers[
                                                      index.toString()]
                                                  ?.text
                                                  .trim() ??
                                              "";
                                          if (remarks.isEmpty) {
                                            ErrorCustomCupertinoAlert()
                                                .showAlert(
                                              context,
                                              message: "Please enter Remarks",
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            );
                                          } else {
                                            await provider.getRemarksSubmitVM(
                                              context,
                                              remarks,
                                              data?.aPPLICATIONID ?? "",
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  itemCount:
                                      (provider.searchedApplicationList ?? [])
                                          .length,
                                ))
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

  Widget buildFeePaidCard(
    String applicantName,
    String applicationID,
    String villageName,
    String surveyNo,
    String plotExtent,
    String mobileNumber,
    FifpApplications? data,
    TextEditingController? remarksController,
    VoidCallback onTap,
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
                  buildLabelValueRow("Plot Extent", plotExtent),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      _buildTableRow("Total Amount", "Rebate Amount",
                          "Amount to be paid", false),
                      _buildTableRow(
                          "${data?.tOTLAMOUNT}",
                          "${data?.rEBATEAMOUNT}",
                          "${data?.tOBEPAIDAMOUNT}",
                          true),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Remarks TextField
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80, // Reduce width to minimize space
                        child: Align(
                          alignment:
                              Alignment.centerLeft, // Align text to the left
                          child: Text(
                            "Remarks:",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: remarksController,
                          maxLength: 300,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[A-Za-z0-9 .\/@()_,-]{0,300}'))
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter remarks",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10, // Reduced horizontal padding
                            ),
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Submit Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onTap,
                      child: Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider =
          Provider.of<FeeInitimatedUnpaidViewModel>(context, listen: false);
      await provider.getFeePaidApplications(
        context,
      );
    });
  }
}
