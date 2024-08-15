import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/customer_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/out_order_model.dart'; // Ensure this model exists
import 'package:flutter_web_dashboard/Model/status_model.dart';
import 'package:flutter_web_dashboard/constants/local_data.dart';
import 'package:flutter_web_dashboard/controllers/edit_out_order_dialog_controller.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:get/get.dart';

class EditOutboundOrderDialog extends StatelessWidget {
  final OutboundOrderModel order; // Ensure this model exists
  final VoidCallback onSaveSuccess;
  final API api = API(); // Instantiate API

  EditOutboundOrderDialog({required this.order, required this.onSaveSuccess});

  @override
  Widget build(BuildContext context) {
    final EditOutboundOrderController controller =
        Get.put(EditOutboundOrderController());

    // Initialize fields with current order data
    controller.orderDateController.text =
        order.orderDate.toUtc().toIso8601String();
    controller.shipDateController.text =
        order.shipDate.toUtc().toIso8601String();
    controller.deliveryDateController.text =
        order.deliveryDate.toUtc().toIso8601String();
    controller.cancelDateController.text =
        order.cancelDate.toUtc().toIso8601String();

    controller.addressController.text = order.address.toString();
    controller.selectedFacility.value = order.facility;
    controller.selectedCustomers.value = order.customer;
    controller.selectedStatus.value = order.status;

    return AlertDialog(
      title: Text('Edit Outbound Order'),
      content: SingleChildScrollView(
        child: Form(
          key: controller.editOutboundOrderFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdown<Facility>(
                items: EditOutboundOrderController.facilities,
                selectedItem: order.facility,
                label: 'Select Facility',
                onChanged: (Facility? newValue) {
                  if (newValue != null) {
                    controller.selectedFacility.value = newValue;
                  }
                },
                itemAsString: (Facility facility) => facility.facilityCode,
              ),
              SizedBox(height: 16),
              _buildDropdown<Customer>(
                items: controller.customersList,
                selectedItem: order.customer,
                label: 'Select Supplier',
                onChanged: (Customer? newValue) {
                  if (newValue != null) {
                    controller.selectedCustomers.value = newValue;
                    controller.selectedCustomerId.value = newValue.id;
                  }
                },
                itemAsString: (Customer customer) => customer.name,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: controller.addressController,
                label: 'Address',
              ),
              SizedBox(height: 16),
              _buildDropdown<Status>(
                items: LocalData.statuses,
                selectedItem: order.status,
                label: 'Select Status',
                onChanged: (Status? newValue) {
                  if (newValue != null) {
                    controller.selectedStatus.value = newValue;
                  }
                },
                itemAsString: (Status status) => status.status,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: controller.orderDateController,
                label: 'Order Date',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: controller.shipDateController,
                label: 'Ship Date',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: controller.deliveryDateController,
                label: 'Delivery Date',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: controller.cancelDateController,
                label: 'Cancel Date',
              ),
              SizedBox(height: 16),
              ...order.items.map((item) {
                // Assuming you have a way to convert `Item` to `OutorderItemEdit`
                // You need to handle this conversion appropriately
                return Column(
                  children: [
                    DropdownSearch<OutorderItemEdit>(
                      items: controller.itemsList,
                      itemAsString: (OutorderItemEdit item) => item.itemName,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Select Item',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search Item...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text((item as OutorderItemEdit).itemName),
                            selected: isSelected,
                          );
                        },
                      ),
                      onChanged: (OutorderItemEdit? newValue) {
                        if (newValue != null) {
                          final index = order.items
                              .indexWhere((i) => i.id == newValue.itemId);
                          if (index != -1) {
                            order.items[index] = Item(
                              id: newValue.itemId,
                              name: newValue.itemName,
                              orderedQuantity:
                                  order.items[index].orderedQuantity,
                              deliveredQuantity:
                                  order.items[index].deliveredQuantity,
                              shippedQuantity:
                                  order.items[index].shippedQuantity,
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    _buildQuantityField(
                      label: 'Ordered Quantity',
                      initialValue: item.orderedQuantity.toString(),
                      onChanged: (value) {
                        item.orderedQuantity = int.tryParse(value) ?? 0;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildQuantityField(
                      label: 'Delivered Quantity',
                      initialValue: item.deliveredQuantity.toString(),
                      onChanged: (value) {
                        item.deliveredQuantity = int.tryParse(value) ?? 0;
                      },
                    ),
                    SizedBox(height: 24),
                  ],
                );
              }).toList(),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final requestData = {
                          "poNbr": order.poNbr,
                          "order_date": controller.orderDateController.text,
                          "ship_date": controller.shipDateController.text,
                          "delivery_date":
                              controller.deliveryDateController.text,
                          "cancel_date": controller.cancelDateController.text,
                          "facility_id":
                              controller.selectedFacility.value?.id ?? 0,
                          "customer_id":
                              controller.selectedCustomers.value?.id ?? 0,
                          "status_id": controller.selectedStatus.value?.id ?? 0,
                          "address": controller.addressController.text,
                          "items": order.items.map((item) {
                            return {
                              "item_id": item.id,
                              "ordered_quantity": item.orderedQuantity,
                              "delivered_quantity": item.deliveredQuantity,
                            };
                          }).toList(),
                        };

                        final url = 'https://localhost:7086/api/po/in_po';

                        final success =
                            await api.updateOUTorder(url, requestData);

                        if (success) {
                          Get.back();
                          Get.snackbar(
                              'Success', 'Purchase order updated successfully');
                          onSaveSuccess();
                        } else {
                          Get.snackbar(
                              'Error', 'Failed to update purchase order');
                        }
                      } catch (e) {
                        Get.snackbar('Error',
                            'An error occurred while updating the purchase order');
                      }
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      // onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      elevation: 5,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      // primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required List<T> items,
    required T selectedItem,
    required String label,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemAsString,
  }) {
    return DropdownSearch<T>(
      items: items,
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildQuantityField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }
}
