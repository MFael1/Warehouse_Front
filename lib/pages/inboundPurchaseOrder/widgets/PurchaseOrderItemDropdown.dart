import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ItemDropdownSearchWidget<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) itemAsString;
  final String hint;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const ItemDropdownSearchWidget({
    Key? key,
    required this.items,
    required this.itemAsString,
    required this.hint,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: items,
      itemAsString: itemAsString,
      dropdownBuilder: (context, selectedItem) {
        return ListTile(
          title: Text(selectedItem != null ? itemAsString(selectedItem) : hint),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        );
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(itemAsString(item)),
            selected: isSelected,
          );
        },
      ),
      onChanged: onChanged,
      // Validator is typically used in form validation, so it can be commented out if not needed
      // validator: validator,
    );
  }
}
