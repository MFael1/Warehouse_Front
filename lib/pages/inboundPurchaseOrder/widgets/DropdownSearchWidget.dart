import 'package:flutter/material.dart';

class DropdownSearchWidget<T> extends StatelessWidget {
  final List<T> items;
  final String hint;
  final String Function(T) itemAsString;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;

  const DropdownSearchWidget({
    Key? key,
    required this.items,
    required this.hint,
    required this.itemAsString,
    this.selectedItem,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0, // Lighter shadow for a modern look
      shadowColor: Colors.black.withOpacity(0.1), // Subtle shadow color
      borderRadius: BorderRadius.circular(12.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blueGrey.shade500, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
        ),
        value: selectedItem,
        items: items.map((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(itemAsString(value)),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
