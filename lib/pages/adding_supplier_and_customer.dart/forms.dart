import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/customer_controller.dart';
import 'package:flutter_web_dashboard/controllers/supplier_controller.dart';
import 'package:flutter_web_dashboard/widgets/custom_button.dart';
import 'package:get/get.dart';

class AddCustomerForm extends StatefulWidget {
  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final AddingCustomerController controller =
      Get.put(AddingCustomerController());

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: labelText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.blue),
        ),
      ),
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Customer'),
      content: Form(
        key: controller.addCustomerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
                controller: controller.nameController,
                labelText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                },
                onSaved: (String? value) {
                  controller.name.value = value!;
                }),
            const SizedBox(
              height: 10,
            ),
            _buildTextField(
                controller: controller.phoneNumberController,
                labelText: 'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                },
                onSaved: (String? value) {
                  controller.phoneNumber.value = value!;
                }),
            const SizedBox(height: 20),
            customButton(
                onPress: controller.checkAddCustomer, buttontext: "Add")
          ],
        ),
      ),
    );
  }
}

class AddSupplierForm extends StatefulWidget {
  @override
  State<AddSupplierForm> createState() => _AddSupplierFormState();
}

class _AddSupplierFormState extends State<AddSupplierForm> {
  final AddingSupplierController controller =
      Get.put(AddingSupplierController());

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: labelText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.blue),
        ),
      ),
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Supplier'),
      content: Form(
        key: controller.addSupplierFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
                controller: controller.nameController,
                labelText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                },
                onSaved: (String? value) {
                  controller.name.value = value!;
                }),
            const SizedBox(
              height: 10,
            ),
            _buildTextField(
                controller: controller.phoneNumberController,
                labelText: 'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                },
                onSaved: (String? value) {
                  controller.phoneNumber.value = value!;
                }),
            const SizedBox(height: 20),
            customButton(
                onPress: controller.checkAddSupplier, buttontext: "Add")
          ],
        ),
      ),
    );
  }
}
