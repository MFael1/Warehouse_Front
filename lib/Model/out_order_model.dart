import 'package:flutter_web_dashboard/Model/customer_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/status_model.dart';

class OutboundOrderModel {
  final int poNbr;
  final DateTime orderDate;
  final DateTime shipDate;
  final DateTime deliveryDate;
  final DateTime cancelDate;
  final Facility facility;
  final Customer customer; // Updated from Supplier to Customer
  final String? address; // Address is now nullable
  final Status status;
  final List<Item> items;

  OutboundOrderModel({
    required this.poNbr,
    required this.orderDate,
    required this.shipDate,
    required this.deliveryDate,
    required this.cancelDate,
    required this.facility,
    required this.customer, // Updated field
    this.address,
    required this.status,
    required this.items,
  });

  factory OutboundOrderModel.fromJson(Map<String, dynamic> json) {
    return OutboundOrderModel(
      poNbr: json['po_nbr'],
      orderDate: DateTime.parse(json['order_date']),
      shipDate: DateTime.parse(json['ship_date']),
      deliveryDate: DateTime.parse(json['delivery_date']),
      cancelDate: DateTime.parse(json['cancel_date']),
      facility: Facility.fromJson(json['facility']),
      customer: Customer.fromJson(json['customer']), // Updated field
      address: json['address'], // Nullable field
      status: Status.fromJson(json['status']),
      items:
          (json['items'] as List).map((item) => Item.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'po_nbr': poNbr,
      'order_date': orderDate.toIso8601String(),
      'ship_date': shipDate.toIso8601String(),
      'delivery_date': deliveryDate.toIso8601String(),
      'cancel_date': cancelDate.toIso8601String(),
      'facility': facility.toJson(),
      'customer': customer.toJson(), // Updated field
      'address': address, // Nullable field
      'status': status.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class Item {
  int id;
  String name;
  int orderedQuantity;
  int shippedQuantity;
  int deliveredQuantity;

  Item({
    required this.id,
    required this.name,
    required this.orderedQuantity,
    required this.shippedQuantity,
    required this.deliveredQuantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      orderedQuantity: json['ordered_quantity'],
      shippedQuantity: json['shipped_quantity'],
      deliveredQuantity: json['delivered_quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ordered_quantity': orderedQuantity,
      'shipped_quantity': shippedQuantity,
      'delivered_quantity': deliveredQuantity,
    };
  }
}
