import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/Model/customer_model.dart'; // Adjust path if needed

Future<void> showEditDialogCustomer(BuildContext context, Customer customer,
    Future<bool> Function(Customer) onEdit) {
  final TextEditingController nameController =
      TextEditingController(text: customer.name);
  final TextEditingController phoneController =
      TextEditingController(text: customer.contact.phoneNumber);

  return Get.defaultDialog(
    title: "Edit Customer",
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
        final updatedCustomer = Customer(
          id: customer.id, // Make sure to include the ID
          name: nameController.text,
          contact: Contact(phoneNumber: phoneController.text),
        );
        bool success = await onEdit(updatedCustomer);
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
