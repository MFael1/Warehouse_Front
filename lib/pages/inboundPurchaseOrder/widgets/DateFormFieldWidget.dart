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
    return Material(
      elevation: 3.0,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 16),
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
      ),
    );
  }
}
