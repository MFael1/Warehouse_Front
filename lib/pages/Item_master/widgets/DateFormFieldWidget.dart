import 'package:flutter/material.dart';

class DateFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Function(String) onChanged;

  const DateFormFieldWidget({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          String formattedDate = picked.toLocal().toString().split(' ')[0];
          onChanged(formattedDate);
          controller.text = formattedDate;
        }
      },
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please select a date' : null,
    );
  }
}
