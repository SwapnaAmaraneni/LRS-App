import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';

class AppInputTextfield extends StatelessWidget {
  const AppInputTextfield({
    super.key,
    this.hintText,
    required this.nameController,
    this.errorMessage,
    this.inputType,
    //  this.obsecuretext,
    //  this.node,
    //  this.action,
    this.prefixIcon,
    // this.isSecured,
    // this.isVisible,
    this.onTap,
    this.suffixIcon,
    this.length,
    this.inputFormatters,
    this.autofocus,
    this.textfieldwidth,
    this.isReadOnly,
    this.textColor,
    this.stringToCompare,
    this.onChanged,
    this.onEditingComplete,
    this.maxLines,
    this.height,
    this.width,
  });

  final String? hintText, errorMessage;
  final TextEditingController nameController;
  final TextInputType? inputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? length;
  final List<TextInputFormatter>? inputFormatters;
  final double? textfieldwidth;
  final bool? autofocus;
  final void Function()? onTap;
  final bool? isReadOnly;
  final Color? textColor;
  final String? stringToCompare;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final int? maxLines;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width * 0.95,
        child: TextField(
          readOnly: isReadOnly ?? false,
          maxLength: length,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          onEditingComplete: onEditingComplete,
          textInputAction: TextInputAction.done,
          onChanged: onChanged,
          controller: nameController,
          decoration: InputDecoration(
              counterText: '',
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.all(8.0),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.appBarColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.appBarColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.appBarColor),
              ),
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              labelText: ((isReadOnly == true &&
                          nameController.text.trim().isNotEmpty) ||
                      isReadOnly == false ||
                      isReadOnly == null)
                  ? hintText
                  : null,
              hintText: hintText,
              errorMaxLines: 3),
          style: TextStyle(
            color: textColor ??
                (isReadOnly == true ? AppColors.grey : AppColors.black),
          ),
          keyboardType: inputType ?? TextInputType.text,
        ),
      ),
    );
  }
}
