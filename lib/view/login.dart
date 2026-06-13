import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/reusable_widgets/textformfield_reusable.dart';
import '../utils/reusable_button.dart';
import '../view_model/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginViewModel>(context);
    TextEditingController userIdController = TextEditingController();
    // AppConstants.deleteFlag = "true";
    return Stack(
      children: [
        PopScope(
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
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.appBg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        child: ListView(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          children: [
                            const Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage(AppAssets.appIcon),
                                ),
                              ],
                            ),
                            TextFormfieldReusable(
                              controller: userIdController,
                              hintText: "userId".tr(),
                              textLength: 50,
                              obscureText: false,
                              keyboardInputType: TextInputType.text,
                              errorMessage: '',
                              textCapitalization: TextCapitalization.characters,
                            ),
                            ReusableButton(
                              buttonText: "login".tr(),
                              onPressed: () {
                                loginProvider.login(
                                    userIdController.text.trim(), context);
                              },
                            ),
                            if (AppConstants.deleteFlag ==
                                "true") // Condition to show/hide the register button
                              ReusableButton(
                                buttonText: "register".tr(),
                                onPressed: () {
                                  loginProvider.registration(context);
                                },
                              ),
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
        if (loginProvider.getLoaderVisibilityStatus) const LoaderComponent()
      ],
    );
  }
}
