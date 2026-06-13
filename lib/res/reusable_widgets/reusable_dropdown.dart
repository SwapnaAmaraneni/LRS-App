import 'package:flutter/material.dart';
 
class DropdownTextFormField<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final T value;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final bool isEnabled;
 
  const DropdownTextFormField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.value,
    required this.isEnabled,
    this.onSaved,
    this.validator,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: InputDecorator(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                labelText: label.toUpperCase(),
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  dropdownColor: Colors.white,
                  value: value,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  iconEnabledColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  isExpanded: true,
                  onChanged: onChanged,
                  items: items,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}