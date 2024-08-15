import 'package:flutter_web_dashboard/Model/employee_model.dart';

class Item {
  int id;
  String name;
  int count;
  DateTime manufacturerDate;
  DateTime expiringDate;
  int facilityId;
  Facility facility;
  List<Material> materials;

  Item({
    required this.id,
    required this.name,
    required this.count,
    required this.manufacturerDate,
    required this.expiringDate,
    required this.facilityId,
    required this.facility,
    required this.materials,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      count: json['count'],
      manufacturerDate: DateTime.parse(json['manufacturer_date']),
      expiringDate: DateTime.parse(json['expiring_date']),
      facilityId: json['facility_id'],
      facility: Facility.fromJson(json['facility']),
      materials: (json['materials'] as List)
          .map((material) => Material.fromJson(material))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "count": count,
      "manufacturer_date": manufacturerDate.toIso8601String(),
      "expiring_date": expiringDate.toIso8601String(),
      "facility_id": facilityId,
      "facility": facility.toJson(),
      "materials": materials.map((material) => material.toJson()).toList(),
    };
  }
}

class Material {
  int id;
  String name;

  Material({required this.id, required this.name});

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
