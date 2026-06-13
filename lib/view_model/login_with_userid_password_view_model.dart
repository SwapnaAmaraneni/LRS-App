import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/login/login_response.dart';
import 'package:lrsofficer/repository/login_repository.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import '../models/login/login_payload.dart';
import '../res/CustomAlerts/custom_error_alert.dart';
import '../res/CustomAlerts/internet_check_alert.dart';
import '../res/CustomAlerts/validation_ios_alert.dart';
import '../routes/app_routes.dart';
import '../utils/internet.dart';
import '../utils/shared_pref_constants.dart';

class LoginWithMobileViewModel with ChangeNotifier {
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> userLogin(
      dynamic userId, dynamic password, BuildContext context) async {
    try {
      if (validateInputs(userId, context)) {
        if (checkPassword(password, context)) {
          final connection = await internetCheck();
          if (connection) {
            final loginPayload = OfficerLoginPayload(
              username: userId,
            );

            AppLogger().logDebug("loginPayload ${loginPayload.toJson()}");
            setLoaderVisibleStatus(true);
            if (!context.mounted) return;
            OfficerLoginResponse? loginResponse =
                await LoginRepository().loginApi(context, loginPayload);
            if (loginResponse != null) {
              if (loginResponse.statusCode == ApiErrorCodes.success) {
                setLoaderVisibleStatus(false);
                await LocalStoreHelper().writeData(SharedPrefConstants.userID,
                    loginResponse.loginDtls?.userID ?? "");
                await LocalStoreHelper().writeData(SharedPrefConstants.token,
                    loginResponse.loginDtls?.tokenID ?? "");
                await LocalStoreHelper().writeData(SharedPrefConstants.userName,
                    loginResponse.loginDtls?.username ?? "");
                await LocalStoreHelper().writeData(SharedPrefConstants.mobileNo,
                    loginResponse.loginDtls?.mOBILENO ?? "");
                await LocalStoreHelper().writeData(SharedPrefConstants.empID,
                    loginResponse.loginDtls?.empID ?? "");
                if (loginResponse.loginDtls?.oTP?.isNotEmpty ?? false) {
                  AppLogger().logDebug(
                      "OTP::::::::::::::::::: ${loginResponse.loginDtls?.oTP}");

                  await LocalStoreHelper().writeData(SharedPrefConstants.otp,
                      loginResponse.loginDtls?.oTP ?? "");
                  if (!context.mounted) return;
                  Navigator.pushNamed(
                    context,
                    AppRoutes.otp,
                  );
                } else if (loginResponse.loginDtls?.mPIN?.isNotEmpty ?? false) {
                  await LocalStoreHelper().writeData(SharedPrefConstants.mpin,
                      loginResponse.loginDtls?.mPIN ?? "");
                  if (!context.mounted) return;
                  Navigator.pushNamed(
                    context,
                    AppRoutes.validateMpin,
                  );
                }
              } else if (loginResponse.statusCode == ApiErrorCodes.badRequest) {
                setLoaderVisibleStatus(false);
                if (!context.mounted) return;
                ErrorCustomCupertinoAlert().showAlert(
                  context,
                  message: loginResponse.statusMsg.toString(),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                );
              } else {
                setLoaderVisibleStatus(false);
                if (!context.mounted) return;
                ErrorCustomCupertinoAlert().showAlert(
                  context,
                  message: loginResponse.statusMsg ?? "",
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                );
              }
            } else {
              setLoaderVisibleStatus(false);
              if (!context.mounted) return;
              ErrorCustomCupertinoAlert().showAlert(
                context,
                message: "somethingWentWrong".tr(),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              );
            }
          } else {
            if (!context.mounted) return;
            InternetCheckAlert().showAlert(context);
          }
        }
      }
    } on DioException catch (dioError) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } finally {
      setLoaderVisibleStatus(false);
    }
  }

  bool validateInputs(String userId, BuildContext context) {
    if (userId.isEmpty) {
      ValidationIoSAlert().showAlert(
        context,
        description: "Please Enter user Id and try again",
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

  bool checkPassword(dynamic password, BuildContext context) {
    if (password.isEmpty || password == null || password == "") {
      ValidationIoSAlert().showAlert(
        context,
        description: "Please Enter password and try again",
      );
      return false;
    } else {
      return true;
    }
  }
}
