import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import '../constants/app_colors.dart';

class WarningCustomCupertinoAlertTwoButtons {
  void showAlert(BuildContext context,
      {required String message,
      required void Function()? onPressedOk,
      required void Function()? onPressedCancel}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 60.0,
                  color: AppColors.warningColor,
                ),
                const SizedBox(height: 8.0),
                Text(
                  "${"appName".tr()}\n V${AppConstants.appVersion}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: onPressedCancel,
                child: Text(
                  "cancel".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.primaryColor, fontSize: 16),
                ),
              ),
              CupertinoDialogAction(
                onPressed: onPressedOk,
                child: Text(
                  "yes".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.primaryColor, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
