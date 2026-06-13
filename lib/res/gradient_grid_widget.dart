import 'package:flutter/material.dart';

class CustomGradientGrid extends StatelessWidget {
  final String title;
  final int? count;
  final Color color;
  final IconData icon;
  final bool isClickable;

  const CustomGradientGrid({
    super.key,
    required this.title,
    this.count,
    required this.color,
    required this.icon,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        if (count != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: isClickable
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$count",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
                decoration: isClickable
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
      ],
    );
  }
}
