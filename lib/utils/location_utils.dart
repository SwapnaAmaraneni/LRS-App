import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/permission_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationUtils {
  Future<bool> handleLocationPermission() async {
    return await PermissionsUtil.checkLocationPermission();
  }

  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) {
      if (!context.mounted) return;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {},
            child: AlertDialog(
              content: Text("locationPermissionDenied".tr()),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await openAppSettings();
                    },
                    child: Text('ok'.tr()))
              ],
            ),
          );
        },
      );
    } else {
      await Geolocator.getCurrentPosition(
        locationSettings:
            LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
      ).then((Position position) {
        AppLogger().logDebug(
            "position ::: ${position.latitude} ${position.longitude}");
      }).catchError((e) async {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled ||
            e.runtimeType == LocationServiceDisabledException) {
          if (!context.mounted) return;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext dialogContext) {
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {},
                child: AlertDialog(
                  content: Text('locationServiceDisabled'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await Geolocator.getCurrentPosition(
                          locationSettings: LocationSettings(
                              accuracy: LocationAccuracy.bestForNavigation),
                        ).then((Position position) {
                          AppLogger().logDebug(
                              "position ::: ${position.latitude} ${position.longitude}");
                        }).catchError(
                          (e) async {
                            final serviceEnabled =
                                await Geolocator.isLocationServiceEnabled();
                            if (!serviceEnabled ||
                                e.runtimeType ==
                                    LocationServiceDisabledException) {
                              if (!context.mounted) return;
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return PopScope(
                                    canPop: false,
                                    onPopInvokedWithResult: (didPop, result) {},
                                    child: AlertDialog(
                                      content: const Text(
                                          'Location is not enabled in your device. Please enable the location to proceed further'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                                context,
                                                AppRoutes
                                                    .clusterApplicationDetails);
                                          },
                                          child: Text(
                                            'ok'.tr(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                      child: Text(
                        'ok'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      });
    }
  }
}
