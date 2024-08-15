import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/constants/imageforapi.dart';
import 'package:flutter_web_dashboard/constants/local_data.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:flutter_web_dashboard/layout.dart';
import 'package:get/get.dart';

class AddingEmployeeController extends GetxController {
  final GlobalKey<FormState> addEmployeeFormKey = GlobalKey<FormState>();

  var api = API();

  var selectedFacility = Rxn<Facility>();
  var selectedEqupment = Rxn<Equipment>();
  var selectedRole = Rxn<RoleEm>();

  late TextEditingController usernameController,
      passwordController,
      firstnameController,
      lastnameController,
      emailController,
      facilityController,
      hourlyWageController,
      equipmentTypeController,
      hireDateController;

  var username = ''.obs;
  var password = ''.obs;
  var firstname = ''.obs;
  var lastname = ''.obs;
  var email = ''.obs;
  var equipmentType = ''.obs;
  var facility = ''.obs;
  var hourlyWage = ''.obs;
  var hireDate = ''.obs;
  var imageData = Rx<Uint8List?>(null);

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    facilityController = TextEditingController();
    hourlyWageController = TextEditingController();
    equipmentTypeController = TextEditingController();
    emailController = TextEditingController();
    hireDateController = TextEditingController();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    equipmentTypeController.dispose();
    hourlyWageController.dispose();
    facilityController.dispose();
    hireDateController.dispose();
    super.onClose();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid username";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  String? validateFirstname(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid first name";
    }
    return null;
  }

  String? validateLastname(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid last name";
    }
    return null;
  }

  String? validateFacility(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid facility name";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || !GetUtils.isEmail(value)) {
      return "Provide a valid email";
    }
    return null;
  }

  String? validateEquipmentType(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid equipment type";
    }
    return null;
  }

  String? validateHourlyWage(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid hourly wage";
    }
    return null;
  }

  String? validateHireDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid hire date";
    }
    return null;
  }

  void checkAddEmployee() {
    if (addEmployeeFormKey.currentState == null) {
      print('Error: addEmployeeFormKey.currentState is null');
      Get.snackbar('Error', 'Form state is null');
      return;
    }
    final isValid = addEmployeeFormKey.currentState!.validate();
    if (!isValid) {
      print('Form is not valid');
      return;
    }
    print('Form is valid');
    addEmployeeFormKey.currentState!.save();
    print('Form saved');
    addingEmployeeFun();
  }

  Future<void> addingEmployeeFun() async {
    const url = 'https://localhost:7086/api/User';
    // const url = 'https://172.19.0.1:7086/api/User'; public server ip address

    // Convert Uint8List to base64 string
    String? imageBase64 =
        imageData.value != null ? base64Encode(imageData.value!) : null;

    final data = {
      "username": username.value,
      "password": password.value,
      "first_name": firstname.value,
      "last_name": lastname.value,
      "email": email.value,
      "image": imageBase64,
      "hourly_wage": double.parse(hourlyWage.value),
      "hire_date": hireDate.value,
      "facility_id": 1, // Replace with actual facility ID
      "equipment_id": 1, // Replace with actual equipment ID
      "roles": [0] // Replace with actual roles IDs
    };

    // Show loading indicator
    Get.dialog(
      CustomLoadingIndicator(),
      barrierDismissible: false,
    );

    try {
      var response = await api.postAddEmoployee(url, data);
      Get.back(); // Dismiss loading indicator

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        SnackbarUtils.showCustomSnackbar(
          title: 'Success',
          message: 'Employee added successfully',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
        Get.to(SiteLayout());
      } else if (response?.statusCode == 500) {
        SnackbarUtils.showCustomSnackbar(
          title: 'Error',
          message: 'This users already exisit',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      } else {
        print('Failed to add employee. Status code: ${response?.statusCode}');
        print('Response body: ${response?.body}');
        SnackbarUtils.showCustomSnackbar(
          title: 'Error',
          message: 'Failed to add employee. Please try again.',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      }
    } catch (e) {
      print('Error: $e');
      Get.back(); // Dismiss loading indicator on error
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to add employee. Please try again.',
        backgroundColor: const Color.fromARGB(255, 34, 106, 248),
      );
    }
  }
}
