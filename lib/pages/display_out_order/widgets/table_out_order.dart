import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/inbound_order.dart';
import 'package:flutter_web_dashboard/Model/out_order_model.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/constants/style.dart';

import 'package:flutter_web_dashboard/controllers/display_outordre_controller.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:flutter_web_dashboard/pages/display_out_order/widgets/delet_dialog.dart';
import 'package:flutter_web_dashboard/pages/display_out_order/widgets/edit_outorder_dialog.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:get/get.dart';

class OutboundOrderTable extends StatefulWidget {
  @override
  _OutboundOrderTableState createState() => _OutboundOrderTableState();
}

API api = API();

class _OutboundOrderTableState extends State<OutboundOrderTable> {
  late Future<List<OutboundOrderModel>> futurePurchaseOrders;

  @override
  void initState() {
    super.initState();
    Get.put(DisplayOutorder());
    futurePurchaseOrders = api.getOutboundOrder(); // Fetch purchase orders
  }

  void _refreshData() {
    setState(() {
      futurePurchaseOrders = api.getOutboundOrder();
    });
  }

  Future<bool> _deleteOrder(int id) async {
    try {
      bool success =
          await api.deleteOUTorder('https://localhost:7086/api/po/in_po/', id);
      if (success) {
        Get.back();
        SnackbarUtils.showCustomSnackbar(
          title: 'Success',
          message: 'The Delete success',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
        _refreshData();
      } else {
        print(id);
        SnackbarUtils.showCustomSnackbar(
          title: 'Warrning',
          message: 'The Delete Failed',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      }
      return success;
    } catch (e) {
      print('Delete order error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OutboundOrderModel>>(
      future: futurePurchaseOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No purchase orders found'));
        } else {
          List<OutboundOrderModel> purchaseOrders = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: active.withOpacity(.4), width: .5),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 6),
                    color: lightGrey.withOpacity(.1),
                    blurRadius: 12)
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 30),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 12,
                  headingRowHeight: 40,
                  horizontalMargin: 12,
                  border: TableBorder.all(
                      color: active.withOpacity(.4), width: 0.5),
                  columns: const [
                    DataColumn(label: Text('PO Number')),
                    DataColumn(label: Text('Order Date')),
                    DataColumn(label: Text('Ship Date')),
                    DataColumn(label: Text('Delivery Date')),
                    DataColumn(label: Text('Cancel Date')),
                    DataColumn(label: Text('Facility Code')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Ordered Quantity')),
                    DataColumn(label: Text('Shipped Quantity')),
                    DataColumn(label: Text('Delivered Quantity')),
                    DataColumn(label: Text('Action 1')),
                    DataColumn(label: Text('Action 2')),
                  ],
                  rows: purchaseOrders.map((order) {
                    final statusColor =
                        statusColors[order.status.status] ?? Colors.black;
                    final statusIcon =
                        statusIcons[order.status.status] ?? Icons.help;

                    return DataRow(
                      cells: [
                        DataCell(Text(order.poNbr.toString())),
                        DataCell(Center(
                            child: Text(order.orderDate.toLocal().toString()))),
                        DataCell(Center(
                            child: Text(order.shipDate.toLocal().toString()))),
                        DataCell(Center(
                            child:
                                Text(order.deliveryDate.toLocal().toString()))),
                        DataCell(Center(
                            child:
                                Text(order.cancelDate.toLocal().toString()))),
                        DataCell(
                            Center(child: Text(order.facility.facilityCode))),
                        DataCell(Center(
                            child: Text(order.customer.name))), // Updated field
                        DataCell(Center(
                            child: Text(
                                order.address ?? 'N/A'))), // Nullable field
                        DataCell(
                          Row(
                            children: [
                              Icon(statusIcon, color: statusColor),
                              SizedBox(width: 8),
                              Text(
                                order.status.status,
                                style: TextStyle(color: statusColor),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Center(
                            child: Text(order.items.isNotEmpty
                                ? order.items[0].name
                                : 'N/A'))),
                        DataCell(Center(
                            child: Text(order.items.isNotEmpty
                                ? order.items[0].orderedQuantity.toString()
                                : 'N/A'))),
                        DataCell(Center(
                            child: Text(order.items.isNotEmpty
                                ? order.items[0].shippedQuantity.toString()
                                : 'N/A'))),
                        DataCell(Center(
                            child: Text(order.items.isNotEmpty
                                ? order.items[0].deliveredQuantity.toString()
                                : 'N/A'))),

                        DataCell(
                          Container(
                            decoration: BoxDecoration(
                              color: light,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: active, width: .5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: GestureDetector(
                              onTap: () => _openEditDialog(order),
                              child: CustomText(
                                text: "Edit",
                                color: active.withOpacity(.7),
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            decoration: BoxDecoration(
                              color: light,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: active, width: .5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: GestureDetector(
                              onTap: () => showDeleteinOrderDialog(
                                  context, order.poNbr, _deleteOrder),
                              child: CustomText(
                                text: "Delete",
                                color: active.withOpacity(.7),
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _openEditDialog(OutboundOrderModel order) {
    showDialog(
      context: context,
      builder: (context) => EditOutboundOrderDialog(
        order: order, onSaveSuccess: _refreshData, // Pass the callback here
      ),
    );
  }
}

const Map<String, Color> statusColors = {
  'Ordered': Colors.blue,
  'Delivered': Colors.green,
  'Canceled': Colors.red,
  'Shipped': Colors.orange
};

const Map<String, IconData> statusIcons = {
  'Ordered': Icons.shopping_cart,
  'Delivered': Icons.check_circle,
  'Canceled': Icons.cancel,
  'Shipped': Icons.local_shipping,
};
