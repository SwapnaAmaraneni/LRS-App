import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/repository/generate_mpin_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import '../data/local_store_helper.dart';
import '../models/generate_mpin_payload.dart';
import '../models/generate_mpin_response.dart';
import '../routes/app_routes.dart';
import '../utils/api_error_codes.dart';
import '../utils/internet.dart';
import '../utils/shared_pref_constants.dart';

class ValidateMpinViewModel with ChangeNotifier {
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> validateMpin(
      TextEditingController mpin, BuildContext context) async {
    final savedMPIN =
        await LocalStoreHelper().readTheData(SharedPrefConstants.mpin);
    //Code for checking mpins match or not

    AppLogger().logDebug("saved mpin:::$savedMPIN    entered mpin $mpin");
    if (mpin.text.isEmpty || mpin.text.length < 4) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      ValidationIoSAlert().showAlert(
        context,
        description: "enter4DigitMpin".tr(),
      );
    } else if (mpin.text != savedMPIN) {
      if (!context.mounted) return;
      mpin.clear();
      setLoaderVisibleStatus(false);
      ValidationIoSAlert().showAlert(
        context,
        description: "validMpin".tr(),
      );
    } else if (mpin.text == savedMPIN) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      Navigator.pushNamed(context, AppRoutes.dashboard);
      //Navigator.pushNamed(context, AppRoutes.checkDetails);
    }
  }

  void loginToAnotherAccount(BuildContext context) {}

  Future<void> notYOU(BuildContext context) async {
    await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
    await LocalStoreHelper().clearData();
    final value =
        await LocalStoreHelper().containsKey(SharedPrefConstants.mpin);

    AppLogger().logDebug("hello::::$value");
  }

  Future<void> forgotMPIN(BuildContext context) async {
    try {
      GenerateMPINPayLoad setMPINPayLoad = GenerateMPINPayLoad();
      setMPINPayLoad.userID =
          await LocalStoreHelper().readTheData(SharedPrefConstants.userID);
      setMPINPayLoad.tokenID =
          await LocalStoreHelper().readTheData(SharedPrefConstants.token);
      setMPINPayLoad.mPIN = "";
      setMPINPayLoad.empID =
          await LocalStoreHelper().readTheData(SharedPrefConstants.empID);
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        GenerateMPINResponse? generateMPINResponse =
            await GenerateMPINRepository()
                .generateMpinRepo(context, setMPINPayLoad);
        if (generateMPINResponse != null) {
          if (generateMPINResponse.statusCode == ApiErrorCodes.success) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(context, AppRoutes.login);
            await LocalStoreHelper().clearData();
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
