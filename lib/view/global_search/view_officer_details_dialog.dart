import 'package:flutter/material.dart';
import 'package:lrsofficer/models/global_search/global_search_officer_details_response.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';

class OfficerDetailsDialog {
  static void show(BuildContext context, List<OfficersList>? officers) {
    final isEmpty = officers == null || officers.isEmpty;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SafeArea(
            top: false,
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  const Text(
                    "Officer Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // =======================
                  // EMPTY MESSAGE HANDLING
                  // =======================
                  if (isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Center(
                        child: Text(
                          "No officer details found",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            border: TableBorder.all(color: Colors.grey),
                            headingRowColor:
                                WidgetStateProperty.all(AppColors.appBarColor),
                            columns: const [
                              DataColumn(
                                  label: Text("SNo",
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text("User Id",
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text("Officer Name",
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text("Authority",
                                      style: TextStyle(color: Colors.white))),
                            ],
                            rows: List.generate(officers.length, (index) {
                              final officer = officers[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(Text(officer.uSERID ?? "")),
                                  DataCell(Text(officer.uSERNAME ?? "")),
                                  DataCell(Text(officer.aUTHTYPE ?? "")),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  // Close Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
