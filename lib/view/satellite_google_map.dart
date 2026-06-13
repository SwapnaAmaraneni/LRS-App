import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/utils/address_fetch.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view_model/view_polygon_view_model.dart';
import 'package:provider/provider.dart';

class GoogleMapSatelliteWidget extends StatefulWidget {
  const GoogleMapSatelliteWidget({super.key});

  @override
  State<GoogleMapSatelliteWidget> createState() =>
      _GoogleMapSatelliteWidgetState();
}

class _GoogleMapSatelliteWidgetState extends State<GoogleMapSatelliteWidget> {
  List<Marker> markers = [];
  Set<Polygon> polygons = {};
  late GoogleMapController mapController;
  LatLng initialCameraPosition = LatLng(0, 0); // Default position
  bool isMapLoaded = false; // Track if the map is ready to load
  MapType _currentMapType = MapType.satellite;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadPolygonsAndMarkers();
    });
  }

  Future<void> _loadPolygonsAndMarkers() async {
    String appId = ModalRoute.of(context)?.settings.arguments as String;
    final viewPolygonProvider =
        Provider.of<ViewPolygonViewModel>(context, listen: false);
    viewPolygonProvider.setLoaderVisibleStatus(true);

    await viewPolygonProvider.getPolygons(context, appId);
    if (viewPolygonProvider.latlongList.isNotEmpty) {
      initialCameraPosition = viewPolygonProvider.latlongList.first;

      List<LatLng> polygonPoints = [];
      for (var element in viewPolygonProvider.latlongList) {
        final address = await GetCurrentAddress()
            .getCurrentAddress(element.latitude, element.longitude);

        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId(address),
              position: element,
              infoWindow: InfoWindow(title: address),
              onTap: () {
                _showBottomSheet(address);
              },
            ),
          );
          polygonPoints.add(element);
        });
      }

      if (polygonPoints.isNotEmpty) {
        polygons.add(
          Polygon(
            polygonId: PolygonId('polygon_id'),
            points: polygonPoints,
            strokeColor: Colors.blue,
            strokeWidth: 2,
            fillColor: Colors.blue.withValues(alpha: 0.3),
          ),
        );
      }

      setState(() {
        isMapLoaded = true; // Set the flag to true after loading data
      });
    } else {
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
      );
      initialCameraPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        isMapLoaded = true; // Set the flag to true after loading data
      });
      if (!mounted) return;
      ErrorCustomCupertinoAlert().showAlert(
        context,
        message: "Invalid Coordinates",
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
  }

  Set<Marker> _createMarkers() {
    return markers.toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (markers.isNotEmpty) {
      // Show the Info Window for the first marker after the map is created
      controller.showMarkerInfoWindow(markers.first.markerId);
    }
  }

  void _onMapTypeChanged(MapType? type) {
    if (type != null) {
      setState(() {
        _currentMapType = type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarReusable(
        title: "View on Map",
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
      body: isMapLoaded // Check if the map is loaded
          ? Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialCameraPosition,
                    zoom: 100,
                  ),
                  markers: _createMarkers(),
                  polygons: polygons,
                  mapType: _currentMapType,
                  onMapCreated: _onMapCreated,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: _showMapTypeSelector,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.layers,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : LoaderComponent(),
    );
  }

  void _showMapTypeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          child: Column(
            children: [
              Text(
                'Map Type',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appBarColor),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mapTypeButton(MapType.normal, 'Normal'),
                  _mapTypeButton(MapType.satellite, 'Satellite'),
                  _mapTypeButton(MapType.terrain, 'Terrain'),
                  _mapTypeButton(MapType.hybrid, 'Hybrid'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mapTypeButton(MapType type, String label) {
    bool isSelected = type == _currentMapType;

    return GestureDetector(
      onTap: () {
        _onMapTypeChanged(type);
        Navigator.pop(context); // Close the bottom sheet
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              type == MapType.normal
                  ? Icons.map
                  : type == MapType.satellite
                      ? Icons.satellite
                      : type == MapType.terrain
                          ? Icons.terrain
                          : Icons.layers,
              size: 40,
              color: AppColors.appBarColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.appBarColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(String address) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Address Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(address),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
