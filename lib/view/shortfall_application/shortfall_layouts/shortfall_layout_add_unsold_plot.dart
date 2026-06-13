import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/warning_alert_with_two_buttons.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_text.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_layout_app_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortfallAddUnsoldPlotDetails extends StatefulWidget {
  const ShortfallAddUnsoldPlotDetails({super.key});

  @override
  State<ShortfallAddUnsoldPlotDetails> createState() =>
      _ShortfallAddUnsoldPlotDetailsState();
}

class _ShortfallAddUnsoldPlotDetailsState
    extends State<ShortfallAddUnsoldPlotDetails> {
  @override
  void initState() {
    super.initState();
    final layoutClusterwiseApplDetailsProvider =
        Provider.of<ShortfallLayoutApplicationDetailsViewModel>(context,
            listen: false);
    layoutClusterwiseApplDetailsProvider.plotDetailsList.clear();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final list = prefs.getString(SharedPrefConstants.unsoldPlotListKey);
        List<UnSoldPlots> finalUnsoldPlotsList = [];
        if (list != null && list != "") {
          final List<dynamic> unsoldListJson = jsonDecode(list);
          finalUnsoldPlotsList =
              unsoldListJson.map((item) => UnSoldPlots.fromJson(item)).toList();
        }
        layoutClusterwiseApplDetailsProvider.plotDetailsList
            .addAll(finalUnsoldPlotsList);
        setState(() {});
      },
    );
    AppLogger().logDebug(
        "initstate length ::: ${layoutClusterwiseApplDetailsProvider.plotDetailsList.length}");
  }

  @override
  Widget build(BuildContext context) {
    final layoutClusterwiseApplDetailsProvider =
        Provider.of<ShortfallLayoutApplicationDetailsViewModel>(context);

    // Parsing the number of unsold plots
    int unsoldPlotsCount = int.tryParse(
            layoutClusterwiseApplDetailsProvider.unsoldPlotsController.text) ??
        0;
    if (!kReleaseMode) debugPrint("unsold Length:: $unsoldPlotsCount");
    if (!kReleaseMode) {
      debugPrint(
          "list:: ${layoutClusterwiseApplDetailsProvider.plotDetailsList.length}");
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          WarningCustomCupertinoAlertTwoButtons().showAlert(
            context,
            message:
                "Data of the Application ID : ${layoutClusterwiseApplDetailsProvider.clusterApplDetails[0].aPPLICATIONID} will be lost. Do you want to continue? ",
            onPressedOk: () {
              layoutClusterwiseApplDetailsProvider.plotDetailsList.clear();
              Navigator.popUntil(
                context,
                ModalRoute.withName(
                    AppRoutes.shortfallLayoutApplicationDetails),
              );
            },
            onPressedCancel: () {
              Navigator.pop(context);
            },
          );
        }
      },
      child: Scaffold(
        appBar: const AppBarReusable(
          title: "Unsold Plots List",
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
                    (!(layoutClusterwiseApplDetailsProvider
                                .plotDetailsList.length ==
                            unsoldPlotsCount))
                        ? Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 10.0),
                                    child: AppInputText(
                                        textAlign: TextAlign.start,
                                        text:
                                            "Total Unsold Plots: $unsoldPlotsCount"),
                                  ),
                                ),
                                AppInputTextfield(
                                  hintText: "Plot No",
                                  nameController:
                                      layoutClusterwiseApplDetailsProvider
                                          .plotNoController,
                                ),
                                AppInputTextfield(
                                  hintText: "Plot Area Extent",
                                  nameController:
                                      layoutClusterwiseApplDetailsProvider
                                          .plotAreaExtentController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d{0,4}'),
                                    ),
                                  ],
                                  inputType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  length: 10,
                                ),
                                ReusableButton(
                                  buttonText: 'Add',
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (layoutClusterwiseApplDetailsProvider
                                        .plotNoController.text
                                        .trim()
                                        .isEmpty) {
                                      ValidationIoSAlert().showAlert(context,
                                          description: "Please enter plot no");
                                    } else if (layoutClusterwiseApplDetailsProvider
                                        .plotAreaExtentController
                                        .text
                                        .isEmpty) {
                                      ValidationIoSAlert().showAlert(context,
                                          description:
                                              "Please enter plot area extent");
                                    } else {
                                      if (layoutClusterwiseApplDetailsProvider
                                              .plotDetailsList.length <=
                                          unsoldPlotsCount) {
                                        layoutClusterwiseApplDetailsProvider
                                            .addPlotDetails();
                                      }
                                      layoutClusterwiseApplDetailsProvider
                                          .plotAreaExtentController.text = '';
                                      layoutClusterwiseApplDetailsProvider
                                          .plotNoController.text = '';
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    // Only show the list if there are unsold plots
                    unsoldPlotsCount != 0
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: layoutClusterwiseApplDetailsProvider
                                  .plotDetailsList.length,
                              itemBuilder: (context, index) {
                                if (index >=
                                    layoutClusterwiseApplDetailsProvider
                                        .plotDetailsList.length) {
                                  return Container(); // Return an empty container if the index exceeds the list length
                                }

                                final details =
                                    layoutClusterwiseApplDetailsProvider
                                        .plotDetailsList[index];
                                return Card(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6.0),
                                              child: buildLabelValueRow(
                                                "Plot No",
                                                "${details.plotNo}",
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6.0),
                                              child: buildLabelValueRow(
                                                  "Plot Area Extent",
                                                  "${details.plotAreaExtent}"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          onPressed: () {
                                            layoutClusterwiseApplDetailsProvider
                                                .removePlotDetails(index);
                                          },
                                          icon: const Icon(Icons.remove_circle),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ReusableButton(
                        buttonText: 'Next',
                        onPressed: () {
                          if (!kReleaseMode) {
                            debugPrint(
                                "length list ::: ${layoutClusterwiseApplDetailsProvider.plotDetailsList.length}");
                          }
                          if (layoutClusterwiseApplDetailsProvider
                                  .plotDetailsList.length ==
                              unsoldPlotsCount) {
                            if (!kReleaseMode) debugPrint("navigating");
                            //Functionality
                            layoutClusterwiseApplDetailsProvider
                                .submitAndSave(context);
                          } else {
                            ErrorCustomCupertinoAlert().showAlert(context,
                                message:
                                    "Please add details of all unsold plots");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabelValueRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for the label
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "",
              softWrap: true, // Allows text to wrap within its bounds
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabelValueDeleteRow(
      String label, String? value, void Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value ?? "",
              softWrap: true, // Allows text to wrap within its bounds
            ),
          ),
        ],
      ),
    );
  }
}
