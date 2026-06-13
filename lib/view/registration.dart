import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/reusable_widgets/textformfield_reusable.dart';
import '../utils/reusable_button.dart';
import '../view_model/login_view_model.dart';

class RegistationScreen extends StatelessWidget {
  const RegistationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginViewModel>(context);
    TextEditingController nameController = TextEditingController();
    TextEditingController userIdController = TextEditingController();

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
                              controller: nameController,
                              hintText: "name".tr(),
                              textLength: 50,
                              obscureText: false,
                              keyboardInputType: TextInputType.text,
                              errorMessage: '',
                              textCapitalization: TextCapitalization.characters,
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
                              buttonText: "register".tr(),
                              onPressed: () {
                                if (nameController.text == "") {
                                  ValidationIoSAlert().showAlert(
                                    context,
                                    description: "Please Enter Name",
                                  );
                                } else if (userIdController.text == "") {
                                  ValidationIoSAlert().showAlert(
                                    context,
                                    description: "Please Enter User Id",
                                  );
                                } else {
                                  SuccessCustomCupertinoAlert().showAlert(
                                    context: context,
                                    title: "regSuccessAlert".tr(),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, AppRoutes.login);
                                    },
                                  );
                                }
                              },
                            ),
                            ReusableButton(
                              buttonText: "login".tr(),
                              onPressed: () {
                                Navigator.of(context).pop();
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
