import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';

class ApplicationStatusWidget extends StatelessWidget {
  const ApplicationStatusWidget(
      {super.key,
      required this.tpFlag,
      required this.irFlag,
      required this.reFlag,
      this.prohibitedFlag});
  final String tpFlag;
  final String irFlag;
  final String reFlag;
  final String? prohibitedFlag;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: AppConstants.userType != "tp",
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: CircleAvatar(
              backgroundColor:
                  (tpFlag).toLowerCase() == "y" ? Colors.green : Colors.grey,
              radius: 10,
              child: const Text(
                'TP',
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        Visibility(
          visible: AppConstants.userType != "ir",
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 2),
            ),
            child: CircleAvatar(
              backgroundColor:
                  (irFlag).toLowerCase() == "y" ? Colors.green : Colors.grey,
              radius: 10,
              child: const Text(
                'IR',
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        Visibility(
          visible: AppConstants.userType != "re",
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: CircleAvatar(
              backgroundColor:
                  (reFlag).toLowerCase() == "y" ? Colors.green : Colors.grey,
              radius: 10,
              child: const Text(
                'RE',
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        Visibility(
          visible: prohibitedFlag != null &&
              (prohibitedFlag ?? "").toLowerCase() == "y",
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: CircleAvatar(
              backgroundColor: (prohibitedFlag ?? "").toLowerCase() == "y"
                  ? Colors.red
                  : Colors.grey,
              radius: 10,
              child: const Text(
                'P',
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
