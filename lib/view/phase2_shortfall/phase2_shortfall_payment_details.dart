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
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_payment_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phase2ShortfallPaymentDetails extends StatefulWidget {
  const Phase2ShortfallPaymentDetails({super.key});

  @override
  State<Phase2ShortfallPaymentDetails> createState() =>
      _Phase2ShortfallPaymentDetailsState();
}

class _Phase2ShortfallPaymentDetailsState
    extends State<Phase2ShortfallPaymentDetails> {
  TextEditingController conversionCharges = TextEditingController();
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
      final phase2ShortfallpaymentDetailsProvider =
          Provider.of<Phase2ShortfallPaymentDetailsViewModel>(context,
              listen: false);
      phase2ShortfallpaymentDetailsProvider.setchargesFlag(false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      mv.text = prefs.getString(SharedPrefConstants.mvRate2020Key) ?? "";
      mvDateOfRegstn.text =
          prefs.getString(SharedPrefConstants.mvRateDocumentKey) ?? "";
      conversionCharges.text =
          prefs.getString(SharedPrefConstants.conversionChargesKey) ?? "";
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
    final phase2ShortfallpaymentDetailsProvider =
        Provider.of<Phase2ShortfallPaymentDetailsViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "Phase-2 Shortfall Payment Details",
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
                            nameController: conversionCharges,
                            length: 10,
                            onEditingComplete: () {
                              phase2ShortfallpaymentDetailsProvider
                                  .setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              phase2ShortfallpaymentDetailsProvider
                                  .setchargesFlag(false);
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
                            nameController: mv,
                            isReadOnly: mvEditable ? false : true,
                            length: 10,
                            onEditingComplete: () {
                              phase2ShortfallpaymentDetailsProvider
                                  .setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              phase2ShortfallpaymentDetailsProvider
                                  .setchargesFlag(false);
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
                            isReadOnly: mvEditable ? false : true,
                            onEditingComplete: () {
                              phase2ShortfallpaymentDetailsProvider
                                  .setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              phase2ShortfallpaymentDetailsProvider
                                  .setchargesFlag(false);
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
                                      if (phase2ShortfallpaymentDetailsProvider
                                          .paymentDetailsValidation(
                                              conversionCharges.text,
                                              mv.text,
                                              mvDateOfRegstn.text,
                                              context)) {
                                        await phase2ShortfallpaymentDetailsProvider
                                            .paymentDetalsCalc(
                                                conversionCharges.text,
                                                mv.text,
                                                mvDateOfRegstn.text,
                                                context);
                                        final t1 = int.tryParse(
                                            phase2ShortfallpaymentDetailsProvider
                                                    .clusterCalulationDetails?[
                                                        0]
                                                    .totalAmount ??
                                                "0");
                                        final t2 = int.tryParse(
                                            conversionCharges.text);
                                        final totalAmountCalc =
                                            (t1 ?? 0) + (t2 ?? 0);
                                        setState(() {
                                          totalAmount =
                                              totalAmountCalc.toString();
                                        });
                                        // chargesFlag = true;
                                        // setState(() {});
                                      }

                                      // Navigator.pushNamed(context, AppRoutes.Phase2ShortfallpaymentDetails);
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !(phase2ShortfallpaymentDetailsProvider
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
                                        if (!context.mounted) return;
                                        phase2ShortfallpaymentDetailsProvider
                                            .navigateToRecommendations(
                                          conversionCharges.text,
                                          mv.text,
                                          mvDateOfRegstn.text,
                                          phase2ShortfallpaymentDetailsProvider
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
                            visible: phase2ShortfallpaymentDetailsProvider
                                .getchargesFlag,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                rowComponent(
                                    "Regulation Charges",
                                    phase2ShortfallpaymentDetailsProvider
                                        .clusterCalulationDetails?[0]
                                        .regCharges),
                                rowComponent(
                                    "14% Open Space Charges",
                                    phase2ShortfallpaymentDetailsProvider
                                        .clusterCalulationDetails?[0]
                                        .openSpaceCharges),
                                rowComponent(
                                    "Total Regulation Charges",
                                    phase2ShortfallpaymentDetailsProvider
                                        .clusterCalulationDetails?[0]
                                        .totalRegCharges),
                                rowComponent(
                                    "Initial Amount Paid",
                                    phase2ShortfallpaymentDetailsProvider
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
                                      color: Color.fromARGB(255, 14, 131, 146),
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
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    await prefs.setBool(
                                        SharedPrefConstants.isCalculate, true);
                                    if (!context.mounted) return;

                                    phase2ShortfallpaymentDetailsProvider
                                        .navigateToRecommendations(
                                      conversionCharges.text,
                                      mv.text,
                                      mvDateOfRegstn.text,
                                      phase2ShortfallpaymentDetailsProvider
                                          .clusterCalulationDetails?[0],
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
        if (phase2ShortfallpaymentDetailsProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
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
