import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';

class OTPVerificationPage extends StatefulWidget {
  final Function(String) onValidatePressed;
  final VoidCallback onCancelPressed;

  const OTPVerificationPage({
    super.key,
    required this.onValidatePressed,
    required this.onCancelPressed,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: otpController,
            decoration: const InputDecoration(
              hintText: 'Enter OTP',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.length == 4) {
                FocusScope.of(context).unfocus();
              }
            },
            obscureText: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 4,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => widget.onValidatePressed(otpController.text),
                child: const Text(
                  'Validate OTP',
                  style: TextStyle(color: AppColors.black),
                ),
              ),
              ElevatedButton(
                onPressed: widget.onCancelPressed,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
