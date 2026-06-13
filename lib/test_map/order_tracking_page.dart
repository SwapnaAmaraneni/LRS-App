/* import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/polygon_bottom_sheet.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:screenshot/screenshot.dart';


class MinimumExample extends StatefulWidget {
  const MinimumExample({super.key});

  @override
  State<MinimumExample> createState() => _MinimumExampleState();
}

class _MinimumExampleState extends State<MinimumExample> {
  final Location _locationService = Location();
  StreamController<LocationMarkerPosition?>? locationStreamController;
  LatLng? searchingPoint;
  final ScreenshotController screenshotController = ScreenshotController();
  final MapController mymapController = MapController();
  List<LatLng> saveLatlongList = [];
  bool isControllerClosed = false;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    locationStreamController =
        StreamController<LocationMarkerPosition?>.broadcast(
      onListen: () {
        isControllerClosed = false;
      },
      onCancel: () {
        isControllerClosed = true;
      },
    );
    saveLatlongList.clear();
    /*  _locationService.getLocation().then((locationData) {
      final position = LatLng(locationData.latitude!, locationData.longitude!);
      locationStreamController?.add(LocationMarkerPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: 0,
      ));
    }); */
    _locationService.onLocationChanged.listen((locationData) {
      if (!isControllerClosed) {
        final position =
            LatLng(locationData.latitude!, locationData.longitude!);
        currentLocation = position;
        locationStreamController?.add(LocationMarkerPosition(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: 0,
        ));
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    isControllerClosed = true;
    locationStreamController?.close();
  }

  @override
  Widget build(BuildContext context) {
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              locationStreamController?.close();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Minimum Example'),
      ),
      body: FlutterMap(
        mapController: mymapController,
        options: const MapOptions(
          initialCenter: LatLng(0, 0),
          initialZoom: 25,
          minZoom: 0,
          maxZoom: 25,
        ),
        children: [
          TileLayer(
            urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
            userAgentPackageName:
                'net.tlserver6y.flutter_map_location_marker.example',
            maxZoom: 19,
          ),
          FeatureLayer(
            FeatureLayerOptions(
                "https://gis.cgg.gov.in/arcgis/rest/services/LRS/PlotDetails/FeatureServer/0",
                "polygon", render: (dynamic attributes) {
              // You can render by attribute
              return null; /* const PolygonOptions(
                              borderColor: Colors.red,
                              borderStrokeWidth: 10,
                              isFilled: true); */
            }),
          ),
          MarkerLayer(
            alignment: Alignment.center,
            markers: [
              if (searchingPoint != null)
                Marker(
                  point: searchingPoint!,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ...captureGeoCoordinatesProvider.markers,
            ],
          ),
          if (captureGeoCoordinatesProvider.latlongsList.isNotEmpty)
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
          CurrentLocationLayer(
            // alignPositionStream: locationStreamController?.stream,
            positionStream: locationStreamController?.stream,
            alignPositionOnUpdate: AlignOnUpdate.always,
            alignDirectionOnUpdate: AlignOnUpdate.always,
            style: const LocationMarkerStyle(
              markerSize: Size(20, 20),
              markerDirection: MarkerDirection.heading,
            ),
          ),
        ],
      ),
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
                // await captureGeoCoordinatesProvider.onAdd(context);
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
                  /* final capturedImage = await screenshotController.capture(
                      delay: const Duration(milliseconds: 10)); */
                  // widget.callbackValue(capturedImage);
                  if (!context.mounted) return;
                  await captureGeoCoordinatesProvider.onSave(
                    context,
                    saveLatlongList,
                  );
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
                captureGeoCoordinatesProvider.onClear(context);
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
    );
  }

  void _moveToCurrentLocation() {
    _locationService.onLocationChanged.listen((locationData) {
      if (!isControllerClosed) {
        final position =
            LatLng(locationData.latitude!, locationData.longitude!);
        currentLocation = position;
        locationStreamController?.add(LocationMarkerPosition(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: 0,
        ));
        mymapController.move(currentLocation ?? const LatLng(0, 0),
            23); // Move map to current location
      }
    });
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

    return convexHull;
  }

// Cross product of vectors (p1->p2) and (p1->p3)
  double crossProduct(LatLng p1, LatLng p2, LatLng p3) {
    return (p2.longitude - p1.longitude) * (p3.latitude - p1.latitude) -
        (p2.latitude - p1.latitude) * (p3.longitude - p1.longitude);
  }
}

// A demo for a custom position and heading stream. In this example, the
// location marker is controlled by a joystick instead of the device sensor.
// This example provide same behavior as Joystick Example.
class CustomStreamExample extends StatefulWidget {
  const CustomStreamExample({super.key});

  @override
  CustomStreamExampleState createState() => CustomStreamExampleState();
}

class CustomStreamExampleState extends State<CustomStreamExample> {
  late final StreamController<LocationMarkerPosition> _positionStreamController;
  late final StreamController<LocationMarkerHeading> _headingStreamController;
  double _currentLat = 0;
  double _currentLng = 0;

  @override
  void initState() {
    super.initState();
    _positionStreamController = StreamController()
      ..add(
        LocationMarkerPosition(
          latitude: _currentLat,
          longitude: _currentLng,
          accuracy: 0,
        ),
      );
  
    _headingStreamController = StreamController()
      ..add(
        LocationMarkerHeading(
          heading: 0,
          accuracy: pi * 0.2,
        ),
      );
  }

  @override
  void dispose() {
    _positionStreamController.close();
    _headingStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Stream Example'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(0, 0),
              initialZoom: 25,
              minZoom: 0,
              maxZoom: 19,
            ),
            // ignore: sort_child_properties_last
            children: [
              TileLayer(
                
                 urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
            userAgentPackageName:
                'net.tlserver6y.flutter_map_location_marker.example',
              maxZoom: 19,
               /*  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'net.tlserver6y.flutter_map_location_marker.example',
                maxZoom: 19, */
              ),
              CurrentLocationLayer(
                positionStream: _positionStreamController.stream,
                headingStream: _headingStreamController.stream,
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Joystick(
              listener: (details) {
                _currentLat -= details.y;
                _currentLat = _currentLat.clamp(-85, 85);
                _currentLng += details.x;
                _currentLng = _currentLng.clamp(-180, 180);
                _positionStreamController.add(
                  LocationMarkerPosition(
                    latitude: _currentLat,
                    longitude: _currentLng,
                    accuracy: 0,
                  ),
                );
                if (details.x != 0 || details.y != 0) {
                  _headingStreamController.add(
                    LocationMarkerHeading(
                      heading:
                          (math.atan2(details.y, details.x) + pi * 0.5) % (pi * 2),
                      accuracy: pi * 0.2,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
 */