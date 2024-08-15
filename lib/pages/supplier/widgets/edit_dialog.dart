import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/supplier_model.dart';
import 'package:get/get.dart';

Future<void> showEditSupplierDialog(
    BuildContext context, supplier, Future<bool> Function(Supplier) onEdit) {
  final TextEditingController nameController =
      TextEditingController(text: supplier.name);
  final TextEditingController phoneController =
      TextEditingController(text: supplier.contact.phoneNumber);

  return Get.defaultDialog(
    title: "Edit Supplier",
    content: Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(labelText: "Name"),
        ),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(labelText: "Phone Number"),
        ),
      ],
    ),
    confirm: ElevatedButton(
      onPressed: () async {
        final updatedSupplier = Supplier(
          id: supplier.id, // Make sure to include the ID
          name: nameController.text,
          contact: Contact(phoneNumber: phoneController.text),
        );
        bool success = await onEdit(updatedSupplier);
        if (success) {
          Get.back();
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: const Text(
        'Edit',
        style: TextStyle(fontSize: 18),
      ),
    ),
    cancel: ElevatedButton(
      onPressed: () {
        Get.back();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(fontSize: 18),
      ),
    ),
  );
}
