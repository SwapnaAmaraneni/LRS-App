import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class QuestionTile extends StatelessWidget {
  final String question;
  final String? sno;
  final String? selectedAnswer;
  final ValueChanged<String?> onChanged;
  final String? value1;
  final String? value2;

  const QuestionTile({
    super.key,
    required this.question,
    this.sno,
    this.selectedAnswer,
    required this.onChanged,
    this.value1,
    this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (sno != null && (sno)!.trim().isNotEmpty)
                Text(
                  sno ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              RadioGroup<String>(
                groupValue: selectedAnswer,
                onChanged: onChanged,
                child: Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Radio<String>(value: 'Y'),
                        Text(value1 ?? "Yes".tr()),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(value: 'N'),
                        Text(value2 ?? "No".tr()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
