import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/plots_layouts/add_coordinates_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCoordinates extends StatefulWidget {
  const AddCoordinates({super.key});

  @override
  State<AddCoordinates> createState() => _AddCoordinatesState();
}

class _AddCoordinatesState extends State<AddCoordinates> {
  @override
  Widget build(BuildContext context) {
    final addCoordinatesProvider =
        Provider.of<AddCoordinatesViewModel>(context);
    /* if (!kReleaseMode) debugPrint(
        "Saved Application:: ${AppConstants.isSavedApplication}");
    if (!kReleaseMode) debugPrint(
        "Coordinates COndition:: ${addCoordinatesProvider.getAddedCoordinates.length < (int.tryParse(AppConstants.maxCoordinatesCount.isNotEmpty ? AppConstants.maxCoordinatesCount : "4") ?? 4)}");
     */
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: AppConstants.isLayoutPlot == "L"
                ? "Layout Coordinates"
                : "Plot Coordinates",
          ),
          body: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: ExactAssetImage(AppAssets.appBg),
                    ),
                  ),
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
                      if (addCoordinatesProvider.latlongsList.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: addCoordinatesProvider
                                .getAddedCoordinates.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Location Icon with Index Number
                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10.0),
                                    // Latitude and Longitude Fields
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: AppInputTextfield(
                                              isReadOnly: true,
                                              hintText: "latitude".tr(),
                                              nameController:
                                                  TextEditingController(
                                                text:
                                                    "${addCoordinatesProvider.getAddedCoordinates[index].latitude}",
                                              ),
                                              textColor: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 5.0),
                                          Expanded(
                                            child: AppInputTextfield(
                                              isReadOnly: true,
                                              hintText: "longitude".tr(),
                                              nameController:
                                                  TextEditingController(
                                                text:
                                                    "${addCoordinatesProvider.getAddedCoordinates[index].longitude}",
                                              ),
                                              textColor: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Remove Button at the Right End
                                    if (AppConstants.isSavedApplication !=
                                        "yes")
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red),
                                        onPressed: () {
                                          // Add your remove logic here
                                          addCoordinatesProvider.onRemove(
                                              context, index);
                                        },
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      if (addCoordinatesProvider.getAddedCoordinates.length <
                          (int.tryParse(
                                  AppConstants.maxCoordinatesCount.isNotEmpty
                                      ? AppConstants.maxCoordinatesCount
                                      : "4") ??
                              4))
                        Visibility(
                          visible: (AppConstants.isSavedApplication != "yes"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    AppColors.themeColor,
                                  ),
                                ),
                                onPressed: () async {
                                  await addCoordinatesProvider
                                      .onAddCoordinateClick(context);
                                },
                                icon: const Icon(
                                  Icons.add_location_alt_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                label: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Add Coordinates',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              addCoordinatesProvider.getAddedCoordinates.length >=
                      (int.tryParse(AppConstants.minCoordinatesCount.isNotEmpty
                              ? AppConstants.minCoordinatesCount
                              : "1") ??
                          1)
                  ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ReusableButton(
                          buttonText: "Next".tr(),
                          onPressed: () {
                            addCoordinatesProvider.onNextClick(context);
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
        ),
        if (addCoordinatesProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
      ],
    );
  }

  @override
  initState() {
    super.initState();
    final addCoordinatesProvider =
        Provider.of<AddCoordinatesViewModel>(context, listen: false);
   // addCoordinatesProvider.latlongsList.clear();
    if (!kReleaseMode) {
      debugPrint(
          "Min Coordinates Count :: ${AppConstants.minCoordinatesCount}");
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (addCoordinatesProvider.latlongsList.isEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final latlngStrings =
              prefs.getString(SharedPrefConstants.gisCoordinatesList);
          if (latlngStrings != null && latlngStrings != "") {
            List<List<double>> decodedCoordinates =
                decodeCoordinates(latlngStrings);
            if (!kReleaseMode) {
              debugPrint('Decoded Coordinates: $decodedCoordinates');
            }
            List<LatLng> latLngList = convertToLatLngList(decodedCoordinates);
            addCoordinatesProvider.addSavedLatlngs(latLngList);
          }
        }
      },
    );
  }

  List<List<double>> decodeCoordinates(String jsonString) {
    // Decoding the JSON string back to a Dart object (list of lists)
    List<dynamic> decodedJson = jsonDecode(jsonString);
    List<List<double>> coordinates = decodedJson.map((coordinate) {
      List<dynamic> latLng = coordinate;
      return [latLng[0] as double, latLng[1] as double];
    }).toList();

    return coordinates;
  }

  // Function to convert List<List<double>> to List<LatLng>
  List<LatLng> convertToLatLngList(List<List<double>> coordinates) {
    return coordinates.map((latLng) {
      return LatLng(latLng[1],
          latLng[0]); // Notice the order: LatLng(latitude, longitude)
    }).toList();
  }
}
