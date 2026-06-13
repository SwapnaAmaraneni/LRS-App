import 'package:flutter/material.dart';
import '../res/CustomAlerts/validation_ios_alert.dart';
import '../routes/app_routes.dart';

class ResetPasswordViewModel with ChangeNotifier {
  void resetPassword(String mobile, BuildContext context) {
    if (validateInputs(mobile, context)) {
      //Send OTP code
      Navigator.pushNamed(context, AppRoutes.otp);
    }
  }

  bool validateInputs(String mobile, context) {
    if (mobile.isEmpty) {
      ValidationIoSAlert().showAlert(
        context,
        description: "Please Enter user ID and try again",
      );
      return false;
    } /* else if (mobile.length < 10) {
      ValidationIoSAlert().showAlert(
        context,
        description: "Please Enter Valid Mobile Number",
      );
      return false;
    } */
    else {
      return true;
    }
  }

  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;
  void setLoaderVisibleStatus(bool isLoaderVisible) {
    _isLoaderVisible = isLoaderVisible;
    notifyListeners();
  }
}
