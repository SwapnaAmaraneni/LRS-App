import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextformfield extends StatelessWidget {
  const PhoneTextformfield({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText,
    this.node,
    this.action,
    this.globalKey,
    this.prefixIcon,
    this.onTap,
    this.suffixIcon,
    this.textLength,
    this.filterPattern,
    this.labelstyle,
    this.topLabel,
  });
  final String hintText;
  final TextEditingController controller;
  final bool? obscureText;
  final FocusScopeNode? node;
  final TextInputAction? action;
  final GlobalKey? globalKey;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final int? textLength;
  final Pattern? filterPattern;
  final TextStyle? labelstyle;
  final TextStyle? topLabel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FocusScope(
        node: node,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "$hintText can't be Empty ";
              } else {
                return null;
              }
            },
            obscureText: obscureText ?? false,
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              node!.unfocus();
            },
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              errorBorder: const UnderlineInputBorder(),
              labelText: hintText,
              floatingLabelStyle: topLabel,
              labelStyle: labelstyle,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(textLength),
              FilteringTextInputFormatter(filterPattern ?? RegExp(r"[0-9+]"),
                  allow: true)
            ],
            keyboardType: TextInputType.phone,
          ),
        ),
      ),
    );
  }
}
