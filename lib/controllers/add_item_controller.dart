import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';

class AddItemController extends GetxController {
  final GlobalKey<FormState> additemFormKey = GlobalKey<FormState>();

  final API api = API(); // Update the service according to your API service
  var selectedFacility = Rxn<Facility>();

  // Text editing controllers
  late TextEditingController nameController;
  late TextEditingController countController;
  late TextEditingController manufacturerDateController;
  late TextEditingController expiringDateController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    countController = TextEditingController();
    manufacturerDateController = TextEditingController();
    expiringDateController = TextEditingController();
  }

  void _disposeControllers() {
    nameController.dispose();
    countController.dispose();
    manufacturerDateController.dispose();
    expiringDateController.dispose();
  }

  Future<void> submitForm() async {
    if (additemFormKey.currentState?.validate() ?? false) {
      final formData = {
        'name': nameController.text,
        'count': int.tryParse(countController.text) ?? 0,
        'manufacturer_date': manufacturerDateController.text,
        'expiring_date': expiringDateController.text,
        'facility_id': selectedFacility.value?.id ?? 0,
        "item_master_id": 2
      };

      try {
        print(formData);
        final response = await api.postAddItem(
            'https://localhost:7086/api/ItemMaster', // Adjust the URL as needed
            formData);

        if (response != null && response.statusCode == 200) {
          SnackbarUtils.showCustomSnackbar(
            title: 'Success',
            message: 'Item added successfully!',
          );
        } else {
          SnackbarUtils.showCustomSnackbar(
            title: 'Error',
            message: 'Failed to add item',
          );
        }
      } catch (e) {
        SnackbarUtils.showCustomSnackbar(
          title: 'Error',
          message: 'Failed to add item: $e',
        );
      }
    }
  }
}
