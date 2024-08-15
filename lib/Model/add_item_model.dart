import 'package:flutter_web_dashboard/Model/employee_model.dart';

class AddItem {
  final String name;
  final int count;
  final String manufacturerDate;
  final String expiringDate;
  final Facility facilityID;

  AddItem({
    required this.name,
    required this.count,
    required this.manufacturerDate,
    required this.expiringDate,
    required this.facilityID,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "manufacturer_date": manufacturerDate,
        "expiring_date": expiringDate,
        "facility_id": facilityID,
      };
}
