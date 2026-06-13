/* import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view/map_widget.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await captureGeoCoordinatesProvider.getCurrentPosition(context);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final captureGeoCoordinatesProvider =
        Provider.of<CaptureGeoCoordinatesViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              String list = await LocalStoreHelper()
                  .readTheData(SharedPrefConstants.savedLatlangList);

              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapWidget(
                          latitude: captureGeoCoordinatesProvider
                                  .currentPosition?.latitude ??
                              0,
                          longitude: captureGeoCoordinatesProvider
                                  .currentPosition?.longitude ??
                              0,
                          callbackValue: (uint8List) {

                          },
                        )),
              );
            },
            child: const Text("View on Map")),
      ),
      /*  floatingActionButton: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapWidget(
                        latitude: captureGeoCoordinatesProvider
                                .currentPosition?.latitude ??
                            0,
                        longitude: captureGeoCoordinatesProvider
                                .currentPosition?.longitude ??
                            0,
                      )),
            );
          },
          icon: const Icon(Icons.add)), */
    );
  }
}
 */