import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/base64.dart';
import 'package:lrsofficer/utils/file_path_check_utils.dart';
import 'package:lrsofficer/utils/permission_utils.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IGRSUploadPlotDetailsViewModel with ChangeNotifier {
  Future<void> validationsForPlotDetails(
      {required BuildContext context,
      String? layoutSelectedAnswer,
      String? layoutSelectedDoc,
      String? ownershipDocSelectedAnswer,
      String? ownershipSelectedDoc,
      String? ecDocSelectedAnswer,
      String? ecSelectedDoc,
      List<String>? images,
      String? captureLocScreenshot,
      String? latitude,
      String? longitude}) async {
    setLoaderVisibleStatus(true);
    final layoutDoc = await processFileOrUrl(layoutSelectedDoc);
    final ownerDoc = await processFileOrUrl(ownershipSelectedDoc);
    final ecDoc = await processFileOrUrl(ecSelectedDoc);

    for (int i = 0; i < (images?.length ?? 0); i++) {
      images?[i] = await processImage(images[i]);
    }
    AppLogger().logDebug(
        "Answers:: $layoutSelectedAnswer &&&&& $ownershipDocSelectedAnswer &&& $ecDocSelectedAnswer");
    final prefs = await SharedPreferences.getInstance();
    if (layoutSelectedAnswer == "") {
      if (!context.mounted) return;
      setLoaderVisibleStatus(false);
      ValidationIoSAlert().showAlert(context,
          description: "Please select option layout Document");
    } else if (layoutSelectedAnswer == "Y" && layoutDoc == "") {
      if (!context.mounted) return;
      setLoaderVisibleStatus(false);
      ValidationIoSAlert()
          .showAlert(context, description: "Please upload layout Document");
    } else if (ownershipDocSelectedAnswer == "") {
      if (!context.mounted) return;
      setLoaderVisibleStatus(false);
      ValidationIoSAlert().showAlert(context,
          description: "Please select option ownership Document");
    } else if (ownershipDocSelectedAnswer == "Y" && ownerDoc == "") {
      if (!context.mounted) return;
      setLoaderVisibleStatus(false);
      ValidationIoSAlert()
          .showAlert(context, description: "Please upload ownership Document");
    } else if (ecDocSelectedAnswer == "") {
      if (!context.mounted) return;
      setLoaderVisibleStatus(false);
      ValidationIoSAlert()
          .showAlert(context, description: "Please select option EC Document");
    } else if (ecDocSelectedAnswer == "Y" && ecDoc == "") {
      if (!context.mounted) return;
      setLoaderVisibleStatus(false);
      ValidationIoSAlert()
          .showAlert(context, description: "Please upload EC Document");
    } else {
      if (images == null || images.isEmpty || images.first.isEmpty) {
        if (!context.mounted) return;
        ValidationIoSAlert()
            .showAlert(context, description: "Please upload plot image1");
        return;
      }

      setLoaderVisibleStatus(true);

      if (images.isNotEmpty) {
        await prefs.setString(
            SharedPrefConstants.plot1Img, await processImage(images[0]));
      }
      if (images.length >= 2) {
        await prefs.setString(
            SharedPrefConstants.plot2Img, await processImage(images[1]));
      }
      if (images.length >= 3) {
        await prefs.setString(
            SharedPrefConstants.plot3Img, await processImage(images[2]));
      }
      if (images.length >= 4) {
        await prefs.setString(SharedPrefConstants.plot4ImgMasterPlanExt,
            await processImage(images[3]));
      }

      // 🔹 Capture screenshot
      final capLocBase64 = (captureLocScreenshot?.isNotEmpty ?? false)
          ? convertToBase64(captureLocScreenshot!)
          : "";
      await prefs.setString(
          SharedPrefConstants.plot5ImgCaptureLocScreenshot, capLocBase64);

      // 🔹 Save coordinates + other answers
      await prefs.setString(SharedPrefConstants.latitudeKey, latitude ?? "");
      await prefs.setString(SharedPrefConstants.longitudeKey, longitude ?? "");
      await prefs.setString(SharedPrefConstants.layoutDocumentradioVal,
          layoutSelectedAnswer.toString());
      await prefs.setString(SharedPrefConstants.ownershipDocumetRadioVal,
          ownershipDocSelectedAnswer.toString());
      await prefs.setString(SharedPrefConstants.ecDocumentRadioVal,
          ecDocSelectedAnswer.toString());

      await prefs.setString(
          SharedPrefConstants.layoutSelectedDocKey, layoutDoc);
      await prefs.setString(
          SharedPrefConstants.ownershipSelectedDocKey, ownerDoc);
      await prefs.setString(SharedPrefConstants.ecSelectedDocKey, ecDoc);

      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      Navigator.pushNamed(context, AppRoutes.igrsAddCoordinates);
    }
  }

  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;
  void setLoaderVisibleStatus(bool isLoaderVisible) {
    _isLoaderVisible = isLoaderVisible;
    notifyListeners();
  }

  Future<File> saveImageToFile(Uint8List imageBytes) async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();

      // Create a file in the temporary directory with the name image.png
      File file = File('${tempDir.path}/image.png');

      // Write the image bytes to the file
      await file.writeAsBytes(imageBytes);

      return file; // Return the file
    } catch (e) {
      // Handle errors if any

      AppLogger().logDebug("Error saving image: $e");
      return File("");
    }
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    final locPermission = await PermissionsUtil.checkLocationPermission();
    if (locPermission) {
      if (!context.mounted) return false;
      return await isServiceEnabled(context);
    } else {
      if (!context.mounted) return false;
      setLoaderVisibleStatus(false);
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Permissions Required"),
            content: const Text(
              "Please allow location permissions to continue further",
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("cancel".tr()),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(AppRoutes.dashboard),
                  );
                },
              ),
              CupertinoDialogAction(
                child: const Text('Open Settings'),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(AppRoutes.dashboard),
                  );
                  await openAppSettings();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  Future<bool> isServiceEnabled(BuildContext context) async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return false;
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: const Text(
              "Please turn on location services to continue",
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("ok".tr()),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(AppRoutes.dashboard),
                  );
                },
              ),
            ],
          );
        },
      );

      return false;
    } else {
      try {
        final currentPos = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
        );

        AppLogger().logDebug(
            "CurrentPosition:::: ${currentPos.latitude} :: ${currentPos.longitude}");
        return true;
      } catch (e) {
        setLoaderVisibleStatus(false);
        AppLogger().logDebug("exception $e");
        if (!context.mounted) return false;
        if (e is LocationServiceDisabledException) {
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: "Please Enable Location to Continue",
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.dashboard);
            },
          );
          // Navigator.pop(context);
        }
        return false;
      }
    }
  }

  bool isBase64Image(String str) {
    try {
      // Decode the string
      final decodedBytes = base64Decode(str);

      // Check if the length of the decoded byte array is greater than 0
      if (!kReleaseMode) debugPrint("ISBAse64 :: ${decodedBytes.isNotEmpty}");
      return decodedBytes.isNotEmpty;
    } catch (e) {
      // If an exception occurs, the string is not base64 encoded
      return false;
    }
  }
}
