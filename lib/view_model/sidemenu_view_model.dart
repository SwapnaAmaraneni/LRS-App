import 'package:lrsofficer/res/CustomAlerts/delete_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/logout_alert.dart';
import 'package:flutter/material.dart';
import '../res/CustomAlerts/exit_app_alert.dart';
import '../routes/app_routes.dart';

class SideMenuViewModel with ChangeNotifier {
  Future<void> navigationTo(BuildContext context, subtitle) async {
    if (subtitle == 'Home') {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (subtitle == 'Search any application') {
      Navigator.pop(context);
      Navigator.pushNamed(context, AppRoutes.globalSearch);
    } else if (subtitle == 'Privacy Policy') {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.privacypolicy,
      );
    } else if (subtitle == 'App Info') {
      Navigator.pop(context);
      Navigator.pushNamed(context, AppRoutes.appInfo);
    } else if (subtitle == 'Exit application') {
      Navigator.pop(context);
      ExitAppAlert().showAlert(context: context);
    } else if (subtitle == 'Logout') {
      Navigator.pop(context);
      LogoutAppAlert().showAlert(context: context);
    } else if (subtitle == 'Delete Account') {
      Navigator.pop(context);
      DeleteAccountAlert().showAlert(context: context);
    }
  }

  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;
  void setLoaderVisibleStatus(bool isLoaderVisible) {
    _isLoaderVisible = isLoaderVisible;
    notifyListeners();
  }
}
