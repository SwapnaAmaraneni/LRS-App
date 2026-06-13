import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_text.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_payment_details_view_model.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeePaidPaymentDetails extends StatefulWidget {
  const FeePaidPaymentDetails({super.key});

  @override
  State<FeePaidPaymentDetails> createState() => _FeePaidPaymentDetailsState();
}

class _FeePaidPaymentDetailsState extends State<FeePaidPaymentDetails> {
  bool mvEditable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final feePaidProvider =
          Provider.of<FifpPaymentDetailsViewModel>(context, listen: false);
      feePaidProvider.setchargesFlag(false);
      //feePaidProvider.resetCheckbox();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!kReleaseMode) {
        debugPrint("CheckBoxVal:: ${feePaidProvider.isChecked}");
      }
      final mvCheckboxFlag = prefs.getBool(SharedPrefConstants.marketValueFlag);
      if (!kReleaseMode) {
        debugPrint("CheckboxVal From SharedPrefs:: $mvCheckboxFlag");
      }
      feePaidProvider.onChangeOfCheckBox(mvCheckboxFlag ?? false);
      if (!kReleaseMode) {
        debugPrint("CheckBoxVal After:: ${feePaidProvider.isChecked}");
      }

      if (feePaidProvider.isChecked ?? false) {
        final editedMv = prefs.getString(SharedPrefConstants.editedMv);
        final editedMvDateOfRegstn =
            prefs.getString(SharedPrefConstants.editedMvDateOfRegstn);
        final editedPlotAreaExtent =
            prefs.getString(SharedPrefConstants.editedPlotAreaExtent);
        final editedRoadAffectedArea =
            prefs.getString(SharedPrefConstants.editedRoadAffectedArea);
        final editedNetPlotArea =
            prefs.getString(SharedPrefConstants.editedNetPlotArea);
        feePaidProvider.editedMv.text = feePaidProvider.editedMv.text.isNotEmpty
            ? feePaidProvider.editedMv.text
            : editedMv ?? "";
        feePaidProvider.editedMvDateOfRegstn.text =
            feePaidProvider.editedMvDateOfRegstn.text.isNotEmpty
                ? feePaidProvider.editedMvDateOfRegstn.text
                : editedMvDateOfRegstn ?? "";
        feePaidProvider.plotAreaExtent.text =
            feePaidProvider.plotAreaExtent.text.isNotEmpty
                ? feePaidProvider.plotAreaExtent.text
                : editedPlotAreaExtent ?? "";
        feePaidProvider.roadEffectedArea.text =
            feePaidProvider.roadEffectedArea.text.isNotEmpty
                ? feePaidProvider.roadEffectedArea.text
                : editedRoadAffectedArea ?? "";
        feePaidProvider.netPlotArea.text =
            feePaidProvider.netPlotArea.text.isNotEmpty
                ? feePaidProvider.netPlotArea.text
                : editedNetPlotArea ?? "";
      }
      feePaidProvider.mv.text = feePaidProvider.mv.text.isNotEmpty
          ? feePaidProvider.mv.text
          : prefs.getString(SharedPrefConstants.mvRate2020Key) ?? "";
      feePaidProvider.mvDateOfRegstn.text =
          feePaidProvider.mvDateOfRegstn.text.isNotEmpty
              ? feePaidProvider.mvDateOfRegstn.text
              : prefs.getString(SharedPrefConstants.mvRateDocumentKey) ?? "";

      //
      feePaidProvider.basicRegularCharges.text =
          feePaidProvider.basicRegularCharges.text.isNotEmpty
              ? feePaidProvider.basicRegularCharges.text
              : prefs.getString(SharedPrefConstants.rcKey) ?? "";

      feePaidProvider.openSpaceCharges.text =
          feePaidProvider.openSpaceCharges.text.isNotEmpty
              ? feePaidProvider.openSpaceCharges.text
              : prefs.getString(SharedPrefConstants.plotOpenspaceKey) ?? "";
      feePaidProvider.trc.text = feePaidProvider.trc.text.isNotEmpty
          ? feePaidProvider.trc.text
          : prefs.getString(SharedPrefConstants.trcKey) ?? "";
      feePaidProvider.rebate.text = feePaidProvider.rebate.text.isNotEmpty
          ? feePaidProvider.rebate.text
          : prefs.getString(SharedPrefConstants.rebate) ?? "";
      feePaidProvider.amountPaid.text =
          feePaidProvider.amountPaid.text.isNotEmpty
              ? feePaidProvider.amountPaid.text
              : prefs.getString(SharedPrefConstants.amountPaid) ?? "";

      mvEditable =
          ((prefs.getString(SharedPrefConstants.mvEditFlagKey) ?? "") == "true")
              ? true
              : false;
      if (!kReleaseMode) debugPrint("mvFlag::  $mvEditable");
      setState(() {
        feePaidProvider.mvText = feePaidProvider.mv.text;
        feePaidProvider.mvDateOfRegstnText =
            feePaidProvider.mvDateOfRegstn.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final feePaidProvider = Provider.of<FifpPaymentDetailsViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context);
          //feePaidProvider.resetCheckbox();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
              title: "Fee Paid Payment Details",
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  //feePaidProvider.resetCheckbox();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: ExactAssetImage(AppAssets.appBg),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          children: [
                            getTitleCard("Fee Paid Payment Details"),
                            AppInputTextfield(
                              hintText: "MV as on 26.08.2020 *",
                              nameController: feePaidProvider.mv,
                              isReadOnly: /* mvEditable ? false :  */ true,
                              length: 10,
                              onEditingComplete: () {
                                feePaidProvider.setchargesFlag(false);
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (p0) {
                                feePaidProvider.setchargesFlag(false);
                              },
                              inputType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[1-9]\d*\.?\d{0,2}')),
                              ],
                            ),
                            AppInputTextfield(
                              length: 10,
                              hintText: "MV as on date of registration *",
                              nameController: feePaidProvider.mvDateOfRegstn,
                              isReadOnly: /* mvEditable ? false : */ true,
                              onEditingComplete: () {
                                feePaidProvider.setchargesFlag(false);
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (p0) {
                                feePaidProvider.setchargesFlag(false);
                              },
                              inputType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[1-9]\d*\.?\d{0,2}')),
                              ],
                            ),
                            AppInputTextfield(
                              hintText: "Basic Regular Charges",
                              nameController:
                                  feePaidProvider.basicRegularCharges,
                              isReadOnly: true,
                              inputType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                            ),
                            AppInputTextfield(
                              hintText: "Open Space Charges",
                              nameController: feePaidProvider.openSpaceCharges,
                              // length: 10,

                              inputType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              isReadOnly: true,
                            ),
                            AppInputTextfield(
                              hintText: "TRC",
                              nameController: feePaidProvider.trc,
                              // length: 10,

                              inputType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              isReadOnly: true,
                            ),
                            AppInputTextfield(
                              hintText: "Rebate",
                              nameController: feePaidProvider.rebate,
                              isReadOnly: true,
                              inputType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                            ),
                            AppInputTextfield(
                              hintText: "Amount Paid",
                              nameController: feePaidProvider.amountPaid,
                              isReadOnly: true,
                              // length: 10,

                              inputType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: feePaidProvider.isChecked ?? false,
                                  onChanged: (bool? value) {
                                    feePaidProvider.onChangeOfCheckBox(value);
                                  },
                                ),
                                Text(
                                    'Would you like to  update the market value?'),
                              ],
                            ),
                            if (feePaidProvider.isChecked ?? false)
                              Column(
                                children: [
                                  AppInputTextfield(
                                    hintText: "MV as on 26.08.2020 *",
                                    length: 10,
                                    nameController: feePaidProvider.editedMv,

                                    // length: 10,

                                    inputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                  ),
                                  AppInputTextfield(
                                    hintText: "MV as on date of registration *",
                                    length: 10,
                                    nameController:
                                        feePaidProvider.editedMvDateOfRegstn,
                                    // onChanged: (p0) {
                                    //   if (!kReleaseMode) debugPrint(
                                    //       "::::${feePaidProvider.editedMvDateOfRegstn.text}");
                                    // },

                                    // length: 10,

                                    inputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                  ),
                                  AppInputTextfield(
                                    textColor: Colors.black,
                                    length: 10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    hintText:
                                        "Plot Area Extent Sq.Yards(As on Ground)*",
                                    nameController:
                                        feePaidProvider.plotAreaExtent,
                                    inputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (p0) {
                                      num plotArea = num.tryParse(p0) ?? 0;
                                      num roadEffectedArea = num.tryParse(
                                              feePaidProvider
                                                  .roadEffectedArea.text) ??
                                          0;
                                      if (roadEffectedArea < plotArea) {
                                        if (plotArea - roadEffectedArea > 0) {
                                          num netplotArea =
                                              plotArea - roadEffectedArea;
                                          feePaidProvider.netPlotArea.text =
                                              "$netplotArea";
                                        } else {
                                          feePaidProvider.plotAreaExtent
                                              .clear();
                                          feePaidProvider.netPlotArea.clear();
                                          FocusScope.of(context).unfocus();
                                        }
                                      } else {
                                        feePaidProvider.roadEffectedArea
                                            .clear();
                                        feePaidProvider.netPlotArea.clear();
                                        FocusScope.of(context).unfocus();
                                        ValidationIoSAlert().showAlert(context,
                                            description:
                                                "Plot Area cannot be less than road effected area");
                                      }
                                    },
                                  ),
                                  AppInputTextfield(
                                    textColor: Colors.black,
                                    length: 10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    hintText:
                                        "Road Effected Area Extent Sq.Yards*",
                                    nameController:
                                        feePaidProvider.roadEffectedArea,
                                    inputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (value) async {
                                      num plotArea = num.tryParse(
                                              feePaidProvider
                                                  .plotAreaExtent.text) ??
                                          0;
                                      num roadEffectedArea =
                                          num.tryParse(value) ?? 0;

                                      if (plotArea > 0) {
                                        if (plotArea - roadEffectedArea > 0) {
                                          num netplotArea =
                                              plotArea - roadEffectedArea;
                                          feePaidProvider.netPlotArea.text =
                                              netplotArea.toStringAsFixed(2);
                                        } else {
                                          feePaidProvider.roadEffectedArea
                                              .clear();
                                          feePaidProvider.netPlotArea.clear();
                                          FocusScope.of(context).unfocus();
                                          ValidationIoSAlert().showAlert(
                                              context,
                                              description:
                                                  "Road Effected Area should be less than Plot Area");
                                        }
                                      } else {
                                        feePaidProvider.roadEffectedArea
                                            .clear();
                                        FocusScope.of(context).unfocus();
                                        ValidationIoSAlert().showAlert(context,
                                            description:
                                                "Please Enter Plot Area");
                                      }
                                    },
                                  ),
                                  AppInputTextfield(
                                    isReadOnly:
                                        true /* AppConstants.userType != "tp" */,
                                    textColor: Colors.black,
                                    hintText: "Net plot Area Extent Sq.Yards",
                                    nameController: feePaidProvider.netPlotArea,
                                  ),
                                ],
                              ),
                            Row(
                              children: [
                                Visibility(
                                  visible: !(feePaidProvider.getchargesFlag ||
                                      AppConstants.isSavedApplication == "yes"),
                                  child: Flexible(
                                    flex: 2,
                                    child: Center(
                                      child: ReusableButton(
                                        buttonText: "Next",
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.setBool(
                                              SharedPrefConstants.isCalculate,
                                              false);
                                          if (feePaidProvider.isChecked ??
                                              false) {
                                            await prefs.setString(
                                                SharedPrefConstants.editedMv,
                                                feePaidProvider.editedMv.text);
                                            await prefs.setString(
                                                SharedPrefConstants
                                                    .editedMvDateOfRegstn,
                                                feePaidProvider
                                                    .editedMvDateOfRegstn.text);

                                            //
                                            await prefs.setString(
                                                SharedPrefConstants
                                                    .editedPlotAreaExtent,
                                                feePaidProvider
                                                    .plotAreaExtent.text);
                                            await prefs.setString(
                                                SharedPrefConstants
                                                    .editedNetPlotArea,
                                                feePaidProvider
                                                    .netPlotArea.text);
                                            await prefs.setString(
                                                SharedPrefConstants
                                                    .editedRoadAffectedArea,
                                                feePaidProvider
                                                    .roadEffectedArea.text);
                                          }
                                          if (!context.mounted) return;
                                          feePaidProvider
                                              .navigateToRecommendations(
                                            "",
                                            feePaidProvider.mv.text,
                                            feePaidProvider.mvDateOfRegstn.text,
                                            feePaidProvider
                                                .clusterCalulationDetails?[0],
                                            context,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Visibility(
                              visible: feePaidProvider.getchargesFlag,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  rowComponent(
                                      "Regulation Charges",
                                      feePaidProvider
                                          .clusterCalulationDetails?[0]
                                          .regCharges),
                                  rowComponent(
                                      "14% Open Space Charges",
                                      feePaidProvider
                                          .clusterCalulationDetails?[0]
                                          .openSpaceCharges),
                                  rowComponent(
                                      "Total Regulation Charges",
                                      feePaidProvider
                                          .clusterCalulationDetails?[0]
                                          .totalRegCharges),
                                  rowComponent(
                                      "Initial Amount Paid",
                                      feePaidProvider
                                          .clusterCalulationDetails?[0]
                                          .intitalAmount),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const AppInputText(
                                        text: "Amount to be paid: Rs. ",
                                        color:
                                            Color.fromARGB(255, 14, 131, 146),
                                        fontweight: FontWeight.bold,
                                        fontsize: 20,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      AppInputText(
                                        text: (feePaidProvider.totalAmount),
                                        color: const Color.fromARGB(
                                            255, 14, 131, 146),
                                        fontweight: FontWeight.bold,
                                        fontsize: 20,
                                      ),
                                    ],
                                  ),
                                  ReusableButton(
                                    buttonText: "Next",
                                    onPressed: () async {
                                      /* SharedPreferences prefs =
                                          await SharedPreferences.getInstance(); */

                                      /*   await prefs.setBool(
                                          SharedPrefConstants.isCalculate, true);
                                      if (!context.mounted) return;
      
                                      feePaidProvider.navigateToRecommendations(
                                        conversionCharges.text,
                                        mv.text,
                                        mvDateOfRegstn.text,
                                        feePaidProvider.clusterCalulationDetails?[0],
                                        context,
                                      ); */
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (feePaidProvider.getLoaderVisibilityStatus) const LoaderComponent()
        ],
      ),
    );
  }

  Widget rowComponent(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value ?? "",
            softWrap: true, // Allows text to wrap within its bounds
          ),
        ],
      ),
    );
  }

  Widget getTitleCard(String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        elevation: 4.0,
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
