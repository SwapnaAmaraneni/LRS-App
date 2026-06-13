import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import '../res/constants/app_assets.dart';
import '../utils/reusable_button.dart';
import '../view_model/set_mpin_view_model.dart';

class SetMPINPage extends StatefulWidget {
  const SetMPINPage({super.key});

  @override
  State<SetMPINPage> createState() => _SetMPINPageState();
}

class _SetMPINPageState extends State<SetMPINPage> {
  TextEditingController mpinController = TextEditingController();
  TextEditingController confirmMpinController = TextEditingController();
  double? height;
  double? width;
  String? mpin;
  String? confirmMpin;

  @override
  Widget build(BuildContext context) {
    final setMpinProvider = Provider.of<SetMpinViewModel>(context);
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        AssetImage(AppAssets.appIcon),
                                  ),
                                ),
                                const Text(
                                  "SET MPIN",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                PinCodeFields(
                                  obscureCharacter: '⬤',
                                  obscureText: true,
                                  length: 4,
                                  fieldBorderStyle: FieldBorderStyle.square,
                                  controller: mpinController,
                                  responsive: false,
                                  fieldHeight: 40.0,
                                  fieldWidth: 40.0,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  borderWidth: 2.0,
                                  activeBorderColor: Colors.black,
                                  borderRadius: BorderRadius.circular(10.0),
                                  keyboardType: TextInputType.number,
                                  autoHideKeyboard: true,
                                  borderColor: Colors.black,
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onComplete: (mpin) {
                                    // Your logic with pin code
                                    this.mpin = mpin;

                                    AppLogger().logDebug(" Mpin: $mpin");
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "CONFIRM MPIN",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                PinCodeFields(
                                    length: 4,
                                    obscureCharacter: '⬤',
                                    obscureText: true,
                                    fieldBorderStyle: FieldBorderStyle.square,
                                    controller: confirmMpinController,
                                    responsive: false,
                                    fieldHeight: 40.0,
                                    fieldWidth: 40.0,
                                    borderWidth: 2.0,
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
                                    onComplete: (confirmmpin) {
                                      confirmMpin = confirmmpin;

                                      AppLogger()
                                          .logDebug("Confirm :$confirmMpin");
                                    }),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReusableButton(
                                    onPressed: () {
                                      setMpinProvider.generateMPIN(context);
                                    },
                                    buttonText: 'Submit',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (setMpinProvider.getLoaderVisibilityStatus) const LoaderComponent()
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    final setMpinProvider =
        Provider.of<SetMpinViewModel>(context, listen: false);
    mpinController = setMpinProvider.mpinController;
    confirmMpinController = setMpinProvider.confirmMpinController;
  }
}
