import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_dashboard/Model/customer_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/status_model.dart';
import 'package:flutter_web_dashboard/controllers/OutboundOrderController.dart';
import 'package:flutter_web_dashboard/pages/OutboundOrderScreen/widgets/DateFormFieldWidget.dart';
import 'package:flutter_web_dashboard/pages/OutboundOrderScreen/widgets/DropdownSearchWidget.dart';
import 'package:flutter_web_dashboard/pages/OutboundOrderScreen/widgets/TextFormFieldWidget.dart';
import 'package:flutter_web_dashboard/pages/inboundPurchaseOrder/widgets/ElevatedButtonWidget.dart';
import 'package:get/get.dart';

class OutboundOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OutboundOrderController controller =
        Get.put(OutboundOrderController());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: controller.outboundOrderFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownSearchWidget<Facility>(
                      items: OutboundOrderController.facilities,
                      hint: 'Select Facility',
                      itemAsString: (Facility facility) =>
                          facility.facilityCode,
                      onChanged: (Facility? newValue) {
                        if (newValue != null) {
                          controller.selectedFacility.value = newValue;
                        }
                      },
                      validator: (value) =>
                          controller.validateFacilityField(value),
                    ),
                    const SizedBox(height: 16),
                    DropdownSearchWidget<Status>(
                      items: controller.statusList,
                      hint: 'Select Order Status',
                      itemAsString: (Status status) => status.status,
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
                      onChanged: (date) => controller.orderDate.value = date,
                    ),
                    const SizedBox(height: 16),
                    DateFormFieldWidget(
                      controller: controller.shipDateController,
                      labelText: 'Ship Date',
                      onChanged: (date) => controller.shipDate.value = date,
                    ),
                    const SizedBox(height: 16),
                    DateFormFieldWidget(
                      controller: controller.deliveryDateController,
                      labelText: 'Delivery Date',
                      onChanged: (date) => controller.deliveryDate.value = date,
                    ),
                    const SizedBox(height: 16),
                    DateFormFieldWidget(
                      controller: controller.cancelDateController,
                      labelText: 'Cancel Date',
                      onChanged: (date) => controller.cancelDate.value = date,
                    ),
                    const SizedBox(height: 16),
                    DropdownSearchWidget<Customer>(
                      items: controller.customersList,
                      hint: 'Select Customer',
                      itemAsString: (Customer customer) => customer.name,
                      onChanged: (Customer? newValue) {
                        if (newValue != null) {
                          controller.selectedCustomer.value = newValue;
                          controller.selectedCustomersID.value = newValue.id;
                        }
                      },
                      validator: (value) =>
                          controller.validateStringField(value?.name),
                    ),
                    const SizedBox(height: 16),
                    TextFormFieldWidget(
                      controller: controller.addressController,
                      labelText: 'Address',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Obx(() => Column(
                    children: [
                      for (int i = 0; i < controller.items.length; i++)
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownSearchWidget<
                                      PurchaseoutOrderItem>(
                                    items: controller.itemsList,
                                    hint: 'Select Item',
                                    itemAsString: (PurchaseoutOrderItem item) =>
                                        item.itemName,
                                    onChanged:
                                        (PurchaseoutOrderItem? newValue) {
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
                                    controller: controller
                                        .items[i].orderedQuantityController,
                                    labelText: 'Ordered Quantity',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormFieldWidget(
                                    controller: controller
                                        .items[i].deliveredQuantityController,
                                    labelText: 'Received Quantity',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
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
                        onPressed: controller.checkOutboundOrder,
                        text: 'Submit Order',
                        color: Colors.blueAccent,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
