import 'package:flutter_web_dashboard/Model/category_model.dart';
import 'package:flutter_web_dashboard/Model/company_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:flutter_web_dashboard/helpers/deffrent_api_srevices.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Model/Item.dart';

class ItemFormController extends GetxController {
  final GlobalKey<FormState> itemasterdataFormKey = GlobalKey<FormState>();

  final API api = API();
  final UserService api2 = UserService();

  var items = <Item>[].obs;
  var itemsList = <Item>[].obs;

  // Dropdown selections
  var selectedCompany = Rxn<Company>();
  var selectedFacility = Rxn<Facility>();
  var selectedCategory = Rxn<Category>();
  var selectedItem = Rx<Item?>(null);
  var selectedItemId = 0.obs;
  var timeToManufactureDate = ''.obs;

  // Text editing controllers
  late TextEditingController itemNbrController;
  late TextEditingController barcodeController;
  late TextEditingController descriptionController;
  late TextEditingController physicalDimensionController;
  late TextEditingController technicalSpecificationController;
  late TextEditingController minimumOrderSizeController;
  late TextEditingController timeToManufactureController;
  late TextEditingController purchaseCostController;
  late TextEditingController itemPricingController;
  late TextEditingController shippingCostController;

  @override
  void onInit() {
    super.onInit();

    _initializeControllers();
    fetchItem();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initializeControllers() {
    itemNbrController = TextEditingController();
    barcodeController = TextEditingController();
    descriptionController = TextEditingController();
    physicalDimensionController = TextEditingController();
    technicalSpecificationController = TextEditingController();
    minimumOrderSizeController = TextEditingController();
    timeToManufactureController = TextEditingController();
    purchaseCostController = TextEditingController();
    itemPricingController = TextEditingController();
    shippingCostController = TextEditingController();
  }

  void _disposeControllers() {
    // Dispose the controllers when the controller is destroyed
    itemNbrController.dispose();
    barcodeController.dispose();
    descriptionController.dispose();
    physicalDimensionController.dispose();
    technicalSpecificationController.dispose();
    minimumOrderSizeController.dispose();
    timeToManufactureController.dispose();
    purchaseCostController.dispose();
    itemPricingController.dispose();
    shippingCostController.dispose();
    super.onClose();
  }

  Future<void> fetchItem() async {
    try {
      var fetchedItem = await api2.getItemsforitemsMaster();
      itemsList.value = fetchedItem;
    } catch (e) {
      print(e);
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load Items',
      );
    }
  }

  // Form submission

  Future<void> submitForm() async {
    // Prepare the data
    final formData = {
      "item_nbr": selectedItem.value?.id ?? 0,
      "company_id": selectedCompany.value?.id ?? 0,
      "facility_id": selectedFacility.value?.id ?? 0,
      "barcode": barcodeController.text,
      "description": descriptionController.text,
      "physical_dimension": physicalDimensionController.text,
      "technical_specification": technicalSpecificationController.text,
      "minimum_order_size": int.tryParse(minimumOrderSizeController.text) ?? 0,
      "time_to_manufacture": timeToManufactureController.text,
      "purchase_cost": double.tryParse(purchaseCostController.text) ?? 0.0,
      "item_pricing": double.tryParse(itemPricingController.text) ?? 0.0,
      "shipping_cost": double.tryParse(shippingCostController.text) ?? 0.0,
      "putaway_type_id": selectedCategory.value?.id ?? 0,
    };

    // Define the API URL
    String apiUrl = 'https://localhost:7086/api/ItemMaster';

    try {
      print('formData : ${formData}');
      // Call the postAddMasterData function
      var response = await api.postAddMasterData(apiUrl, formData);

      // Handle the response
      if (response != null && response.statusCode == 201) {
        // Handle success (e.g., show a success message)
        SnackbarUtils.showCustomSnackbar(
          backgroundColor: Colors.lightBlueAccent,
          title: 'Success',
          message: 'Item data added successfully',
        );
      } else {
        // Handle failure (e.g., show an error message)
        SnackbarUtils.showCustomSnackbar(
          backgroundColor: const Color.fromARGB(255, 255, 64, 64),
          title: 'Error',
          message: 'Failed to add item data. Please try again.',
        );
      }
    } catch (e) {
      // Handle exception (e.g., show an error message)
      SnackbarUtils.showCustomSnackbar(
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
