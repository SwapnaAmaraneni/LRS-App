// geo coordinates view model
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/arcgis_model/add_feature_response.dart';
import 'package:lrsofficer/repository/arcgis_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_warning_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/internet_check_alert.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import '../routes/app_routes.dart';

class CaptureGeoCoordinatesViewModelNew extends ChangeNotifier {
  Position? currentPosition;
  bool isPolygonSaved = false;
  //all markers list
  List<Marker> markers = [];
  //assigned data on pressing view button
  List<LatLng> latlongsList = [];
  List<LatLng> sortedSavedLatlongList = [];
  bool isViewButtonClicked = false;

  void addSortedLatLng(List<LatLng> sortedPoints) {
    sortedSavedLatlongList = sortedPoints;
  }

  Future<void> insertLatlongs(BuildContext context) async {
    try {
      if (await internetCheck()) {
        final Map<String, dynamic> generateTokenRequestdata = {
          "username": "LRS",
          "password": "lrsplots",
          "client": "requestip"
        };
        if (!context.mounted) return;
        String? tokenData = await ArcGisRepository()
            .generateToken(context, generateTokenRequestdata);
        setIsLoadingStatus(false);
        if (tokenData != null) {
          setIsLoadingStatus(true);
          List<List<double>> coordinates = sortedSavedLatlongList
              .map((latLng) => [latLng.longitude, latLng.latitude])
              .toList();

          AppLogger().logDebug(
              "sortedlatlonglist------------- $sortedSavedLatlongList");
          if (!context.mounted) return;
          AddFeatureResponse? response = await ArcGisRepository().arcGisRepo(
              context, coordinates, tokenData, coordinates.length.toString());
          setIsLoadingStatus(false);
          if (response != null) {
            if (response.addResults != null &&
                response.addResults?[0].success == true) {
              isPolygonSaved = true;
              if (!context.mounted) return;
              SuccessCustomCupertinoAlert().showAlert(
                context: context,
                title: "Submitted succesfully",
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(AppRoutes.uploadePlotDetails),
                  );
                },
              );
            } else {
              if (!context.mounted) return;
              ErrorCustomCupertinoAlert().showAlert(
                context,
                message: "Something went wrong",
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              );
            }
          } else {
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: "Something went wrong",
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          }
        }
      } else {
        if (!context.mounted) return;
        InternetCheckAlert().showAlert(context);
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

  Future<void> onSave(
    BuildContext context,
  ) async {
    if (markers.length < 3) {
      WarningCustomCupertinoAlert().showAlert(context,
          message: "Please add atleast 3 markers", onPressed: () {
        Navigator.pop(context);
      });
    } else {
      if (isViewButtonClicked) {
        setIsLoadingStatus(true);

        await insertLatlongs(context);
      } else {
        WarningCustomCupertinoAlert().showAlert(context,
            message: "Please check polygon before saving", onPressed: () {
          Navigator.pop(context);
        });
      }
    }
    notifyListeners();
  }

  void onRemove(BuildContext context) {
    if (markers.isNotEmpty) {
      markers.removeLast();
    } else if (markers.isEmpty) {
      onClear(context);
    } else {
      WarningCustomCupertinoAlert().showAlert(context,
          message: "There are no markers to delete", onPressed: () {
        Navigator.pop(context);
      });
    }
    notifyListeners();
  }

  void onClear(BuildContext context) {
    markers.clear();
    latlongsList.clear();
    sortedSavedLatlongList.clear();
    isViewButtonClicked = false;
    isPolygonSaved = false;
    notifyListeners();
  }

  void onView(BuildContext context) {
    AppLogger().logDebug("marker length ${markers.length}");
    if (markers.length < 3) {
      WarningCustomCupertinoAlert().showAlert(context,
          message: "Please add atleast 3 markers", onPressed: () {
        Navigator.pop(context);
      });
      isViewButtonClicked = false;
      // toast
    } else {
      latlongsList = markers.map((marker) => marker.position).toList();

      isViewButtonClicked = true;
    }
    notifyListeners();
  }

//Please capture geo coordinates in clock wise direction only(i.e East ->West ->South -> North)
  // onAdd(BuildContext context, LatLng currentLatLng) async {
  //   // await getCurrentPosition(context);

  //   AppLogger().logDebug("latlanssss ${currentPosition?.latitude}");
  //   bool isAlreadyAdded = markers.any((marker) =>
  //       marker.position.latitude == currentLatLng.latitude &&
  //       marker.position.longitude == currentLatLng.longitude);

  //   AppLogger().logDebug(
  //       "point added already $isAlreadyAdded..${currentPosition?.latitude},${currentPosition?.longitude}");
  //   if (!isAlreadyAdded) {
  //     markers.add(
  //       Marker(

  //         position: LatLng(currentLatLng.latitude, currentLatLng.longitude),
  //         child: const Icon(
  //           Icons.place,
  //           size: 30,
  //           color: Colors.red,
  //         ),
  //       ),
  //     );
  //   } else {
  //     //if (!context.mounted) return;
  //     // WarningCustomCupertinoAlert().showAlert(context,
  //     //     message: "Marker added already for the current location",
  //     //     onPressed: () {
  //     //   Navigator.pop(context);
  //     // });
  //   }

  //   setIsLoadingStatus(false);
  //   //  notifyListeners();
  // }

  double? latitude;
  double? longitude;
  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
      locationSettings:
          LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
    ).then((Position position) {
      currentPosition = position;
      latitude = currentPosition?.latitude;
      longitude = currentPosition?.longitude;
    }).catchError((e) {
      AppLogger().logDebug(e.toString());
    });
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  bool _isLoading = false;
  bool get getIsLoadingStatus => _isLoading;
  void setIsLoadingStatus(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;
  void setLoaderVisibleStatus(bool isLoaderVisible) {
    _isLoaderVisible = isLoaderVisible;
    notifyListeners();
  }
}
