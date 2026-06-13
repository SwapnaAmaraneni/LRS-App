import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormfieldReusable extends StatelessWidget {
  const TextFormfieldReusable(
      {super.key,
      required this.hintText,
      required this.controller,
      this.keyboardInputType,
      this.obscureText,
      this.onEditingComplete,
      this.globalKey,
      this.prefixIcon,
      this.onTap,
      this.suffixIcon,
      this.onChanged,
      this.autofocus,
      this.errorMessage,
      this.textLength,
      this.inputFormatters,
      this.textCapitalization,
      this.action,
      this.padding,
      this.width});
  final String hintText;
  final String? errorMessage;
  final TextEditingController controller;
  final TextInputType? keyboardInputType;
  final bool? obscureText;
  final TextCapitalization? textCapitalization;
  final VoidCallback? onEditingComplete;
  final GlobalKey? globalKey;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool? autofocus;
  final void Function()? onTap;
  final int? textLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? action;
  final EdgeInsetsGeometry? padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: Form(
        key: globalKey,
        child: SizedBox(
          width: width ?? MediaQuery.of(context).size.width * 0.95,
          height: 50,
          child: TextFormField(
            autofocus: autofocus ?? false,
            obscureText: obscureText ?? false,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            textInputAction: action ?? TextInputAction.done,
            onEditingComplete: onEditingComplete,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: hintText,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return errorMessage;
              } else {
                return "";
              }
            },
            inputFormatters: inputFormatters,
            keyboardType: keyboardInputType,
          ),
        ),
      ),
    );
  }
}
