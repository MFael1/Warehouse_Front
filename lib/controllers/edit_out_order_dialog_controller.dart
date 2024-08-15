import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/customer_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/out_order_model.dart'; // Ensure this model exists
import 'package:flutter_web_dashboard/Model/status_model.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/helpers/deffrent_api_srevices.dart';
import 'package:get/get.dart';

class EditOutboundOrderController extends GetxController {
  final GlobalKey<FormState> editOutboundOrderFormKey = GlobalKey<FormState>();
  final API api = API();
  final UserService api2 = UserService();

  late TextEditingController orderDateController;
  late TextEditingController shipDateController;
  late TextEditingController deliveryDateController;
  late TextEditingController cancelDateController;
  late TextEditingController customerController;
  late TextEditingController addressController;
  late TextEditingController statusController;

  var items = <OutorderItemEdit>[].obs;
  var itemsList = <OutorderItemEdit>[].obs;
  var customersList = <Customer>[].obs;

  static final List<Facility> facilities = [
    Facility(id: 1, facilityCode: "JAPAN_007"),
    Facility(id: 2, facilityCode: "USA_O37"),
    Facility(id: 3, facilityCode: "TOKYO_777"),
    Facility(id: 4, facilityCode: "DAMASCUS_001"),
  ];

  var statusList = <Status>[
    Status(id: 1, status: "Ordered"),
    Status(id: 2, status: "Delivered"),
    Status(id: 3, status: "Canceled"),
    Status(id: 4, status: "Shipped"),
  ].obs;

  var selectedFacility = Rx<Facility?>(null);
  var selectedStatus = Rx<Status?>(null);

  var orderDate = ''.obs;
  var shipDate = ''.obs;
  var deliveryDate = ''.obs;
  var cancelDate = ''.obs;
  var selectedCustomers = Rx<Customer?>(null);
  var selectedCustomerId = 0.obs;

  get orders => null;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    fetchCustoemr();
    fetchItems();
    addItem();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initializeControllers() {
    orderDateController = TextEditingController();
    shipDateController = TextEditingController();
    deliveryDateController = TextEditingController();
    cancelDateController = TextEditingController();
    customerController = TextEditingController();
    addressController = TextEditingController();
    statusController = TextEditingController();
  }

  void _disposeControllers() {
    orderDateController.dispose();
    shipDateController.dispose();
    deliveryDateController.dispose();
    cancelDateController.dispose();
    customerController.dispose();
    addressController.dispose();
    statusController.dispose();
  }

  Future<void> fetchItems() async {
    try {
      var fetchedItems = await api2.getItems();
      itemsList.value = fetchedItems.map((item) {
        return OutorderItemEdit(
          itemId: item['id'],
          itemName: item['name'],
          orderedQuantity: 0,
          deliveredQuantity: 0,
          shippedQuantity: 0,
        );
      }).toList();
    } catch (e) {
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load items: $e',
      );
    }
  }

  Future<void> fetchCustoemr() async {
    try {
      var fetchedCustomers =
          await api.getCustomer('https://localhost:7086/api/Customer');
      customersList.value = fetchedCustomers;
    } catch (e) {
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load customres',
      );
    }
  }

  String? validateDateField(String? value) {
    return (value == null || value.isEmpty)
        ? "This field cannot be empty"
        : null;
  }

  void checkOutboundOrder() {
    if (editOutboundOrderFormKey.currentState == null) {
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Form state is null',
      );
      return;
    }

    final isValid = editOutboundOrderFormKey.currentState!.validate();
    if (!isValid) return;

    editOutboundOrderFormKey.currentState!.save();
    submitOutboundOrder();
  }

  void addItem() {
    items.add(OutorderItemEdit(
      itemId: 0,
      itemName: '',
      orderedQuantity: 0,
      deliveredQuantity: 0,
      shippedQuantity: 0,
    ));
  }

  Future<void> submitOutboundOrder() async {
    orderDate.value = _formatDate(orderDateController.text);
    shipDate.value = _formatDate(shipDateController.text);
    deliveryDate.value = _formatDate(deliveryDateController.text);
    cancelDate.value = _formatDate(cancelDateController.text);
    final List<OrderItemRequest> orderItemRequests = items.map((item) {
      return OrderItemRequest(
        itemId: item.itemId,
        orderedQuantity: item.orderedQuantity,
        deliveredQuantity: item.deliveredQuantity,
        shippedQuantity: item.shippedQuantity,
      );
    }).toList();
    final data = {
      "order_date": orderDate.value,
      "ship_date": shipDate.value,
      "delivery_date": deliveryDate.value,
      "cancel_date": cancelDate.value,
      "facility_id": selectedFacility.value?.id,
      "status_id": selectedStatus.value?.id,
      "items": orderItemRequests.map((item) => item.toJson()).toList(),
    };

    Get.dialog(
      Center(child: CustomLoadingIndicator()),
      barrierDismissible: false,
    );

    // try {
    //   final poNbr =
    //       'YOUR_ORDER_NUMBER_HERE'; // Replace with the actual order number
    //   final success = await api.updateOUTorder(
    //     'https://localhost:7086/api/po/in_po', // API endpoint
    //     data,
    //   );
    //   Get.back(); // Dismiss loading indicator

    //   if (success) {
    //     SnackbarUtils.showCustomSnackbar(
    //       title: 'Success',
    //       message: 'Outbound order updated successfully',
    //       backgroundColor: const Color.fromARGB(255, 54, 162, 244),
    //     );
    //   } else {
    //     SnackbarUtils.showCustomSnackbar(
    //       title: 'Error',
    //       message: 'Failed to update outbound order',
    //       backgroundColor: const Color.fromARGB(255, 244, 54, 54),
    //     );
    //   }
    // } catch (e) {
    //   Get.back(); // Dismiss loading indicator on error
    //   SnackbarUtils.showCustomSnackbar(
    //     title: 'Error',
    //     message: 'Failed to update outbound order. Please try again.',
    //     backgroundColor: const Color.fromARGB(255, 248, 34, 34),
    //   );
    // }
  }

  String _formatDate(String date) {
    return DateTime.parse(date).toUtc().toIso8601String();
  }
}

class OutorderItemEdit {
  int itemId;
  String itemName; // For display purposes
  TextEditingController orderedQuantityController;
  TextEditingController deliveredQuantityController;
  TextEditingController shippedQuantityController;

  OutorderItemEdit({
    required this.itemId,
    required this.itemName,
    required int orderedQuantity,
    required int deliveredQuantity,
    required int shippedQuantity,
  })  : orderedQuantityController =
            TextEditingController(text: orderedQuantity.toString()),
        deliveredQuantityController =
            TextEditingController(text: deliveredQuantity.toString()),
        shippedQuantityController =
            TextEditingController(text: shippedQuantity.toString());

  int get orderedQuantity => int.tryParse(orderedQuantityController.text) ?? 0;
  int get deliveredQuantity =>
      int.tryParse(deliveredQuantityController.text) ?? 0;

  int get shippedQuantity => int.tryParse(shippedQuantityController.text) ?? 0;
}

class OrderItemRequest {
  int itemId;
  int orderedQuantity;
  int deliveredQuantity;
  int shippedQuantity;

  OrderItemRequest({
    required this.itemId,
    required this.orderedQuantity,
    required this.deliveredQuantity,
    required this.shippedQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'ordered_quantity': orderedQuantity,
      'delivered_quantity': deliveredQuantity,
      'shipped_quantity': shippedQuantity,
    };
  }
}
