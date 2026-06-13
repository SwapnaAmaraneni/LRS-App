import 'package:easy_localization/easy_localization.dart';
import 'package:lrsofficer/res/reusable_widgets/phone_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/constants/app_assets.dart';
import '../utils/reusable_button.dart';
import '../view_model/reset_password_view_model.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController mobileNocontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider = Provider.of<ResetPasswordViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("RESET PASSWORD"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const CircleAvatar(
            radius: 52,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(AppAssets.appIcon),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: PhoneTextformfield(
                  hintText: "mobileNumber".tr(),
                  controller: mobileNocontroller,
                ),
              ),
              ReusableButton(
                buttonText: "Continue",
                onPressed: () {
                  resetPasswordProvider.resetPassword(
                      mobileNocontroller.text, context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
