import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/customer_model.dart'; // Ensure correct path
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:flutter_web_dashboard/layout.dart';
import 'package:get/get.dart';

class AddingCustomerController extends GetxController {
  final GlobalKey<FormState> addCustomerFormKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  var api = API();
  var name = ''.obs;
  var phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid name";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid phone number";
    }
    return null;
  }

  void checkAddCustomer() {
    if (addCustomerFormKey.currentState == null) {
      print('Error: addCustomerFormKey.currentState is null');
      Get.snackbar('Error', 'Form state is null');
      return;
    }

    final isValid = addCustomerFormKey.currentState!.validate();
    if (!isValid) {
      print('Form is not valid');
      return;
    }

    addCustomerFormKey.currentState!.save();
    addingCustomerFun();
  }

  Future<void> addingCustomerFun() async {
    const url = 'https://localhost:7086/api/Customer';

    // // Make sure `name` and `phoneNumber` have correct values
    // print('Name: ${name.value}');
    // print('Phone Number: ${phoneNumber.value}');

    final data = {
      'name': name.value,
      'contact': Contact(phoneNumber: phoneNumber.value),
    };
    // print(name.value);
    // print(phoneNumber.value);

    // Show loading indicator
    Get.dialog(
      CustomLoadingIndicator(),
      barrierDismissible: false,
    );

    try {
      var response = await api.postCustomer(url, data);
      Get.back(); // Dismiss loading indicator

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        SnackbarUtils.showCustomSnackbar(
          title: 'Success',
          message: 'Customer added successfully',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
        Get.to(SiteLayout());
      } else if (response?.statusCode == 500) {
        SnackbarUtils.showCustomSnackbar(
          title: 'Error',
          message: 'This customer already exists',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      } else {
        print('Failed to add customer. Status code: ${response?.statusCode}');
        print('Response body: ${response?.body}');
        SnackbarUtils.showCustomSnackbar(
          title: 'Error',
          message: 'Failed to add customer. Please try again.',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      }
    } catch (e) {
      print('Error: $e');
      Get.back(); // Dismiss loading indicator on error
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to add customer. Please try again.',
        backgroundColor: const Color.fromARGB(255, 34, 106, 248),
      );
    }
  }
}
