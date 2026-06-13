import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../data/local_store_helper.dart';
import '../res/reusable_widgets/app_input_text.dart';
import '../utils/shared_pref_constants.dart';
import '../view_model/otp_view_model.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController otpController = TextEditingController();
  double? height;
  double? width;
  late Timer _timer;
  int _start = 30; // Timer duration in seconds
  bool _resendEnabled = false;
  String mobile = "";
  String sentOtp = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mobile =
          await LocalStoreHelper().readTheData(SharedPrefConstants.mobileNo);
      setState(() {});

      AppLogger().logDebug(" mobileNo $mobile");
    });

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _resendEnabled = true; // Enable the resend button
          _timer.cancel(); // Stop the timer
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resetTimer() {
    setState(() {
      _start = 30; // Reset the timer duration
      _resendEnabled = false; // Disable the resend button
      startTimer(); // Start the timer again
    });
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpViewModel>(context);
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
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text(
                "Verification",
              ),
              centerTitle: true,
            ),
            body: Container(
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
                    Center(
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(AppAssets.appIcon),
                              ),
                            ),
                            AppInputText(
                              text: "verificationCode".tr(),
                              fontsize: 18,
                              fontweight: FontWeight.w600,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Center(
                                child: AppInputText(
                                  textAlign: TextAlign.center,
                                  text: (mobile.isNotEmpty)
                                      ? "${"sentCodeToMobileNo".tr()} ${'*' * (mobile.length - 4) + mobile.substring(mobile.length - 4)}"
                                      : "sentCodeToMobileNo".tr(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PinCodeFields(
                                  length: 4,
                                  fieldBorderStyle: FieldBorderStyle.square,
                                  controller: otpController,
                                  responsive: false,
                                  fieldHeight: 35.0,
                                  fieldWidth: 35.0,
                                  borderWidth: 2.0,
                                  activeBorderColor: Colors.black,
                                  borderRadius: BorderRadius.circular(10.0),
                                  keyboardType: TextInputType.number,
                                  autoHideKeyboard: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  borderColor: Colors.black,
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  obscureText: true,
                                  obscureCharacter: '⬤',
                                  onComplete: (String value) {},
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Resend OTP in $_start seconds ',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    _resendEnabled
                                        ? TextButton(
                                            onPressed: () async {
                                              sentOtp = "";
                                              final otp = await otpProvider
                                                  .getResendOtp(
                                                      context, mobile);
                                              setState(() {
                                                sentOtp = otp ?? "";

                                                AppLogger().logDebug(
                                                    "otp in resend $sentOtp");
                                              });

                                              resetTimer(); // Reset the timer
                                            },
                                            child: const Text(
                                              'Resend OTP',
                                              style: TextStyle(
                                                  color: AppColors
                                                      .primaryColorDark,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // SizedBox(
                                //   height: height! / 28,
                                // ),
                                ReusableButton(
                                    buttonText: "Verify",
                                    onPressed: () {
                                      AppLogger().logDebug("otp:: $sentOtp");
                                      otpProvider.validateSentOtp(
                                          context, sentOtp, otpController);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ),
          if (otpProvider.getLoaderVisibilityStatus) const LoaderComponent()
        ],
      ),
    );
  }
}
