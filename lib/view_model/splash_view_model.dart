import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/version_check/version_check_response.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/permission_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';
import '../repository/splash_repository.dart';
import '../res/constants/app_constants.dart';
import '../routes/app_routes.dart';
import '../utils/api_error_codes.dart';
import '../utils/get_device_id.dart';
import '../utils/get_version.dart';
import '../utils/internet.dart';
import '../utils/shared_pref_constants.dart';

class SplashViewModel extends ChangeNotifier {
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> versionCheck(BuildContext context) async {
    try {
      String? deviceId = await GetDeviceId().getDeviceId();

      AppLogger().logDebug("dvecie id $deviceId  ");

      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        VersionCheckResponse? versionCheckResponse =
            await SplashRepository().versionCheckRepo(context);
        if (versionCheckResponse != null) {
          if (versionCheckResponse.statusCode == ApiErrorCodes.success) {
            setLoaderVisibleStatus(false);
            AppConstants.updatedDate = versionCheckResponse.dateTime ?? "";
            final versionNumber = await GetCurrentVersion().getAppVersion();
            AppConstants.appVersion = versionNumber;
            AppConstants.deleteFlag = versionCheckResponse.deleteFlag ?? "";
            final localVersion = versionNumber;
            final serverVersion = versionCheckResponse.versionID;
            final versionCompatible =
                isVersionGreaterOrEqual(localVersion, serverVersion ?? "");
            final ip = await GetDeviceId().getIpAddress();
            if (!kReleaseMode) debugPrint("IPIPIP:: $ip");
            if (versionCheckResponse.versionID != null && versionCompatible) {
              if (!context.mounted) return;
              await PermissionsUtil.checkCameraPermission();
              await PermissionsUtil.checkStoragePermission();
              await PermissionsUtil.checkLocationPermission();
              if (!context.mounted) return;
              isMPINExist(context);
            } else {
              if (!context.mounted) return;
              if (Platform.isAndroid) {
                ErrorCustomCupertinoAlert().showAlert(
                  context,
                  message:
                      "Your Current App Version is $versionNumber\n New Version Available , Please Update.",
                  onPressed: () async {
                    final packageInfo = await PackageInfo.fromPlatform();
                    final packageName = packageInfo.packageName;

                    final packageId = "market://details?id=$packageName";

                    final url = Uri.parse(packageId);

                    AppLogger().logDebug("packageName $url");
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                );
              } else if (Platform.isIOS) {
                ErrorCustomCupertinoAlert().showAlert(
                  context,
                  message:
                      "Your Current App Version is $versionNumber\n New Version Available , Please Update.",
                  onPressed: () async {
                    const appId = "6602890708";
                    final url =
                        Uri.parse("https://apps.apple.com/us/app/lrs/id$appId");
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                );
              }
            }
          } else if (versionCheckResponse.statusCode ==
              ApiErrorCodes.badRequest) {
            if (!context.mounted) return;
            setLoaderVisibleStatus(false);
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: versionCheckResponse.statusMsg.toString(),
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
            message: versionCheckResponse?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
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
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(
        context,
        errorMessage,
        onPressed: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        },
      );
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(
        context,
        errorMessage,
        onPressed: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        },
      );
    } finally {
      setLoaderVisibleStatus(false);
    }
  }

  Future<void> isMPINExist(BuildContext context) async {
    bool isKeyExists =
        await LocalStoreHelper().containsKey(SharedPrefConstants.mpin);
    if (isKeyExists) {
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.validateMpin);
    } else {
      //register
      AppLogger().logDebug("register");
      if (!context.mounted) return;
      await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  bool isVersionGreaterOrEqual(String local, String server) {
    List<String> localVerParts = local.split('.');
    List<String> serverVersionParts = server.split('.');

    int maxLength = localVerParts.length > serverVersionParts.length
        ? localVerParts.length
        : serverVersionParts.length;
    // Loop through each part of the version strings
    for (int i = 0; i < maxLength; i++) {
      int part1 = i < localVerParts.length ? int.parse(localVerParts[i]) : 0;
      int part2 =
          i < serverVersionParts.length ? int.parse(serverVersionParts[i]) : 0;

      if (part1 > part2) {
        // If the part of version1 is greater than the part of version2, version1 is greater
        return true;
      } else if (part1 < part2) {
        // If the part of version1 is less than the part of version2, version1 is less
        return false;
      }
      // If the current parts are equal, continue to the next part
    }
    // If all parts are equal, versions are considered equal
    return true; // Versions are equal
  }
}
