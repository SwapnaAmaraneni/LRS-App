import 'package:flutter/material.dart';

class DropdownReusable<T> extends StatefulWidget {
  final String? label;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value)? onChanged;
  final T? selectedValue;
  final bool isEnabled;
  final double? width;

  const DropdownReusable(
      {super.key,
      this.label,
      required this.items,
      required this.onChanged,
      required this.selectedValue,
      required this.isEnabled,
      this.width});

  @override
  State<DropdownReusable<T>> createState() => _DropdownReusableState<T>();
}

class _DropdownReusableState<T> extends State<DropdownReusable<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: widget.width ?? MediaQuery.of(context).size.width * 0.95,
        height: 50,
        child: InputDecorator(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            labelText: widget.label,
            labelStyle: const TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              hint: Text("${widget.label}"),
              menuMaxHeight: 300,
              dropdownColor: Colors.white,
              value: widget.selectedValue,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              iconEnabledColor: widget.isEnabled ? Colors.black : Colors.grey,
              style: TextStyle(
                color: widget.isEnabled ? Colors.black : Colors.grey,
              ),
              onChanged: widget.isEnabled ? widget.onChanged : null,
              items: widget.items,
            ),
          ),
        ),
      ),
    );
  }
}
