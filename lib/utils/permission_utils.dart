import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:geolocator/geolocator.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsUtil {
  static Future<bool> checkLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return true;
      } else {
        return false;
      }
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkCameraPermission() async {
    final PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    } else {
      final PermissionStatus permission = await Permission.camera.request();
      if (permission.isDenied) {
        return false;
      } else if (permission.isGranted || permission.isLimited) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;
      
       AppLogger().logDebug("sdk :: ${android.version.sdkInt}");
      PermissionStatus status = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;

      if (status.isGranted) {
        return true;
      } else if (status.isDenied) {
        final PermissionStatus permission;
        permission = await Permission.storage.request();

        if (permission.isDenied) {
          final PermissionStatus permission;
          permission = await Permission.storage.request();

          if (permission.isDenied) {
            return false;
          } else if (permission.isGranted) {
            return true;
          } else {
            return false;
          }
        } else if (permission.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      final PermissionStatus status;
      status = await Permission.storage.status;

      if (status.isGranted) {
        return true;
      } else if (status.isDenied) {
        final PermissionStatus permission;
        permission = await Permission.storage.request();

        if (permission.isDenied) {
          final PermissionStatus permission;
          permission = await Permission.storage.request();

          if (permission.isDenied) {
            return false;
          } else if (permission.isGranted) {
            return true;
          } else {
            return false;
          }
        } else if (permission.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }
}
