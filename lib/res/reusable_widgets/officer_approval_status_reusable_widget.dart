import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';

class OfficerApprovalStatusReusableWidget extends StatelessWidget {
  const OfficerApprovalStatusReusableWidget(
      {super.key,
      required this.officerApprovalStatus,
      required this.officerIds,
      required this.officerRemarks});
  final List<TextEditingController> officerApprovalStatus;
  final List<TextEditingController> officerIds;
  final List<TextEditingController> officerRemarks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getTitleCard(
          "Other Officers Approval Status",
          context,
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (officerApprovalStatus).length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    buildLabelValueRow("Officer ID", officerIds[index].text),
                    buildLabelValueRow(
                        "Approval Status", officerApprovalStatus[index].text),
                    buildLabelValueRow("Remarks", officerRemarks[index].text),
                    if (index != officerApprovalStatus.length - 1) Divider(),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

Widget getTitleCard(String title, BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.95,
    child: Card(
      elevation: 4.0,
      color: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ),
  );
}

Widget buildLabelValueRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
