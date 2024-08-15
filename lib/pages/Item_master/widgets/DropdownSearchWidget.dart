import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DropdownSearchWidget<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) itemAsString;
  final String hint;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  DropdownSearchWidget({
    required this.items,
    required this.itemAsString,
    required this.hint,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        hintText: hint,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemAsString(item)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
