import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';

class DisplayOutorder extends GetxController {
  final GlobalKey<FormState> displayOutorder = GlobalKey<FormState>();

  late TextEditingController poNbrController,
      orderDateController,
      shipDateController,
      deliveryDateController,
      cancelDateController;

  var poNbr = ''.obs;
  var orderDate = ''.obs;
  var shipDate = ''.obs;
  var deliveryDate = ''.obs;
  var cancelDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    poNbrController = TextEditingController();
    orderDateController = TextEditingController();
    shipDateController = TextEditingController();
    deliveryDateController = TextEditingController();
    cancelDateController = TextEditingController();
  }

  @override
  void onClose() {
    poNbrController.dispose();
    orderDateController.dispose();
    shipDateController.dispose();
    deliveryDateController.dispose();
    cancelDateController.dispose();
    super.onClose();
  }

  String? validatePoNbr(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid PO number";
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide a valid date";
    }
    return null;
  }

  void checkAddPurchaseOrder() {
    if (displayOutorder.currentState == null) {
      print('Error: purchaseOrderFormKey.currentState is null');
      Get.snackbar('Error', 'Form state is null');
      return;
    }
    final isValid = displayOutorder.currentState!.validate();
    if (!isValid) {
      print('Form is not valid');
      return;
    }
    print('Form is valid');
    displayOutorder.currentState!.save();
    print('Form saved');
    // AddingPurchaseOrderFun();
  }

  // Future<void> addingPurchaseOrderFun() async {
  //   const url = 'https://api.example.com/purchase_orders'; // Replace with your API endpoint

  //   final data = {
  //     "po_nbr": int.parse(poNbr.value),
  //     "order_date": orderDate.value,
  //     "ship_date": shipDate.value,
  //     "delivery_date": deliveryDate.value,
  //     "cancel_date": cancelDate.value,
  //     // Add other fields if necessary
  //   };

  //   // Show loading indicator
  //   Get.dialog(
  //     CustomLoadingIndicator(),
  //     barrierDismissible: false,
  //   );

  //   try {
  //     final response = await apiService.createPurchaseOrder(INboundOrder(
  //       poNbr: int.parse(poNbr.value),
  //       orderDate: DateTime.parse(orderDate.value),
  //       shipDate: DateTime.parse(shipDate.value),
  //       deliveryDate: DateTime.parse(deliveryDate.value),
  //       cancelDate: DateTime.parse(cancelDate.value),
  //       facility: Facility(id: 1, facilityCode: "DEFAULT"),  // Replace with actual data
  //       customer: Customer(id: 1, name: "DEFAULT", contact: Contact(id: 1, phoneNumber: "0000000000")),  // Replace with actual data
  //       address: null,  // Address is now nullable
  //       status: Status(id: 1, status: "Ordered"),  // Replace with actual data
  //       items: [],  // Replace with actual data
  //     ));

  //     Get.back(); // Dismiss loading indicator

  //     if (response != null) {
  //       SnackbarUtils.showCustomSnackbar(
  //         title: 'Success',
  //         message: 'Purchase order added successfully',
  //         backgroundColor: const Color.fromARGB(255, 54, 162, 244),
  //       );
  //       // Navigate to another screen or update the UI
  //     } else {
  //       SnackbarUtils.showCustomSnackbar(
  //         title: 'Error',
  //         message: 'Failed to add purchase order. Please try again.',
  //         backgroundColor: const Color.fromARGB(255, 54, 162, 244),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     Get.back(); // Dismiss loading indicator on error
  //     SnackbarUtils.showCustomSnackbar(
  //       title: 'Error',
  //       message: 'Failed to add purchase order. Please try again.',
  //       backgroundColor: const Color.fromARGB(255, 34, 106, 248),
  //     );
  //   }
  // }
}
