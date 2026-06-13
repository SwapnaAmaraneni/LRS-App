import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';
import '../constants/app_colors.dart';

class DeleteAccountAlert {
  void showAlert({required BuildContext context}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: const Column(
              children: <Widget>[
                Icon(
                  CupertinoIcons.info,
                  size: 60.0,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Delete Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text("deleteAccountmsg".tr()),
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
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (!context.mounted) return;
                  SuccessCustomCupertinoAlert().showAlert(
                    context: context,
                    title: "Account Deleted Successfully\n",
                    onPressed: () async {
                      await LocalStoreHelper()
                          .removeData(SharedPrefConstants.mpin);
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
