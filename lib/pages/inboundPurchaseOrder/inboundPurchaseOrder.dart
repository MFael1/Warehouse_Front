import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/status_model.dart';
import 'package:flutter_web_dashboard/Model/supplier_model.dart';
import 'package:flutter_web_dashboard/controllers/inbound_order_controller.dart';
import 'package:flutter_web_dashboard/pages/inboundPurchaseOrder/widgets/DateFormFieldWidget.dart';
import 'package:flutter_web_dashboard/pages/inboundPurchaseOrder/widgets/ElevatedButtonWidget.dart';
import 'package:flutter_web_dashboard/pages/inboundPurchaseOrder/widgets/TextFormFieldWidget.dart';
import 'package:get/get.dart';

class InboundPurchaseOrderScreen extends StatefulWidget {
  @override
  State<InboundPurchaseOrderScreen> createState() =>
      _InboundPurchaseOrderScreenState();
}

class _InboundPurchaseOrderScreenState
    extends State<InboundPurchaseOrderScreen> {
  late PurchaseOrderController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PurchaseOrderController());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 7,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: controller.purchaseOrderFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownSearch<Facility>(
                      items: PurchaseOrderController.facilities,
                      itemAsString: (Facility facility) =>
                          facility.facilityCode,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Select Facility',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search Facility...',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item.facilityCode),
                            selected: isSelected,
                            selectedTileColor: Colors.blue.withOpacity(0.2),
                          );
                        },
                      ),
                      onChanged: (Facility? newValue) {
                        if (newValue != null) {
                          controller.selectedFacility.value = newValue;
                        }
                      },
                      validator: (value) =>
                          controller.validateFacilityField(value),
                    ),
                    const SizedBox(height: 16),
                    DropdownSearch<Status>(
                      items: controller.statusList,
                      itemAsString: (Status status) => status.status,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Select Order Status',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                      onChanged: (Status? newValue) {
                        if (newValue != null) {
                          controller.selectedStatus.value = newValue;
                        }
                      },
                      validator: (value) =>
                          controller.validateStringField(value?.status),
                    ),
                    const SizedBox(height: 16),
                    DateFormFieldWidget(
                      controller: controller.orderDateController,
                      labelText: 'Order Date',
                      onChanged: (date) {
                        controller.orderDate.value = date;
                      },
                    ),
                    const SizedBox(height: 16),
                    DateFormFieldWidget(
                      controller: controller.shipDateController,
                      labelText: 'Ship Date',
                      onChanged: (date) {
                        controller.shipDate.value = date;
                      },
                    ),
                    const SizedBox(height: 16),
                    DateFormFieldWidget(
                      controller: controller.deliveryDateController,
                      labelText: 'Delivery Date',
                      onChanged: (date) {
                        controller.deliveryDate.value = date;
                      },
                    ),
                    const SizedBox(height: 16),
                    DateFormFieldWidget(
                      controller: controller.cancelDateController,
                      labelText: 'Cancel Date',
                      onChanged: (date) {
                        controller.cancelDate.value = date;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownSearch<Supplier>(
                      items: controller.suppliersList,
                      itemAsString: (Supplier supplier) => supplier.name,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Select Supplier',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search Supplier...',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item.name),
                            selected: isSelected,
                            selectedTileColor: Colors.blue.withOpacity(0.2),
                          );
                        },
                      ),
                      onChanged: (Supplier? newValue) {
                        if (newValue != null) {
                          controller.selectedSupplier.value = newValue;
                          controller.selectedSupplierId.value = newValue.id;
                        }
                      },
                      validator: (value) =>
                          controller.validateStringField(value?.name),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => Column(
                          children: [
                            for (int i = 0; i < controller.items.length; i++)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            DropdownSearch<PurchaseOrderItem>(
                                          items: controller.itemsList,
                                          itemAsString:
                                              (PurchaseOrderItem item) =>
                                                  item.itemName,
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              labelText: 'Select Item',
                                              border: OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                          popupProps: PopupProps.menu(
                                            showSearchBox: true,
                                            searchFieldProps: TextFieldProps(
                                              decoration: InputDecoration(
                                                hintText: 'Search Item...',
                                                border: OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            itemBuilder:
                                                (context, item, isSelected) {
                                              return ListTile(
                                                title: Text(item.itemName),
                                                selected: isSelected,
                                                selectedTileColor: Colors.blue
                                                    .withOpacity(0.2),
                                              );
                                            },
                                          ),
                                          onChanged:
                                              (PurchaseOrderItem? newValue) {
                                            if (newValue != null) {
                                              controller.items[i].itemId =
                                                  newValue.itemId;
                                              controller.items[i].itemName =
                                                  newValue.itemName;
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormFieldWidget(
                                          controller: controller.items[i]
                                              .orderedQuantityController,
                                          labelText: 'Ordered Quantity',
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormFieldWidget(
                                          controller: controller.items[i]
                                              .deliveredQuantityController,
                                          labelText: 'Received Quantity',
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                        ),
                                      ),
                                      if (i == controller.items.length - 1)
                                        IconButton(
                                          icon: Icon(Icons.add_circle,
                                              color: Colors.green),
                                          onPressed: controller.addItem,
                                        ),
                                      if (i > 0)
                                        IconButton(
                                          icon: Icon(Icons.remove_circle,
                                              color: Colors.red),
                                          onPressed: () {
                                            controller.items.removeAt(i);
                                          },
                                        ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            const SizedBox(height: 20),
                            ElevatedButtonWidget(
                              onPressed: controller.checkPurchaseOrder,
                              text: 'Submit Order',
                              color: Colors.blueAccent,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
