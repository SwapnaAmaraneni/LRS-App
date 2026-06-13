import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/repository/resend_otp_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';

import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:flutter/material.dart';
import '../models/resend_otp_payload.dart';
import '../routes/app_routes.dart';
import '../utils/internet.dart';

class OtpViewModel with ChangeNotifier {
  Future<void> validateSentOtp(BuildContext context, String sentOtp,
      TextEditingController otpController) async {
    AppLogger().logDebug("otp:::::::::::: $sentOtp");
    sentOtp = await LocalStoreHelper().readTheData(SharedPrefConstants.otp);

    AppLogger().logDebug("prefs otp:::::::::::: $sentOtp");
    if (!context.mounted) return;
    if (otpController.text.isEmpty || otpController.text.length < 4) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "enterOTP".tr(),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    } else if (sentOtp == otpController.text) {
      Navigator.pushNamed(context, AppRoutes.setMpin);
    } else {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "incorrectOTP".tr(),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    }
  }

  final _resendRepo = ResendOTPRepository();
  Future<String?> getResendOtp(
    BuildContext context,
    String mobileNo,
  ) async {
    try {
      final payload = ResendOTPPayload(
        mobileNo: mobileNo,
      );

      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        if (!context.mounted) return null;
        final response = await _resendRepo.getResendOTPRepo(context, payload);
        setLoaderVisibleStatus(false);
        if (response != null) {
          if (response.statusCode == ApiErrorCodes.success) {
            notifyListeners();
            await LocalStoreHelper()
                .writeData(SharedPrefConstants.otp, response.oTP ?? "");
            return response.oTP;
          } else if (response.statusCode == ApiErrorCodes.badRequest) {
            if (!context.mounted) return null;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg.toString(),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          } else {
            if (!context.mounted) return null;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg ?? "",
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          }
        } else {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return null;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: "somethingWentWrong".tr(),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        setLoaderVisibleStatus(false);
        if (!context.mounted) return null;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
      }
    } on DioException catch (dioError) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return null;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return null;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } finally {
      setLoaderVisibleStatus(false);
    }
    return null;
  }

  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;
  void setLoaderVisibleStatus(bool isLoaderVisible) {
    _isLoaderVisible = isLoaderVisible;
    notifyListeners();
  }
}
