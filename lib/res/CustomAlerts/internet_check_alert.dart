import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import '../constants/app_colors.dart';

class InternetCheckAlert {
  void showAlert(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: Text(
              "${"appName".tr()}\nV${AppConstants.appVersion}",
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              children: [
                Text(
                  "noInternet".tr(),
                  style: const TextStyle(fontSize: 13, color: AppColors.black),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "internetRequest".tr(),
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
