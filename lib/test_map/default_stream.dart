// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:latlong2/latlong.dart';

// class DefaultStreamExample extends StatefulWidget {
//   const DefaultStreamExample({super.key});

//   @override
//   State<DefaultStreamExample> createState() => _DefaultStreamExampleState();
// }

// class _DefaultStreamExampleState extends State<DefaultStreamExample> {
//   Stream<LocationMarkerPosition?>? _positionStream =
//       const Stream<LocationMarkerPosition?>.empty();
//   Stream<LocationMarkerHeading?>? _headingStream =
//       const Stream<LocationMarkerHeading?>.empty();
//   final MapController _mapController = MapController();
//   // List to hold markers
//   final List<Marker> _markers = [];
//   @override
//   void initState() {
//     super.initState();
//     const factory = LocationMarkerDataStreamFactory();
//     _positionStream =
//         factory.fromGeolocatorPositionStream().asBroadcastStream();
//     _headingStream = factory.fromCompassHeadingStream().asBroadcastStream();
//   }

//   void _addMarker(LatLng latLng) {
//     setState(() {
//       _markers.add(
//         Marker(
//             width: 80.0,
//             height: 80.0,
//             point: latLng,
//             child: const Icon(Icons.location_on, color: Colors.red)),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Default Stream Example'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: FlutterMap(
//               mapController: _mapController,
//               options: const MapOptions(
//                 initialCenter: LatLng(0, 0),
//                 initialZoom: 1,
//                 minZoom: 0,
//                 maxZoom: 30,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
//                   subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
//                   userAgentPackageName:
//                       'net.tlserver6y.flutter_map_location_marker.example',
//                   /*  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName:
//                       'net.tlserver6y.flutter_map_location_marker.example',
//                   maxZoom: 30, */
//                 ),
//                  MarkerLayer(
//                   markers: _markers, // Display markers on the map
//                 ),
//                 CurrentLocationLayer(
//                   positionStream: _positionStream,
//                   headingStream: _headingStream,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: ElevatedButton(
//         onPressed: () {
//           // Add a marker at the current position
//           _positionStream?.first.then((position) {
//             if (position != null) {
//               _addMarker(LatLng(position.latitude, position.longitude));
//             }
//           
   // AppLogger().logDebug("Position: ${position?.latitude}, ${position?.longitude}}");

// AppLogger().logDebug("Position: ${position?.latitude}, ${position?.longitude}}");
//           });
//         },
//         child: const Text('Add Marker'),
//       ),
//     );
//   }
// }
