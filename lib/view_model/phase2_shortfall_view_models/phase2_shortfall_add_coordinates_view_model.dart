import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_warning_alert.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phase2ShortfallAddCoordinatesViewModel with ChangeNotifier {
  // 🔹 Coordinates list
  final List<LatLng> _latLngList = [];
  List<LatLng> get getAddedCoordinates => List.unmodifiable(_latLngList);

  // 🔹 Clear Coordinates list
  void clearCoordinates() {
    _latLngList.clear();
    notifyListeners();
  }

  // 🔹 Loader visibility
  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;

  // --------------------------------------------------------------------------
  // Add Coordinate
  // --------------------------------------------------------------------------
  Future<void> onAddCoordinateClick(BuildContext context) async {
    setLoaderVisibleStatus(true);
    try {
      final currentPos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );
      if (!context.mounted) return;
      await onAdd(context, LatLng(currentPos.latitude, currentPos.longitude));
    } catch (e) {
      // optional: you can log or handle location fetch error
    } finally {
      setLoaderVisibleStatus(false);
    }
  }

  /// Please capture geo coordinates in clockwise direction only
  /// (i.e., East -> West -> South -> North)
  Future<void> onAdd(BuildContext context, LatLng point) async {
    await getCurrentPosition(context);

    final alreadyExists = _latLngList.any(
      (marker) =>
          marker.latitude == point.latitude &&
          marker.longitude == point.longitude,
    );

    if (alreadyExists) {
      if (!context.mounted) return;
      WarningCustomCupertinoAlert().showAlert(
        context,
        message: "Coordinates already added for the current location",
        onPressed: () => Navigator.pop(context),
      );
      return;
    }

    _latLngList.add(point);
    notifyListeners();
  }

  // --------------------------------------------------------------------------
  // Remove Coordinate
  // --------------------------------------------------------------------------
  void onRemove(BuildContext context, int index) {
    if (_latLngList.isNotEmpty && index < _latLngList.length) {
      _latLngList.removeAt(index);
    } else {
      if (!context.mounted) return;
      WarningCustomCupertinoAlert().showAlert(
        context,
        message: "There are no coordinates to delete",
        onPressed: () => Navigator.pop(context),
      );
    }
    notifyListeners();
  }

  // --------------------------------------------------------------------------
  // Current Position Helpers
  // --------------------------------------------------------------------------
  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;

    try {
      await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );
    } catch (_) {
      // ignore or log
    }
    notifyListeners();
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location services are disabled. Please enable them.'),
      ));
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are denied.'),
        ));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Location permissions are permanently denied; cannot request again.',
        ),
      ));
      return false;
    }

    notifyListeners();
    return true;
  }

  // --------------------------------------------------------------------------
  // Loader Control
  // --------------------------------------------------------------------------
  void setLoaderVisibleStatus(bool isVisible) {
    _isLoaderVisible = isVisible;
    notifyListeners();
  }

  // --------------------------------------------------------------------------
  // Navigation
  // --------------------------------------------------------------------------
  Future<void> onNextClick(BuildContext context) async {
    final coordinates = _latLngList
        .map((latLng) => [latLng.longitude, latLng.latitude])
        .toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      SharedPrefConstants.gisCoordinatesList,
      jsonEncode(coordinates),
    );

    if (!context.mounted) return;
    Navigator.pushNamed(context, AppRoutes.phase2ShortfallChecklist);
  }

  // --------------------------------------------------------------------------
  // Restore saved coordinates
  // --------------------------------------------------------------------------
  void addSavedLatlngs(List<LatLng> list) {
    _latLngList.addAll(list);
    notifyListeners();
  }
}
