/* import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_warning_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/polygon_bottom_sheet.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:lrsofficer/view_model/upload_plot_details_view_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    required this.callbackValue,
  });
  final void Function(
    Uint8List?,
  ) callbackValue;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController mymapController = MapController();
  final ScreenshotController screenshotController = ScreenshotController();
  Stream<LocationMarkerPosition?>? _positionStream =
      const Stream<LocationMarkerPosition?>.empty();
  Stream<LocationMarkerHeading?>? _headingStream =
      const Stream<LocationMarkerHeading?>.empty();
  List<LatLng> saveLatlongList = [];
  LatLng? searchingPoint;

  @override
  void initState() {
    super.initState();
    const factory = LocationMarkerDataStreamFactory();
    _positionStream =
        factory.fromGeolocatorPositionStream().asBroadcastStream();
    _headingStream = factory.fromCompassHeadingStream().asBroadcastStream();
    saveLatlongList.clear();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final uploadPlotDetailsProvider =
          Provider.of<UploadPlotDetailsViewModel>(context, listen: false);
      await uploadPlotDetailsProvider.handleLocationPermission(context);
      final currentPos = await Geolocator.getCurrentPosition(
          locationSettings:
                  LocationSettings(accuracy: LocationAccuracy.bestForNavigation),);
      setState(() {
        searchingPoint = LatLng(currentPos.latitude, currentPos.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModelNew>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "Capture Geo Coordinates",
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                )),
          ),
          body: (searchingPoint?.latitude != null &&
                  searchingPoint?.longitude != null)
              ? Screenshot(
                  controller: screenshotController,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Please capture geo coordinates in clock wise direction only(i.e East ->West ->South -> North)",
                            style: TextStyle(
                                color: Color.fromARGB(255, 153, 27, 15),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      Flexible(
                        child: FlutterMap(
                          mapController: mymapController,
                          options: MapOptions(
                            maxZoom: 30,
                            minZoom: 10,
                            onMapReady: () {
                              mymapController.mapEventStream.listen((event) {
                                if (event is MapEventMove) {
                                  AppLogger().logDebug(
                                      "Map ready moved to ${event.camera.center.latitude}, ${event.camera.center.longitude}");
                                }
                              });
                            },
                            interactionOptions: const InteractionOptions(
                              flags:
                                  InteractiveFlag.all & ~InteractiveFlag.drag,
                            ),
                            /*   interactiveFlags:
                                InteractiveFlag.all & ~InteractiveFlag.drag, */
                            initialCenter: searchingPoint ??
                                LatLng(searchingPoint?.latitude ?? 0.0,
                                    searchingPoint?.longitude ?? 0.0),
                            initialZoom: 25,
                            keepAlive: true,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                              subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                            ),
                            FeatureLayer(
                              FeatureLayerOptions(
                                  "https://gis.cgg.gov.in/arcgis/rest/services/LRS/PlotDetails/FeatureServer/0",
                                  "polygon", render: (dynamic attributes) {
                                return null;
                              }),
                            ),
                            MarkerLayer(
                              alignment: Alignment.center,
                              markers: [
                                ...captureGeoCoordinatesProvider.markers,
                              ],
                            ),
                            CurrentLocationLayer(
                              positionStream: _positionStream,
                              headingStream: _headingStream,
                              alignPositionOnUpdate: AlignOnUpdate.always,
                              alignDirectionOnUpdate: AlignOnUpdate.always,
                            ),
                            if (captureGeoCoordinatesProvider
                                .latlongsList.isNotEmpty)
                              PolygonLayer(
                                polygons: [
                                  _buildNonIntersectingPolygon(
                                    captureGeoCoordinatesProvider.latlongsList,
                                    borderColor: Colors.red,
                                    borderWidth: 5,
                                    fillColor: Colors.blue,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: AppColors.appBarColor,
            child: Row(
              children: [
                PolygonBottomsheetColumnComponent(
                  title: "Add",
                  assetPath: AppAssets.addMarker,
                  onTap: () async {
                    captureGeoCoordinatesProvider.setIsLoadingStatus(true);
                    final currentPos = await Geolocator.getCurrentPosition(
                        locationSettings:
                  LocationSettings(accuracy: LocationAccuracy.bestForNavigation),);
                    final currentLatLng =
                        LatLng(currentPos.latitude, currentPos.longitude);

                    if (_isMapCentered(
                        currentLatLng, mymapController.camera.center)) {
                      if (!context.mounted) return;
                      await captureGeoCoordinatesProvider.onAdd(
                          context, mymapController.camera.center);
                    } else {
                      if (!context.mounted) return;
                      WarningCustomCupertinoAlert().showAlert(context,
                          message:
                              "Please refresh the map to re-center location",
                          onPressed: () {
                        Navigator.pop(context);
                        captureGeoCoordinatesProvider.setIsLoadingStatus(false);
                      });
                      // Optionally, show a message to the user indicating that the map needs to be centered
                    }
                    /*  captureGeoCoordinatesProvider.setIsLoadingStatus(true);
                    await captureGeoCoordinatesProvider.onAdd(
                        context, mymapController.camera.center); */
                    /* await captureGeoCoordinatesProvider.onAdd(context); */
                  },
                ),
                PolygonBottomsheetColumnComponent(
                  title: "View",
                  assetPath: AppAssets.viewPolygon,
                  onTap: () async {
                    captureGeoCoordinatesProvider.onView(context);
                  },
                ),
                PolygonBottomsheetColumnComponent(
                    title: "Save",
                    assetPath: AppAssets.saveMap,
                    onTap: () async {
                      final capturedImage = await screenshotController.capture(
                          delay: const Duration(milliseconds: 10));

                      if (!context.mounted) return;
                      await captureGeoCoordinatesProvider.onSave(
                        context,
                        /*   saveLatlongList, */
                      );
                      widget.callbackValue(capturedImage);
                    }),
                PolygonBottomsheetColumnComponent(
                  title: "Remove",
                  assetPath: AppAssets.removeMarker,
                  onTap: () async {
                    captureGeoCoordinatesProvider.onRemove(context);
                  },
                ),
                PolygonBottomsheetColumnComponent(
                  title: "Clear",
                  assetPath: AppAssets.clearMarkers,
                  onTap: () async {
                    WarningCustomCupertinoAlertTwoButtons().showAlert(
                      context,
                      message: "Are you sure you want to clear all markers?",
                      onPressedOk: () {
                        widget.callbackValue(null);
                        Navigator.pop(context);
                        captureGeoCoordinatesProvider.onClear(context);
                      },
                      onPressedCancel: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: IconButton(
              onPressed: () {
                _moveToCurrentLocation();
              },
              icon: const Icon(
                Icons.my_location_rounded,
                color: Colors.black,
                size: 50,
              )),
        ),
        if (captureGeoCoordinatesProvider.getIsLoadingStatus)
          const LoaderComponent()
      ],
    );
  }

  bool _isMapCentered(LatLng userLocation, LatLng mapCenter,
      {double threshold = 0.1}) {
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      mapCenter.latitude,
      mapCenter.longitude,
    );
    return distance < threshold;
  }

  Polygon _buildNonIntersectingPolygon(List<LatLng> points,
      {Color borderColor = Colors.black,
      double borderWidth = 1,
      Color fillColor = Colors.transparent}) {
    // Sort the points using Graham Scan algorithm
    List<LatLng> sortedPoints = grahamScan(points);

    return Polygon(
      points: sortedPoints,
      color: fillColor,
      borderColor: borderColor,
      borderStrokeWidth: borderWidth,
      isFilled: true,
    );
  }

  List<LatLng> grahamScan(List<LatLng> points) {
    if (points.length < 3) {
      return points;
    }

    // Find the point with the lowest y-coordinate (and then the lowest x-coordinate if there are ties)
    LatLng referencePoint = points.reduce((a, b) => (a.latitude < b.latitude ||
            (a.latitude == b.latitude && a.longitude < b.longitude))
        ? a
        : b);

    // Sort the points by polar angle with respect to the reference point
    List<LatLng> sortedPoints = List.from(points);

    AppLogger().logDebug("sorted sorted length ${sortedPoints.length}");

    saveLatlongList = sortedPoints;
    sortedPoints.sort((a, b) {
      double angleA = math.atan2(a.latitude - referencePoint.latitude,
          a.longitude - referencePoint.longitude);
      double angleB = math.atan2(b.latitude - referencePoint.latitude,
          b.longitude - referencePoint.longitude);
      return angleA.compareTo(angleB);
    });

    // Graham Scan to find the convex hull
    List<LatLng> convexHull = [sortedPoints[0], sortedPoints[1]];
    for (int i = 2; i < sortedPoints.length; i++) {
      while (convexHull.length >= 2 &&
          crossProduct(convexHull[convexHull.length - 2],
                  convexHull[convexHull.length - 1], sortedPoints[i]) <=
              0) {
        convexHull.removeLast();
      }
      convexHull.add(sortedPoints[i]);
    }

    // Check for colinear points
    int n = convexHull.length;
    if (n >= 3) {
      int i = n - 1;
      while (i >= 1) {
        int j = i - 1;
        // If points i, j, and (i+1)%n are colinear, remove j
        if (crossProduct(
                convexHull[j], convexHull[i], convexHull[(i + 1) % n]) ==
            0) {
          convexHull.removeAt(j);
          n--;
        } else {
          i--;
        }
      }
    }

    AppLogger().logDebug("convex hull ${convexHull.length}");
    return convexHull;
  }

// Cross product of vectors (p1->p2) and (p1->p3)
  double crossProduct(LatLng p1, LatLng p2, LatLng p3) {
    return (p2.longitude - p1.longitude) * (p3.latitude - p1.latitude) -
        (p2.latitude - p1.latitude) * (p3.longitude - p1.longitude);
  }

  /*  // Graham Scan algorithm for sorting points in counterclockwise order
  List<LatLng> grahamScan(List<LatLng> points) {
    if (points.length < 3) {
      return points;
    }

    // Find the point with the lowest y-coordinate (and then the lowest x-coordinate if there are ties)
    LatLng referencePoint = points.reduce((a, b) => (a.latitude < b.latitude ||
            (a.latitude == b.latitude && a.longitude < b.longitude))
        ? a
        : b);

    // Sort the points by polar angle with respect to the reference point
    List<LatLng> sortedPoints = List.from(points);
    sortedPoints.sort((a, b) {
      double angleA = math.atan2(a.latitude - referencePoint.latitude,
          a.longitude - referencePoint.longitude);
      double angleB = math.atan2(b.latitude - referencePoint.latitude,
          b.longitude - referencePoint.longitude);
      return angleA.compareTo(angleB);
    });

    // Graham Scan to find the convex hull
    List<LatLng> convexHull = [sortedPoints[0], sortedPoints[1]];
    for (int i = 2; i < sortedPoints.length; i++) {
      while (convexHull.length >= 2 &&
          crossProduct(convexHull[convexHull.length - 2],
                  convexHull[convexHull.length - 1], sortedPoints[i]) <=
              0) {
        convexHull.removeLast();
      }
      convexHull.add(sortedPoints[i]);
    }

    return convexHull;
  }

  // Cross product of vectors (p1->p2) and (p1->p3)
  double crossProduct(LatLng p1, LatLng p2, LatLng p3) {
    return (p2.longitude - p1.longitude) * (p3.latitude - p1.latitude) -
        (p2.latitude - p1.latitude) * (p3.longitude - p1.longitude);
  } */

  Widget initialiPointMarkerBuilder() {
    return const Icon(
      Icons.place,
      size: 30,
      color: Colors.blue,
    );
  }

  Future<void> _moveToCurrentLocation() async {
    /*    final currentPos = await Geolocator.getCurrentPosition(
        locationSettings:
                  LocationSettings(accuracy: LocationAccuracy.bestForNavigation),);
    searchingPoint = LatLng(currentPos.latitude, currentPos.longitude);

    mymapController.camera.center = searchingPoint ??
        LatLng(
            searchingPoint?.latitude ?? 0.0, searchingPoint?.longitude ?? 0.0); */
    /*   _positionStream?.first.then((position) {
      if (position != null) {
        mymapController.move(LatLng(position.latitude, position.longitude), 23);
      }
     
    }); */
    final currentPos = await Geolocator.getCurrentPosition(
        locationSettings:
                  LocationSettings(accuracy: LocationAccuracy.bestForNavigation),);
    searchingPoint = LatLng(currentPos.latitude, currentPos.longitude);
    mymapController.move(
        searchingPoint ?? const LatLng(0, 0), mymapController.camera.zoom);
    // Move map to current location
    /*  _positionStream?.first.then((position) {
      if (position != null) {
        mymapController.move(LatLng(position.latitude, position.longitude), 23);
        // _addMarker(LatLng(position.latitude, position.longitude));
      }
   ');
    }); */
    /*  LatLng currentLocation = LatLng(
        searchingPoint?.latitude ?? 0.0, searchingPoint?.longitude ?? 0.0);
    mymapController.move(currentLocation, 23); // Move map to current location
    _initialPointMarker(latLng: currentLocation); */
  }
}
 */