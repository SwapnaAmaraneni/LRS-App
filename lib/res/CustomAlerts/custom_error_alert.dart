import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';

class ErrorCustomCupertinoAlert {
  void showAlert(BuildContext context,
      {required String message, void Function()? onPressed}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                const Icon(
                  CupertinoIcons.xmark_circle,
                  size: 60.0,
                  color: Colors.red,
                ),
                const SizedBox(height: 8.0),
                Text(
                  "${"appName".tr()}\nV${AppConstants.appVersion}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: onPressed ??
                    () {
                      Navigator.pop(context);
                    },
                child: Text(
                  "ok".tr(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
