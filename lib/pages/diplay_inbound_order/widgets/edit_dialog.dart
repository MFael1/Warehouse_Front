// Import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/inbound_order.dart';
import 'package:flutter_web_dashboard/constants/local_data.dart';
import 'package:flutter_web_dashboard/controllers/edit_in_bound_order_controller.dart';
import 'package:flutter_web_dashboard/Model/status_model.dart';
import 'package:flutter_web_dashboard/Model/supplier_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:get/get.dart';

class EditPurchaseOrderDialog extends StatelessWidget {
  final Editinordercontroller controller = Get.put(Editinordercontroller());
  final INboundOrder order;
  final VoidCallback onSaveSuccess;
  var api = API();

  EditPurchaseOrderDialog({required this.order, required this.onSaveSuccess});

  @override
  Widget build(BuildContext context) {
    controller.orderDateController.text = order.orderDate.toIso8601String();
    controller.shipDateController.text = order.shipDate.toIso8601String();
    controller.deliveryDateController.text =
        order.deliveryDate.toIso8601String();
    controller.cancelDateController.text = order.cancelDate.toIso8601String();

    controller.selectedFacility.value = order.facility;
    controller.selectedSupplier.value = order.supplier;
    controller.selectedStatus.value = order.status;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Text('Edit Purchase Order'),
      contentPadding: EdgeInsets.all(16.0),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: 600,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Facility Dropdown
                DropdownSearch<Facility>(
                  items: Editinordercontroller.facilities,
                  selectedItem: order.facility,
                  itemAsString: (Facility facility) => facility.facilityCode,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select Facility',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  onChanged: (Facility? newValue) {
                    if (newValue != null) {
                      controller.selectedFacility.value = newValue;
                    }
                  },
                ),
                SizedBox(height: 16),

                // Supplier Dropdown
                DropdownSearch<Supplier>(
                  items: controller.suppliersList,
                  selectedItem: order.supplier,
                  itemAsString: (Supplier supplier) => supplier.name,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select Supplier',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  onChanged: (Supplier? newValue) {
                    if (newValue != null) {
                      controller.selectedSupplier.value = newValue;
                      controller.selectedSupplierId.value = newValue.id;
                    }
                  },
                ),
                SizedBox(height: 16),

                // Status Dropdown
                DropdownSearch<Status>(
                  items: LocalData.statuses,
                  selectedItem: order.status,
                  itemAsString: (Status status) => status.status,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select Status',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  onChanged: (Status? newValue) {
                    if (newValue != null) {
                      controller.selectedStatus.value = newValue;
                    }
                  },
                ),
                SizedBox(height: 16),

                // Order Date
                TextFormField(
                  controller: controller.orderDateController,
                  decoration: InputDecoration(
                    labelText: 'Order Date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 16),

                // Ship Date
                TextFormField(
                  controller: controller.shipDateController,
                  decoration: InputDecoration(
                    labelText: 'Ship Date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 16),

                // Delivery Date
                TextFormField(
                  controller: controller.deliveryDateController,
                  decoration: InputDecoration(
                    labelText: 'Delivery Date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 16),

                // Cancel Date
                TextFormField(
                  controller: controller.cancelDateController,
                  decoration: InputDecoration(
                    labelText: 'Cancel Date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 16),

                // Items List
                ...order.items.map((item) {
                  return Column(
                    children: [
                      DropdownSearch<InorderItemEdit>(
                        items: controller.itemsList,
                        itemAsString: (InorderItemEdit item) => item.itemName,
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
                              title: Text((item as InorderItemEdit).itemName),
                              selected: isSelected,
                            );
                          },
                        ),
                        onChanged: (InorderItemEdit? newValue) {
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
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: item.orderedQuantity.toString(),
                        decoration: InputDecoration(
                          labelText: 'Ordered Quantity',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          item.orderedQuantity = int.tryParse(value) ?? 0;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: item.deliveredQuantity.toString(),
                        decoration: InputDecoration(
                          labelText: 'Delivered Quantity',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          item.deliveredQuantity = int.tryParse(value) ?? 0;
                        },
                      ),
                      SizedBox(height: 24),
                    ],
                  );
                }).toList(),

                // Buttons
                Column(
                  children: [
                    // Save Button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final requestData = {
                              "poNbr": order.poNbr,
                              "order_date": _formatDate(
                                  controller.orderDateController.text),
                              "ship_date": _formatDate(
                                  controller.shipDateController.text),
                              "delivery_date": _formatDate(
                                  controller.deliveryDateController.text),
                              "cancel_date": _formatDate(
                                  controller.cancelDateController.text),
                              "facility_id":
                                  controller.selectedFacility.value?.id ?? 0,
                              "supplier_id":
                                  controller.selectedSupplier.value?.id ?? 0,
                              "status_id":
                                  controller.selectedStatus.value?.id ?? 0,
                              "items": order.items.map((item) {
                                return {
                                  "item_id": item.id,
                                  "ordered_quantity": item.orderedQuantity,
                                  "delivered_quantity": item.deliveredQuantity,
                                };
                              }).toList()
                            };

                            final url = 'https://localhost:7086/api/po/ib_po';

                            final success =
                                await api.updateINorder(url, requestData);

                            if (success) {
                              Get.back();
                              Get.snackbar('Success',
                                  'Purchase order updated successfully');
                              onSaveSuccess();
                            } else {
                              Get.snackbar(
                                  'Error', 'Failed to update purchase order');
                            }
                          } catch (e) {
                            Get.snackbar('Error',
                                'An error occurred while updating the purchase order');
                          }
                        }
                      },
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        elevation: 5,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Cancel Button
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    return DateTime.parse(date).toUtc().toIso8601String();
  }
}
