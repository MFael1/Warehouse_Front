import 'package:flutter_web_dashboard/Model/category_model.dart';
import 'package:flutter_web_dashboard/Model/company_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/status_model.dart';

class LocalData {
  static final List<Facility> facilities = [
    Facility(id: 1, facilityCode: "JAPAN_007"),
    Facility(id: 2, facilityCode: "USA_O37"),
    Facility(id: 3, facilityCode: "TOKYO_777"),
    Facility(id: 4, facilityCode: "DAMASCUS_001"),
  ];

  static final List<Status> statuses = [
    Status(id: 1, status: "Ordered"),
    Status(id: 2, status: "Delivered"),
    Status(id: 3, status: "Canceled"),
  ];

  static final List<Equipment> equipmentList = [
    Equipment(id: 1, name: "Tablet", description: "Elcotranic Device"),
    Equipment(
        id: 2, name: "Barcode Scanner", description: "Just a barcode scanner"),
    Equipment(id: 3, name: "Printer", description: " machine"),
    Equipment(id: 4, name: "Forklift", description: "LEFT THE PROUDUCTS "),
    Equipment(id: 5, name: "Pallet Jack", description: "none"),
  ];

  static final List<Category> category = [
    Category(id: 1, categoryName: "Standard"),
    Category(id: 2, categoryName: "Bulk"),
    Category(id: 3, categoryName: "Chilled"),
    Category(id: 4, categoryName: "Hazardous"),
    Category(id: 5, categoryName: "Oversized"),
    Category(id: 6, categoryName: "Fast-moving"),
    Category(id: 7, categoryName: "Valuable"),
  ];

  static final List<Company> company = [
    Company(id: 1, companyName: "Tesla"),
    Company(id: 2, companyName: "Apple"),
    Company(id: 3, companyName: "Amazon"),
    Company(id: 4, companyName: "Google"),
    Company(id: 5, companyName: "Microsoft"),
    Company(id: 6, companyName: "SpaceX"),
    Company(id: 7, companyName: "Samsung"),
    Company(id: 8, companyName: "Toyota"),
  ];

  static final List<RoleEm> role = [
    RoleEm(id: 1, name: "ADMINISTRATOR"),
    RoleEm(id: 2, name: "EMPLOYEE"),
    RoleEm(id: 3, name: "SUPERVISOR"),
    RoleEm(id: 4, name: "SHIPPING"),
    RoleEm(id: 5, name: "RECEIVING"),
    RoleEm(id: 6, name: "MASTER DATA MANAGEMENT"),
    RoleEm(id: 7, name: "ORDER MANAGEMENT"),
  ];
}

class RoleEm {
  final int id;
  final String name;

  RoleEm({required this.id, required this.name});

  factory RoleEm.fromJson(Map<String, dynamic> json) {
    return RoleEm(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
