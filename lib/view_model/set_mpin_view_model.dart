import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/generate_mpin_response.dart';
import 'package:lrsofficer/repository/generate_mpin_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import '../data/local_store_helper.dart';
import '../models/generate_mpin_payload.dart';
import '../routes/app_routes.dart';
import '../utils/api_error_codes.dart';
import '../utils/internet.dart';
import '../utils/shared_pref_constants.dart';

class SetMpinViewModel with ChangeNotifier {
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  TextEditingController mpinController = TextEditingController();
  TextEditingController confirmMpinController = TextEditingController();

  Future<void> generateMPIN(BuildContext context) async {
    AppLogger().logDebug("lmpin ::::::::${mpinController.text}");

    AppLogger()
        .logDebug("confirmMpin::::::::::: ${confirmMpinController.text}");

    if (mpinController.text.isEmpty || mpinController.text.length < 4) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "enter4DigitMpin".tr(),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    } else if (confirmMpinController.text.isEmpty ||
        confirmMpinController.text.length < 4) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "confirm4DigitMpin".tr(),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    } else if (mpinController.text != confirmMpinController.text) {
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "mpinUnmatched".tr(),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    } else if (mpinController.text == confirmMpinController.text) {
      GenerateMPINPayLoad setMPINPayLoad = GenerateMPINPayLoad();
      setMPINPayLoad.userID =
          await LocalStoreHelper().readTheData(SharedPrefConstants.userID);
      setMPINPayLoad.tokenID =
          await LocalStoreHelper().readTheData(SharedPrefConstants.token);
      setMPINPayLoad.mPIN = mpinController.text.trim();
      setMPINPayLoad.empID =
          await LocalStoreHelper().readTheData(SharedPrefConstants.empID);
      if (!context.mounted) return;
      mpinApiCall(setMPINPayLoad, context, mpinController.text);
    }
  }

  Future<void> mpinApiCall(GenerateMPINPayLoad setMPINPayLoad,
      BuildContext context, String mpin) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        GenerateMPINResponse? generateMPINResponse =
            await GenerateMPINRepository()
                .generateMpinRepo(context, setMPINPayLoad);
        if (generateMPINResponse != null) {
          if (generateMPINResponse.statusCode == ApiErrorCodes.success) {
            if (!context.mounted) return;
            SuccessCustomCupertinoAlert().showAlert(
                context: context,
                title: generateMPINResponse.statusMsg ?? "",
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.validateMpin);
                });

            await LocalStoreHelper().writeData(SharedPrefConstants.mpin, mpin);
            setLoaderVisibleStatus(false);
          } else if (generateMPINResponse.statusCode ==
              ApiErrorCodes.badRequest) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: generateMPINResponse.statusMsg ?? "",
              onPressed: () async {
                Navigator.pop(context);
              },
            );
          } else if (generateMPINResponse.statusCode ==
              ApiErrorCodes.sessionExpired) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: generateMPINResponse.statusMsg ?? "",
              onPressed: () async {
                await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            );
          } else {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: generateMPINResponse.statusMsg ?? "",
              onPressed: () async {
                Navigator.pop(context);
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
              Navigator.pop(context);
            },
          );
        }

        setLoaderVisibleStatus(false);
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.pop(context);
          },
        );
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
}
