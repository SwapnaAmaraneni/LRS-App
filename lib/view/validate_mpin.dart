import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../res/constants/app_assets.dart';
import '../utils/reusable_button.dart';
import '../view_model/validate_mpin_view_model.dart';

class ValidateMpin extends StatefulWidget {
  const ValidateMpin({super.key});

  @override
  State<ValidateMpin> createState() => _ValidateMpinState();
}

class _ValidateMpinState extends State<ValidateMpin> {
  double? height;

  double? width;

  String? mPin;

  TextEditingController? mpincontrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final validateMpinProvider = Provider.of<ValidateMpinViewModel>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isIOS) {
            exit(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.appBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "appFullName".tr().toUpperCase(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.appNameFontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage(AppAssets.appIcon),
                            ),
                          ),
                          const Text(
                            "VALIDATE MPIN",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          PinCodeFields(
                            length: 4,
                            fieldBorderStyle: FieldBorderStyle.square,
                            controller: mpincontrller,
                            responsive: false,
                            fieldHeight: 40.0,
                            fieldWidth: 40.0,
                            borderWidth: 2.0,
                            obscureCharacter: '⬤',
                            obscureText: true,
                            activeBorderColor: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                            keyboardType: TextInputType.number,
                            autoHideKeyboard: true,
                            borderColor: Colors.black,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            onComplete: (mpin) {
                              // Your logic with pin code
                              mPin = mpin;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      validateMpinProvider.notYOU(context);
                                    },
                                    child: const Text(
                                      "Not You?",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      validateMpinProvider.forgotMPIN(context);
                                    },
                                    child: const Text(
                                      "Forgot Mpin",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ))
                              ],
                            ),
                          ),
                          ReusableButton(
                            buttonText: "Validate",
                            onPressed: () {
                              validateMpinProvider.validateMpin(
                                  mpincontrller!, context);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
