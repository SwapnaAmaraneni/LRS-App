import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton(
      {super.key,
      this.onPressed,
      required this.buttonText,
      this.width,
      this.padding});
  final Function()? onPressed;
  final String buttonText;
  final double? width;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(4.0),
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              AppColors.themeColor,
            ),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: FittedBox(
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
