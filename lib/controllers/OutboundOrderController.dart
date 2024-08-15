import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/customer_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/status_model.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/helpers/deffrent_api_srevices.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';

class OutboundOrderController extends GetxController {
  final GlobalKey<FormState> outboundOrderFormKey = GlobalKey<FormState>();

  var api = API();
  final UserService api2 = UserService();

  late TextEditingController orderDateController,
      shipDateController,
      deliveryDateController,
      cancelDateController,
      customerController,
      addressController,
      statusController;

  var items = <PurchaseoutOrderItem>[].obs; // Changed to PurchaseOrderItem
  var itemsList = <PurchaseoutOrderItem>[].obs;
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
  var selectedCustomer = Rx<Customer?>(null); // Store selected customer ID
  var selectedCustomersID = 0.obs; // Store customers

  @override
  void onInit() {
    super.onInit();
    orderDateController = TextEditingController();
    shipDateController = TextEditingController();
    deliveryDateController = TextEditingController();
    cancelDateController = TextEditingController();
    customerController = TextEditingController();
    addressController = TextEditingController();
    statusController = TextEditingController();

    fetchCustomers();
    fetchItems();
    addItem();
  }

  @override
  void onClose() {
    orderDateController.dispose();
    shipDateController.dispose();
    deliveryDateController.dispose();
    cancelDateController.dispose();
    customerController.dispose();
    addressController.dispose();
    statusController.dispose();
    super.onClose();
  }

  Future<void> fetchCustomers() async {
    const url =
        'https://localhost:7086/api/Customer'; // Replace with your actual URL

    try {
      print('Fetching customers from $url');
      var fetchedCustomers = await api.getCustomer(url);
      customersList.value = fetchedCustomers;
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  Future<void> fetchItems() async {
    try {
      var fetchedItems = await api2.getItems();
      itemsList.value = fetchedItems.map((item) {
        return PurchaseoutOrderItem(
          itemId: item['id'],
          itemName: item['name'],
          orderedQuantity: 0,
          deliveredQuantity: 0,
        );
      }).toList();
    } catch (e) {
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load items: $e',
      );
    }
  }

  String? validateFacilityField(Facility? value) {
    if (value == null) {
      return 'Please select a facility';
    }
    return null;
  }

  String? validateStatusField(Status? value) {
    if (value == null) {
      return 'Please select a status';
    }
    return null;
  }

  String? validateStringField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void checkOutboundOrder() {
    final isValid = outboundOrderFormKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    submitOutboundOrder();
  }

  void addItem() {
    items.add(PurchaseoutOrderItem(
      itemId: 0,
      itemName: '',
      orderedQuantity: 0,
      deliveredQuantity: 0,
    ));
  }

  Future<void> submitOutboundOrder() async {
    // print('Facility ID: ${selectedFacility.value?.id}');
    // print('Order Date: ${orderDate.value}');
    // print('Ship Date: ${shipDate.value}');
    // print('Delivery Date: ${deliveryDate.value}');
    // print('Cancel Date: ${cancelDate.value}');
    // print('CustomerID: ${selectedCustomerId.value}');
    // print('Address: ${addressController.text}');
    // print('Status ID: ${selectedStatus.value?.id}');
    // print('Status: ${selectedStatus.value?.status}');

    // for (var item in items) {
    //   print('Item ID: ${item.itemId}');
    //   print('Item Name: ${item.itemName}');
    //   print('Ordered Quantity: ${item.orderedQuantity}');
    //   print('Delivered Quantity: ${item.deliveredQuantity}');
    // }
    orderDate.value = _formatDate(orderDateController.text);
    shipDate.value = _formatDate(shipDateController.text);
    deliveryDate.value = _formatDate(deliveryDateController.text);
    cancelDate.value = _formatDate(cancelDateController.text);

    final List<OrderItemRequest> orderItemRequests = items.map((item) {
      return OrderItemRequest(
        itemId: item.itemId,
        orderedQuantity: item.orderedQuantity,
        deliveredQuantity: item.deliveredQuantity,
      );
    }).toList();

    // Replace with your API endpoint
    const url = 'https://localhost:7086/api/po/in_po';

    final data = {
      // "_po": 1,
      "facility_id": selectedFacility.value?.id,
      "order_date": orderDate.value,
      "ship_date": shipDate.value,
      "delivery_date": deliveryDate.value,
      "cancel_date": cancelDate.value,
      "customer_id": selectedCustomersID.value,
      "address": addressController.text,
      "status_id": selectedStatus.value?.id,
      "items": orderItemRequests.map((item) => item.toJson()).toList(),
    };

    // Show loading indicator
    Get.dialog(
      Center(child: CustomLoadingIndicator()),
      barrierDismissible: false,
    );
    Get.back();
    try {
      var response = await api.postAddOutboundOrder(url, data);
      Get.back(); // Dismiss loading indicator

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        SnackbarUtils.showCustomSnackbar(
          title: 'Success',
          message: 'Outbound order added successfully',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      } else {
        SnackbarUtils.showCustomSnackbar(
          title: 'Error',
          message: 'Failed to add outbound order.',
          backgroundColor: Color.fromARGB(255, 244, 54, 54),
        );
      }
    } catch (e) {
      Get.back(); // Dismiss loading indicator on error
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to add outbound order. Please try again.',
        backgroundColor: Color.fromARGB(255, 248, 34, 34),
      );
    }
  }

  String _formatDate(String date) {
    return DateTime.parse(date).toUtc().toIso8601String();
  }
}

// Define the PurchaseOrderItem class
class PurchaseoutOrderItem {
  int itemId;
  String itemName;
  TextEditingController orderedQuantityController;
  TextEditingController deliveredQuantityController;

  PurchaseoutOrderItem({
    required this.itemId,
    required this.itemName,
    required int orderedQuantity,
    required int deliveredQuantity,
  })  : orderedQuantityController =
            TextEditingController(text: orderedQuantity.toString()),
        deliveredQuantityController =
            TextEditingController(text: deliveredQuantity.toString());

  int get orderedQuantity => int.tryParse(orderedQuantityController.text) ?? 0;
  int get deliveredQuantity =>
      int.tryParse(deliveredQuantityController.text) ?? 0;

  OrderItemRequest toOrderItemRequest() {
    return OrderItemRequest(
      itemId: itemId,
      orderedQuantity: orderedQuantity,
      deliveredQuantity: deliveredQuantity,
    );
  }
}

// Define the OrderItemRequest class
class OrderItemRequest {
  final int itemId;
  final int orderedQuantity;
  final int deliveredQuantity;

  OrderItemRequest({
    required this.itemId,
    required this.orderedQuantity,
    required this.deliveredQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'ordered_quantity': orderedQuantity,
      'delivered_quantity': deliveredQuantity,
    };
  }

  factory OrderItemRequest.fromJson(Map<String, dynamic> json) {
    return OrderItemRequest(
      itemId: json['item_id'],
      orderedQuantity: json['ordered_quantity'],
      deliveredQuantity: json['delivered_quantity'],
    );
  }
}
