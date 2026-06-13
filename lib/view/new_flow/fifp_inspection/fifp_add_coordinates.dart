import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_add_coordinates_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FifpAddCoordinates extends StatefulWidget {
  const FifpAddCoordinates({super.key});

  @override
  State<FifpAddCoordinates> createState() => _FifpAddCoordinatesState();
}

class _FifpAddCoordinatesState extends State<FifpAddCoordinates> {
  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<FifpAddCoordinatesViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //viewModel.clearCoordinates();

      final prefs = await SharedPreferences.getInstance();
      final latlngJson =
          prefs.getString(SharedPrefConstants.gisCoordinatesList);
      if (latlngJson?.isNotEmpty ?? false) {
        final decodedCoords = _decodeCoordinates(latlngJson!);
        final latLngList = _toLatLngList(decodedCoords);
        viewModel.addSavedLatlngs(latLngList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FifpAddCoordinatesViewModel>();

    final maxCount = int.tryParse(AppConstants.maxCoordinatesCount.isNotEmpty
            ? AppConstants.maxCoordinatesCount
            : "4") ??
        4;
    final minCount = int.tryParse(AppConstants.minCoordinatesCount.isNotEmpty
            ? AppConstants.minCoordinatesCount
            : "1") ??
        1;

    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(title: "Fee Paid Add Coordinates"),
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
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
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Please capture geo coordinates in clock wise direction only(i.e East ->West ->South -> North)",
                      style: TextStyle(
                        color: Color.fromARGB(255, 153, 27, 15),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (vm.getAddedCoordinates.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.getAddedCoordinates.length,
                        itemBuilder: (context, index) {
                          final coord = vm.getAddedCoordinates[index];
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        color: Colors.red, size: 40),
                                    Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AppInputTextfield(
                                          isReadOnly: true,
                                          hintText: "latitude".tr(),
                                          nameController: TextEditingController(
                                              text: '${coord.latitude}'),
                                          textColor: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: AppInputTextfield(
                                          isReadOnly: true,
                                          hintText: "longitude".tr(),
                                          nameController: TextEditingController(
                                              text: '${coord.longitude}'),
                                          textColor: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (AppConstants.isSavedApplication != "yes")
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red),
                                    onPressed: () =>
                                        vm.onRemove(context, index),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (vm.getAddedCoordinates.length < maxCount &&
                      AppConstants.isSavedApplication != "yes")
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.themeColor),
                          onPressed: () async =>
                              vm.onAddCoordinateClick(context),
                          icon: const Icon(Icons.add_location_alt_outlined,
                              color: Colors.white, size: 30),
                          label: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Add Coordinates',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: vm.getAddedCoordinates.length >= minCount
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ReusableButton(
                      buttonText: "Next".tr(),
                      onPressed: () => vm.onNextClick(context),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        if (vm.getLoaderVisibilityStatus) const LoaderComponent(),
      ],
    );
  }

  // 🔹 Helper methods — purely logic, not UI-affecting
  List<List<double>> _decodeCoordinates(String jsonString) {
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((e) => (e as List).map((v) => v as double).toList())
        .cast<List<double>>()
        .toList();
  }

  List<LatLng> _toLatLngList(List<List<double>> coords) =>
      coords.map((e) => LatLng(e[1], e[0])).toList();
}
