import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.hintText = "Search...",
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^[A-Za-z0-9 _\-\/]{0,100}'),
        ),
      ],
      maxLength: 100,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close, color: Colors.white),
              )
            : null,
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
