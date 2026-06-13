import 'package:flutter/material.dart';

class ReusableTextButton extends StatelessWidget {
  const ReusableTextButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.decoration});

  final String buttonText;
  final Function()? onPressed;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(decoration: decoration),
        ));
  }
}
