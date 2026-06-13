import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class FifpPaymentDetails extends StatefulWidget {
  const FifpPaymentDetails({super.key});

  @override
  State<FifpPaymentDetails> createState() => _FifpPaymentDetailsState();
}

class _FifpPaymentDetailsState extends State<FifpPaymentDetails> {
  
  bool mvEditable = false;
  bool chargesFlag = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final fifpProvider =
          Provider.of<FifpPaymentDetailsViewModel>(context, listen: false);
      fifpProvider.setchargesFlag(false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      fifpProvider.mv.text = fifpProvider.mv.text.isNotEmpty ? fifpProvider.mv.text : prefs.getString(SharedPrefConstants.mvRate2020Key) ?? "";
      fifpProvider.mvDateOfRegstn.text =fifpProvider.mvDateOfRegstn.text.isNotEmpty ? fifpProvider.mvDateOfRegstn.text : prefs.getString(SharedPrefConstants.mvRateDocumentKey) ?? "";
      fifpProvider.conversionCharges.text =fifpProvider.conversionCharges.text.isNotEmpty ? fifpProvider.conversionCharges.text : prefs.getString(SharedPrefConstants.conversionChargesKey) ?? "";
      mvEditable =
          ((prefs.getString(SharedPrefConstants.mvEditFlagKey) ?? "") == "true")
              ? true
              : false;
      if (!kReleaseMode) debugPrint("mvFlag::  $mvEditable");
      setState(() {
        fifpProvider.mvText = fifpProvider.mv.text;
        fifpProvider.mvDateOfRegstnText = fifpProvider.mvDateOfRegstn.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final fifpProvider = Provider.of<FifpPaymentDetailsViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "Fee Paid Payment Details",
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
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
                          getTitleCard("Payment Details"),
                          AppInputTextfield(
                            hintText: "Conversion Charges *",
                            nameController: fifpProvider.conversionCharges,
                            length: 10,
                            onEditingComplete: () {
                              fifpProvider.setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              fifpProvider.setchargesFlag(false);
                              setState(() {});
                            },
                            inputType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                          ),
                          AppInputTextfield(
                            hintText: "MV as on 26.08.2020 *",
                            nameController: fifpProvider.mv,
                            isReadOnly: mvEditable ? false : true,
                            length: 10,
                            onEditingComplete: () {
                              fifpProvider.setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              fifpProvider.setchargesFlag(false);
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
                            nameController: fifpProvider.mvDateOfRegstn,
                            isReadOnly: mvEditable ? false : true,
                            onEditingComplete: () {
                              fifpProvider.setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              fifpProvider.setchargesFlag(false);
                            },
                            inputType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[1-9]\d*\.?\d{0,2}')),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Center(
                                  child: ReusableButton(
                                    buttonText: "Calculate",
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      if (fifpProvider.paymentDetailsValidation(
                                          fifpProvider.conversionCharges.text,
                                          fifpProvider.mv.text,
                                          fifpProvider.mvDateOfRegstn.text,
                                          context)) {
                                        await fifpProvider.paymentDetalsCalc(
                                            fifpProvider.conversionCharges.text,
                                            fifpProvider.mv.text,
                                            fifpProvider.mvDateOfRegstn.text,
                                            context);
                                        final t1 = int.tryParse(fifpProvider
                                                .clusterCalulationDetails?[0]
                                                .totalAmount ??
                                            "0");
                                        final t2 = int.tryParse(
                                            fifpProvider.conversionCharges.text);
                                        final totalAmountCalc =
                                            (t1 ?? 0) + (t2 ?? 0);
                                        setState(() {
                                          fifpProvider.totalAmount =
                                              totalAmountCalc.toString();
                                        });
                                        // chargesFlag = true;
                                        // setState(() {});
                                      }

                                      // Navigator.pushNamed(context, AppRoutes.FifpPaymentDetailspaymentDetails);
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !(fifpProvider.getchargesFlag ||
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
                                        if (!context.mounted) return;
                                        fifpProvider.navigateToRecommendations(
                                          fifpProvider.conversionCharges.text,
                                          fifpProvider.mv.text,
                                          fifpProvider.mvDateOfRegstn.text,
                                          fifpProvider
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
                            visible: fifpProvider.getchargesFlag,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                rowComponent(
                                    "Regulation Charges",
                                    fifpProvider.clusterCalulationDetails?[0]
                                        .regCharges),
                                rowComponent(
                                    "14% Open Space Charges",
                                    fifpProvider.clusterCalulationDetails?[0]
                                        .openSpaceCharges),
                                rowComponent(
                                    "Total Regulation Charges",
                                    fifpProvider.clusterCalulationDetails?[0]
                                        .totalRegCharges),
                                rowComponent(
                                    "Initial Amount Paid",
                                    fifpProvider.clusterCalulationDetails?[0]
                                        .intitalAmount),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const AppInputText(
                                      text: "Amount to be paid: Rs. ",
                                      color: Color.fromARGB(255, 14, 131, 146),
                                      fontweight: FontWeight.bold,
                                      fontsize: 20,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    AppInputText(
                                      text: (fifpProvider.totalAmount),
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
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    await prefs.setBool(
                                        SharedPrefConstants.isCalculate, true);
                                    if (!context.mounted) return;

                                    fifpProvider.navigateToRecommendations(
                                      fifpProvider.conversionCharges.text,
                                      fifpProvider.mv.text,
                                      fifpProvider.mvDateOfRegstn.text,
                                      fifpProvider.clusterCalulationDetails?[0],
                                      context,
                                    );
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
        if (fifpProvider.getLoaderVisibilityStatus) const LoaderComponent()
      ],
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
