import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import '../constants/app_colors.dart';

class ValidationIoSAlert {
  void showAlert(BuildContext context, {required String? description}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                const Icon(
                  CupertinoIcons.info_circle,
                  size: 60.0,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 8.0),
                Text(
                  "${"appName".tr()}\nV${AppConstants.appVersion}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              children: [
                const SizedBox(height: 8.0),
                Text(
                  "$description",
                  style: const TextStyle(fontSize: 12, color: AppColors.black),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  "ok".tr(),
                  style: const TextStyle(color: AppColors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
