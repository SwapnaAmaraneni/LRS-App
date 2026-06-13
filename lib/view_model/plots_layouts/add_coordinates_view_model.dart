import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_warning_alert.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCoordinatesViewModel with ChangeNotifier {
  //On AddCoordinateClick
  List<LatLng> latlongsList = [];
  List<LatLng> get getAddedCoordinates => latlongsList;

  clearAll() {
    latlongsList.clear();
    notifyListeners();
  }

  Future<void> onAddCoordinateClick(BuildContext context) async {
    setLoaderVisibleStatus(true);
    await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    ).then(
      (currentPos) async {
        final currentLatLng = LatLng(currentPos.latitude, currentPos.longitude);

        if (!context.mounted) return;
        await onAdd(context, currentLatLng);
      },
    );
  }

  //Please capture geo coordinates in clock wise direction only(i.e East ->West ->South -> North)
  Future<void> onAdd(BuildContext context, LatLng centerPoint) async {
    await getCurrentPosition(context);

    bool isAlreadyAdded = latlongsList.any((marker) =>
        marker.latitude == centerPoint.latitude &&
        marker.longitude == centerPoint.longitude);

    if (!isAlreadyAdded) {
      latlongsList.add(
        LatLng(centerPoint.latitude, centerPoint.longitude),
      );
    } else {
      if (!context.mounted) return;
      WarningCustomCupertinoAlert().showAlert(context,
          message: "Coordinates added already for the current location",
          onPressed: () {
        Navigator.pop(context);
      });
    }
    setLoaderVisibleStatus(false);
    notifyListeners();
  }

  void onRemove(BuildContext context, int index) {
    if (latlongsList.isNotEmpty) {
      latlongsList.removeAt(index);
    } else {
      WarningCustomCupertinoAlert().showAlert(context,
          message: "There are no Coordinates to delete", onPressed: () {
        Navigator.pop(context);
      });
    }
    notifyListeners();
  }

  double? latitude;
  double? longitude;
  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
      locationSettings:
          LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
    ).then((Position position) {}).catchError((e) {});
    notifyListeners();
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services adre disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    notifyListeners();
    return true;
  }

  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;
  void setLoaderVisibleStatus(bool isLoaderVisible) {
    _isLoaderVisible = isLoaderVisible;
    notifyListeners();
  }

  Future<void> onNextClick(BuildContext context) async {
    List<List<double>> coordinates = getAddedCoordinates
        .map((latLng) => [latLng.longitude, latLng.latitude])
        .toList();
    final latlngStrList = jsonEncode(coordinates);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPrefConstants.gisCoordinatesList, latlngStrList);
    if (!context.mounted) return;
    Navigator.pushNamed(context, AppRoutes.savedCheckDetails);
  }

  void addSavedLatlngs(List<LatLng> list) {
    latlongsList.addAll(list);
    notifyListeners();
  }
}
