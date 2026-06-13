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
import 'package:lrsofficer/view_model/payment_details_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final paymentDetailsProvider =
          Provider.of<PaymentDetailsViewmodel>(context, listen: false);
      paymentDetailsProvider.setchargesFlag(false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      paymentDetailsProvider.mv.text = paymentDetailsProvider.mv.text.isNotEmpty ? paymentDetailsProvider.mv.text : prefs.getString(SharedPrefConstants.mvRate2020Key) ?? "";
      paymentDetailsProvider.mvDateOfRegstn.text = paymentDetailsProvider.mvDateOfRegstn.text.isNotEmpty ? paymentDetailsProvider.mvDateOfRegstn.text : prefs.getString(SharedPrefConstants.mvRateDocumentKey) ?? "";
      paymentDetailsProvider.conversionCharges.text = paymentDetailsProvider.conversionCharges.text.isNotEmpty ? paymentDetailsProvider.conversionCharges.text : prefs.getString(SharedPrefConstants.conversionChargesKey) ?? "";
      mvEditable =
          ((prefs.getString(SharedPrefConstants.mvEditFlagKey) ?? "") == "true")
              ? true
              : false;
      if (!kReleaseMode) debugPrint("mvFlag::  $mvEditable");
      setState(() {
        paymentDetailsProvider.mvText = paymentDetailsProvider.mv.text;
        paymentDetailsProvider.mvDateOfRegstnText = paymentDetailsProvider.mvDateOfRegstn.text;
      });
    });
  }

  bool mvEditable = false;

  @override
  Widget build(BuildContext context) {
    final paymentDetailsProvider =
        Provider.of<PaymentDetailsViewmodel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "Payment Details",
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
                            nameController:
                                paymentDetailsProvider.conversionCharges,
                            length: 10,
                            onEditingComplete: () {
                              paymentDetailsProvider.setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              paymentDetailsProvider.setchargesFlag(false);
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
                            nameController: paymentDetailsProvider.mv,
                            isReadOnly: mvEditable ? false : true,
                            length: 10,
                            onEditingComplete: () {
                              paymentDetailsProvider.setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              paymentDetailsProvider.setchargesFlag(false);
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
                            nameController:
                                paymentDetailsProvider.mvDateOfRegstn,
                            isReadOnly: mvEditable ? false : true,
                            onEditingComplete: () {
                              paymentDetailsProvider.setchargesFlag(false);
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (p0) {
                              paymentDetailsProvider.setchargesFlag(false);
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
                                      if (paymentDetailsProvider
                                          .paymentDetailsValidation(
                                              paymentDetailsProvider
                                                  .conversionCharges.text,
                                              paymentDetailsProvider.mv.text,
                                              paymentDetailsProvider
                                                  .mvDateOfRegstn.text,
                                              context)) {
                                        await paymentDetailsProvider
                                            .paymentDetalsCalc(
                                                paymentDetailsProvider
                                                    .conversionCharges.text,
                                                paymentDetailsProvider.mv.text,
                                                paymentDetailsProvider
                                                    .mvDateOfRegstn.text,
                                                context);
                                        // Safely obtain total amount from first cluster detail
                                        final firstDetail = paymentDetailsProvider.firstClusterDetail;
                                        final t1 = int.tryParse(firstDetail?.totalAmount ?? "0");
                                        final t2 = int.tryParse(
                                            paymentDetailsProvider
                                                .conversionCharges.text);
                                        final totalAmountCalc =
                                            (t1 ?? 0) + (t2 ?? 0);
                                        setState(() {
                                          paymentDetailsProvider.totalAmount =
                                              totalAmountCalc.toString();
                                        });
                                        // chargesFlag = true;
                                        // setState(() {});
                                      }

                                      // Navigator.pushNamed(context, AppRoutes.paymentDetails);
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !(paymentDetailsProvider
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
                                        paymentDetailsProvider
                                            .navigateToRecommendations(
                                          paymentDetailsProvider
                                              .conversionCharges.text,
                                          paymentDetailsProvider.mv.text,
                                          paymentDetailsProvider
                                              .mvDateOfRegstn.text,
                                          // Pass safe first cluster detail to recommendations
                                          paymentDetailsProvider.firstClusterDetail,
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
                            visible: paymentDetailsProvider.getchargesFlag,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                rowComponent(
                                    "Regulation Charges",
                                    paymentDetailsProvider.firstClusterDetail?.regCharges),
                                rowComponent(
                                    "14% Open Space Charges",
                                    paymentDetailsProvider.firstClusterDetail?.openSpaceCharges),
                                rowComponent(
                                    "Total Regulation Charges",
                                    paymentDetailsProvider.firstClusterDetail?.totalRegCharges),
                                rowComponent(
                                    "Initial Amount Paid",
                                    paymentDetailsProvider.firstClusterDetail?.intitalAmount),
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
                                      text: (paymentDetailsProvider.totalAmount),
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

                                    paymentDetailsProvider
                                        .navigateToRecommendations(
                                      paymentDetailsProvider
                                          .conversionCharges.text,
                                      paymentDetailsProvider.mv.text,
                                      paymentDetailsProvider
                                          .mvDateOfRegstn.text,
                                      paymentDetailsProvider.firstClusterDetail,
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
        if (paymentDetailsProvider.getLoaderVisibilityStatus)
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
