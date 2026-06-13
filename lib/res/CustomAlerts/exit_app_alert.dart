import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import '../constants/app_colors.dart';

class ExitAppAlert {
  void showAlert({required BuildContext context}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                const Icon(
                  CupertinoIcons.info,
                  size: 60.0,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: 8.0),
                Text(
                  "${"appName".tr()}\nV${AppConstants.appVersion}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "exitApp".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text("exitApplication".tr()),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  "no".tr(),
                  style: const TextStyle(color: AppColors.primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Closes the dialog
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  "yes".tr(),
                  style: const TextStyle(color: AppColors.primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Closes the dialog
                  if (Platform.isIOS) {
                    exit(0);
                  } else {
                    SystemNavigator.pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
