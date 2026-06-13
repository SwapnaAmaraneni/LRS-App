import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/constants/app_assets.dart';
import '../res/reusable_widgets/textformfield_reusable.dart';
import '../res/reusable_widgets/phone_textformfield.dart';
import '../res/reusable_widgets/text_button.dart';
import '../routes/app_routes.dart';
import '../utils/reusable_button.dart';
import '../view_model/login_with_userid_password_view_model.dart';

class LoginWithMobileAndPassword extends StatelessWidget {
  const LoginWithMobileAndPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController mobile = TextEditingController();
    TextEditingController password = TextEditingController();
    FocusScopeNode node = FocusScopeNode();
    final loginProvider = Provider.of<LoginWithMobileViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.appBg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhoneTextformfield(
                  controller: mobile,
                  hintText: 'userId'.tr(),
                  textLength: 10,
                  obscureText: false,
                  node: node,
                  action: TextInputAction.next,
                ),
                TextFormfieldReusable(
                  hintText: "password".tr(),
                  controller: password,
                  keyboardInputType: TextInputType.visiblePassword,
                  obscureText: false,
                  textLength: 30,
                
           
                  onEditingComplete: () {
                    node.nextFocus();
                  },
                  errorMessage: "passwordValidation".tr(),
                ),
                ReusableTextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.resetPassword);
                  },
                  buttonText: "Forgot Password",
                  decoration: TextDecoration.underline,
                ),
                ReusableButton(
                  buttonText: "login".tr(),
                  onPressed: () {
                    loginProvider.userLogin(
                        mobile.text, password.text, context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
