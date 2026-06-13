import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import '../../routes/app_routes.dart';
import '../constants/app_colors.dart';

class LogoutAppAlert {
  void showAlert({required BuildContext context}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                Icon(
                  CupertinoIcons.info,
                  size: 60.0,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: 8.0),
                Text(
                  "${"appName".tr()}\nV${AppConstants.appVersion}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text("logoutApplicationMsg".tr()),
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
                  await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
