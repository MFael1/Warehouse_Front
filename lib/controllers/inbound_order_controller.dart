import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/status_model.dart';
import 'package:flutter_web_dashboard/Model/supplier_model.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/helpers/deffrent_api_srevices.dart';
import 'package:get/get.dart';

class PurchaseOrderController extends GetxController {
  final GlobalKey<FormState> purchaseOrderFormKey = GlobalKey<FormState>();
  final API api = API();
  final UserService api2 = UserService();

  late TextEditingController orderDateController;
  late TextEditingController shipDateController;
  late TextEditingController deliveryDateController;
  late TextEditingController cancelDateController;
  late TextEditingController supplierController;
  late TextEditingController statusController;

  var items = <PurchaseOrderItem>[].obs;
  var itemsList = <PurchaseOrderItem>[].obs;
  var suppliersList = <Supplier>[].obs;

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
  var selectedSupplier = Rx<Supplier?>(null);
  var selectedSupplierId = 0.obs;

  get orders => null;

  @override
  void onInit() {
    super.onInit();

    _initializeControllers();
    fetchSuppliers();
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
    supplierController = TextEditingController();
    statusController = TextEditingController();
  }

  void _disposeControllers() {
    orderDateController.dispose();
    shipDateController.dispose();
    deliveryDateController.dispose();
    cancelDateController.dispose();
    supplierController.dispose();
    statusController.dispose();
  }

  Future<void> fetchItems() async {
    try {
      var fetchedItems = await api2.getItems();
      itemsList.value = fetchedItems.map((item) {
        return PurchaseOrderItem(
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

  Future<void> fetchSuppliers() async {
    try {
      var fetchedSuppliers =
          await api.getSupplier('https://localhost:7086/api/Supplier');
      suppliersList.value = fetchedSuppliers;
    } catch (e) {
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load suppliers',
      );
    }
  }

  String? validateStringField(String? value) {
    return (value == null || value.isEmpty)
        ? "This field cannot be empty"
        : null;
  }

  String? validateFacilityField(Facility? value) {
    return (value == null) ? "This field cannot be empty" : null;
  }

  void checkPurchaseOrder() {
    if (purchaseOrderFormKey.currentState == null) {
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Form state is null',
      );
      return;
    }

    final isValid = purchaseOrderFormKey.currentState!.validate();
    if (!isValid) return;

    purchaseOrderFormKey.currentState!.save();
    submitPurchaseOrder();
  }

  void addItem() {
    items.add(PurchaseOrderItem(
      itemId: 0,
      itemName: '',
      orderedQuantity: 0,
      deliveredQuantity: 0,
    ));
  }

  Future<void> submitPurchaseOrder() async {
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

    final data = {
      "order_date": orderDate.value,
      "ship_date": shipDate.value,
      "delivery_date": deliveryDate.value,
      "cancel_date": cancelDate.value,
      "facility_id": selectedFacility.value?.id,
      "supplier_id": selectedSupplierId.value,
      "status_id": selectedStatus.value?.id,
      "items": orderItemRequests.map((item) => item.toJson()).toList(),
    };

    Get.dialog(
      Center(child: CustomLoadingIndicator()),
      barrierDismissible: false,
    );

    try {
      var response = await api.postAddINboundOrder(
          'https://localhost:7086/api/po/ib_po', data);
      Get.back(); // Dismiss loading indicator

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        SnackbarUtils.showCustomSnackbar(
          title: 'Success',
          message: 'Purchase order added successfully',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      } else {
        SnackbarUtils.showCustomSnackbar(
          title: 'Error',
          message: 'Failed to add purchase order',
          backgroundColor: const Color.fromARGB(255, 244, 54, 54),
        );
      }
    } catch (e) {
      Get.back(); // Dismiss loading indicator on error
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'Failed to add purchase order. Please try again.',
        backgroundColor: const Color.fromARGB(255, 248, 34, 34),
      );
    }
  }

  String _formatDate(String date) {
    return DateTime.parse(date).toUtc().toIso8601String();
  }
}

class PurchaseOrderItem {
  int itemId;
  String itemName; // For display purposes
  TextEditingController orderedQuantityController;
  TextEditingController deliveredQuantityController;

  PurchaseOrderItem({
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
}

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
}
