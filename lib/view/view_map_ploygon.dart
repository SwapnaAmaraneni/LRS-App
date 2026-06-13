/* import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:latlong2/latlong.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view_model/view_polygon_view_model.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class ViewMapPolygon extends StatefulWidget {
  const ViewMapPolygon({super.key});

  @override
  State<ViewMapPolygon> createState() => _ViewMapPolygonState();
}

class _ViewMapPolygonState extends State<ViewMapPolygon> {
  final MapController mymapController = MapController();
  List<LatLng> sampleList = [];
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ViewPolygonViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "View Map",
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.white,
              ),
            ),
          ),
          body: (sampleList.isNotEmpty)
              ? FlutterMap(
                  mapController: mymapController,
                  options: MapOptions(
                    maxZoom: 30,
                    minZoom: 10,
                    onMapReady: () {
                      mymapController.mapEventStream.listen((event) {
                        if (event is MapEventMove) {}
                      });
                    },
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.drag,
                    ),
                    initialCenter: LatLng(provider.latlongList.first.latitude,
                        sampleList.first.longitude),
                    initialZoom: 19,
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
                    MarkerLayer(alignment: Alignment.center, markers: markers),
                    if (markers.isNotEmpty)
                      PolygonLayer(
                        polygons: [
                          _buildNonIntersectingPolygon(
                            provider.latlongList,
                            borderColor: Colors.red,
                            borderWidth: 5,
                            fillColor: Colors.blue,
                          ),
                        ],
                      ),
                  ],
                )
              : Container(),
        ),
        if (provider.getLoaderVisibilityStatus) const LoaderComponent()
      ],
    );
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
  } // Cross product of vectors (p1->p2) and (p1->p3)

  double crossProduct(LatLng p1, LatLng p2, LatLng p3) {
    return (p2.longitude - p1.longitude) * (p3.latitude - p1.latitude) -
        (p2.latitude - p1.latitude) * (p3.longitude - p1.longitude);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sampleList.clear();
      markers.clear();
      String appId = ModalRoute.of(context)?.settings.arguments as String;
      final viewpolygonProvider =
          Provider.of<ViewPolygonViewModel>(context, listen: false);
      viewpolygonProvider.setLoaderVisibleStatus(true);
      await viewpolygonProvider.getPolygons(context, appId);
      if (viewpolygonProvider.latlongList.isNotEmpty) {
        sampleList = viewpolygonProvider.latlongList;
        for (var element in sampleList) {
          setState(() {
            markers.add(
              Marker(
                point: element,
                child: const Icon(
                  Icons.place,
                  size: 30,
                  color: Colors.red,
                ),
              ),
            );
          });
        }
        setState(() {});
      }
    });
  }
}
 */