import 'package:flutter/material.dart';

class DropdownSearchWidget<T> extends StatelessWidget {
  final List<T> items;
  final String hint;
  final String Function(T) itemAsString;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;

  DropdownSearchWidget({
    required this.items,
    required this.hint,
    required this.itemAsString,
    this.selectedItem,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blueAccent, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
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
