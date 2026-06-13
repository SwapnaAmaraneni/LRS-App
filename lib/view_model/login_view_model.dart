import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/login/login_payload.dart';
import 'package:lrsofficer/models/login/login_response.dart';
import 'package:lrsofficer/repository/login_repository.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:flutter/material.dart';
import '../data/local_store_helper.dart';
import '../res/CustomAlerts/custom_error_alert.dart';
import '../res/CustomAlerts/internet_check_alert.dart';
import '../res/CustomAlerts/validation_ios_alert.dart';
import '../routes/app_routes.dart';
import '../utils/api_error_codes.dart';
import '../utils/get_device_id.dart';
import '../utils/shared_pref_constants.dart';

class LoginViewModel with ChangeNotifier {
  Future<void> login(String userId, BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();
      String? deviceId = await GetDeviceId().getDeviceId();

      AppLogger().logDebug("dvecie id $deviceId ");
      if (!context.mounted) return;
      if (validateInputs(userId, context)) {
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
              if (loginResponse.loginDtls?.mOBILENO?.length == 10) {
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
                final responseString =
                    jsonEncode(loginResponse.loginDtls?.toJson());
                await LocalStoreHelper().writeData(SharedPrefConstants.userType,
                    (loginResponse.loginDtls?.uSERTYPE ?? "").toLowerCase());
                await LocalStoreHelper().writeData(
                    SharedPrefConstants.loginResponse, responseString);
                AppConstants.userType = loginResponse.loginDtls?.uSERTYPE ?? "";
                if (loginResponse.loginDtls?.oTP?.isNotEmpty ?? false) {
                  AppLogger().logDebug(
                      "OTP::::::::::::::::::: ${loginResponse.loginDtls?.oTP} ");

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
              } else {
                if (!context.mounted) return;
                ErrorCustomCupertinoAlert().showAlert(
                  context,
                  message: "invalidNumber".tr(),
                );
              }
              //Mobile number is not linked for the entered User ID//
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

  Future<void> registration(BuildContext context) async {
    Navigator.pushNamed(
      context,
      AppRoutes.registartion,
    );
  }

  bool validateInputs(String mobile, BuildContext context) {
    if (mobile.isEmpty) {
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
    }  */
    else {
      return true;
    }
  }

  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }
}
