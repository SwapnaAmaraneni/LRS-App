import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';

class SuccessCustomCupertinoAlert {
  void showAlert(
      {required BuildContext context,
      required String title,
      void Function()? onPressed}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                const Icon(
                  CupertinoIcons.checkmark_alt_circle,
                  size: 60.0,
                  color: Colors.green,
                ),
                const SizedBox(height: 8.0),
                Text(
                  "${"appName".tr()}\nV${AppConstants.appVersion}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(title),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: onPressed ??
                    () {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.dashboard);
                    },
                child: Text(
                  "ok".tr(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
