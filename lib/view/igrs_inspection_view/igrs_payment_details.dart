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
import 'package:lrsofficer/view_model/igrs_inspection/igrs_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_payment_details_view_model.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IGRSPaymentDetails extends StatefulWidget {
  const IGRSPaymentDetails({super.key});

  @override
  State<IGRSPaymentDetails> createState() => _IGRSPaymentDetailsState();
}

class _IGRSPaymentDetailsState extends State<IGRSPaymentDetails> {
  TextEditingController basicRegularCharges = TextEditingController();
  TextEditingController openSpaceCharges = TextEditingController();
  TextEditingController trc = TextEditingController();
  TextEditingController rebate = TextEditingController();
  TextEditingController amountPaid = TextEditingController();
  TextEditingController mv = TextEditingController();
  TextEditingController mvDateOfRegstn = TextEditingController();

  bool mvEditable = false;
  String totalAmount = '';
  bool chargesFlag = false;
  String mvText = "";
  String mvDateOfRegstnText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final paymentDetailsprovider =
          Provider.of<FifpPaymentDetailsViewModel>(context, listen: false);
      paymentDetailsprovider.setchargesFlag(false);
      //paymentDetailsprovider.resetCheckbox();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!kReleaseMode) {
        debugPrint("CheckBoxVal:: ${paymentDetailsprovider.isChecked}");
      }
      final mvCheckboxFlag = prefs.getBool(SharedPrefConstants.marketValueFlag);
      if (!kReleaseMode) {
        debugPrint("CheckboxVal From SharedPrefs:: $mvCheckboxFlag");
      }
      paymentDetailsprovider.onChangeOfCheckBox(mvCheckboxFlag ?? false);
      if (!kReleaseMode) {
        debugPrint("CheckBoxVal After:: ${paymentDetailsprovider.isChecked}");
      }

      if (paymentDetailsprovider.isChecked ?? false) {
        final editedMv = prefs.getString(SharedPrefConstants.editedMv);
        final editedMvDateOfRegstn =
            prefs.getString(SharedPrefConstants.editedMvDateOfRegstn);
        final editedPlotAreaExtent =
            prefs.getString(SharedPrefConstants.editedPlotAreaExtent);
        final editedRoadAffectedArea =
            prefs.getString(SharedPrefConstants.editedRoadAffectedArea);
        final editedNetPlotArea =
            prefs.getString(SharedPrefConstants.editedNetPlotArea);
        paymentDetailsprovider.editedMv.text = editedMv ?? "";
        paymentDetailsprovider.editedMvDateOfRegstn.text =
            editedMvDateOfRegstn ?? "";
        paymentDetailsprovider.plotAreaExtent.text = editedPlotAreaExtent ?? "";
        paymentDetailsprovider.roadEffectedArea.text =
            editedRoadAffectedArea ?? "";
        paymentDetailsprovider.netPlotArea.text = editedNetPlotArea ?? "";
      }
      mv.text = prefs.getString(SharedPrefConstants.mvRate2020Key) ?? "";
      mvDateOfRegstn.text =
          prefs.getString(SharedPrefConstants.mvRateDocumentKey) ?? "";

      //
      basicRegularCharges.text =
          prefs.getString(SharedPrefConstants.rcKey) ?? "";

      openSpaceCharges.text =
          prefs.getString(SharedPrefConstants.plotOpenspaceKey) ?? "";
      trc.text = prefs.getString(SharedPrefConstants.trcKey) ?? "";
      rebate.text = prefs.getString(SharedPrefConstants.rebate) ?? "";
      amountPaid.text = prefs.getString(SharedPrefConstants.amountPaid) ?? "";

      mvEditable =
          ((prefs.getString(SharedPrefConstants.mvEditFlagKey) ?? "") == "true")
              ? true
              : false;
      if (!kReleaseMode) debugPrint("mvFlag::  $mvEditable");
      setState(() {
        mvText = mv.text;
        mvDateOfRegstnText = mvDateOfRegstn.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentDetailsprovider =
        Provider.of<IGRSPaymentDetailsViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context);
          paymentDetailsprovider.resetCheckbox();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
              title: "IGRS Payment Details",
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  paymentDetailsprovider.resetCheckbox();
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
                              nameController: mv,
                              isReadOnly: /* mvEditable ? false :  */ true,
                              length: 10,
                              onEditingComplete: () {
                                paymentDetailsprovider.setchargesFlag(false);
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (p0) {
                                paymentDetailsprovider.setchargesFlag(false);
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
                              nameController: mvDateOfRegstn,
                              isReadOnly: /* mvEditable ? false : */ true,
                              onEditingComplete: () {
                                paymentDetailsprovider.setchargesFlag(false);
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (p0) {
                                paymentDetailsprovider.setchargesFlag(false);
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
                              nameController: basicRegularCharges,
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
                              nameController: openSpaceCharges,
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
                              nameController: trc,
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
                              nameController: rebate,
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
                              nameController: amountPaid,
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
                                  value:
                                      paymentDetailsprovider.isChecked ?? false,
                                  onChanged: (bool? value) {
                                    paymentDetailsprovider
                                        .onChangeOfCheckBox(value);
                                  },
                                ),
                                Text(
                                    'Would you like to  update the market value?'),
                              ],
                            ),
                            if (paymentDetailsprovider.isChecked ?? false)
                              Column(
                                children: [
                                  AppInputTextfield(
                                    hintText: "MV as on 26.08.2020 *",
                                    length: 10,
                                    nameController:
                                        paymentDetailsprovider.editedMv,

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
                                    nameController: paymentDetailsprovider
                                        .editedMvDateOfRegstn,
                                    // onChanged: (p0) {
                                    //   if (!kReleaseMode) debugPrint(
                                    //       "::::${paymentDetailsprovider.editedMvDateOfRegstn.text}");
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
                                        paymentDetailsprovider.plotAreaExtent,
                                    inputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (p0) {
                                      num plotArea = num.tryParse(p0) ?? 0;
                                      num roadEffectedArea = num.tryParse(
                                              paymentDetailsprovider
                                                  .roadEffectedArea.text) ??
                                          0;
                                      if (roadEffectedArea < plotArea) {
                                        if (plotArea - roadEffectedArea > 0) {
                                          num netplotArea =
                                              plotArea - roadEffectedArea;
                                          paymentDetailsprovider.netPlotArea
                                              .text = "$netplotArea";
                                        } else {
                                          paymentDetailsprovider.plotAreaExtent
                                              .clear();
                                          paymentDetailsprovider.netPlotArea
                                              .clear();
                                          FocusScope.of(context).unfocus();
                                        }
                                      } else {
                                        paymentDetailsprovider.roadEffectedArea
                                            .clear();
                                        paymentDetailsprovider.netPlotArea
                                            .clear();
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
                                        paymentDetailsprovider.roadEffectedArea,
                                    inputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (value) async {
                                      num plotArea = num.tryParse(
                                              paymentDetailsprovider
                                                  .plotAreaExtent.text) ??
                                          0;
                                      num roadEffectedArea =
                                          num.tryParse(value) ?? 0;

                                      if (plotArea > 0) {
                                        if (plotArea - roadEffectedArea > 0) {
                                          num netplotArea =
                                              plotArea - roadEffectedArea;
                                          paymentDetailsprovider
                                                  .netPlotArea.text =
                                              netplotArea.toStringAsFixed(2);
                                        } else {
                                          paymentDetailsprovider
                                              .roadEffectedArea
                                              .clear();
                                          paymentDetailsprovider.netPlotArea
                                              .clear();
                                          FocusScope.of(context).unfocus();
                                          ValidationIoSAlert().showAlert(
                                              context,
                                              description:
                                                  "Road Effected Area should be less than Plot Area");
                                        }
                                      } else {
                                        paymentDetailsprovider.roadEffectedArea
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
                                    nameController:
                                        paymentDetailsprovider.netPlotArea,
                                  ),
                                ],
                              ),
                            Row(
                              children: [
                                Visibility(
                                  visible: !(paymentDetailsprovider
                                          .getchargesFlag ||
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
                                          if (paymentDetailsprovider
                                                  .isChecked ??
                                              false) {
                                            await prefs.setString(
                                                SharedPrefConstants.editedMv,
                                                paymentDetailsprovider
                                                    .editedMv.text);
                                            await prefs.setString(
                                                SharedPrefConstants
                                                    .editedMvDateOfRegstn,
                                                paymentDetailsprovider
                                                    .editedMvDateOfRegstn.text);

                                            //
                                            await prefs.setString(
                                                SharedPrefConstants
                                                    .editedPlotAreaExtent,
                                                paymentDetailsprovider
                                                    .plotAreaExtent.text);
                                            await prefs.setString(
                                                SharedPrefConstants
                                                    .editedNetPlotArea,
                                                paymentDetailsprovider
                                                    .netPlotArea.text);
                                            await prefs.setString(
                                                SharedPrefConstants
                                                    .editedRoadAffectedArea,
                                                paymentDetailsprovider
                                                    .roadEffectedArea.text);
                                          }
                                          if (!context.mounted) return;
                                          paymentDetailsprovider
                                              .navigateToRecommendations(
                                            "",
                                            mv.text,
                                            mvDateOfRegstn.text,
                                            paymentDetailsprovider
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
                              visible: paymentDetailsprovider.getchargesFlag,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  rowComponent(
                                      "Regulation Charges",
                                      paymentDetailsprovider
                                          .clusterCalulationDetails?[0]
                                          .regCharges),
                                  rowComponent(
                                      "14% Open Space Charges",
                                      paymentDetailsprovider
                                          .clusterCalulationDetails?[0]
                                          .openSpaceCharges),
                                  rowComponent(
                                      "Total Regulation Charges",
                                      paymentDetailsprovider
                                          .clusterCalulationDetails?[0]
                                          .totalRegCharges),
                                  rowComponent(
                                      "Initial Amount Paid",
                                      paymentDetailsprovider
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
                                        text: (totalAmount),
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
      
                                      paymentDetailsprovider.navigateToRecommendations(
                                        conversionCharges.text,
                                        mv.text,
                                        mvDateOfRegstn.text,
                                        paymentDetailsprovider.clusterCalulationDetails?[0],
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
          if (paymentDetailsprovider.getLoaderVisibilityStatus)
            const LoaderComponent()
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
