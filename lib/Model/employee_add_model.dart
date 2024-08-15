// ignore: camel_case_types
class addEmployee {
  int id;
  String username;
  String firstName;
  String lastName;
  String email;
  String password;
  String image;
  int hourlyWage;
  DateTime hireDate;
  int facilityId;
  int equipmentId;
  List<int> roles;

  addEmployee({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.image,
    required this.hourlyWage,
    required this.hireDate,
    required this.facilityId,
    required this.equipmentId,
    required this.roles,
  });

  factory addEmployee.fromJson(Map<String, dynamic> json) => addEmployee(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        image: json["image"],
        hourlyWage: json["hourly_wage"],
        hireDate: DateTime.parse(json["hire_date"]),
        facilityId: json["facility_id"],
        equipmentId: json["equipment_id"],
        roles: List<int>.from(json["roles"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "image": image,
        "hourly_wage": hourlyWage,
        "hire_date":
            "${hireDate.year.toString().padLeft(4, '0')}-${hireDate.month.toString().padLeft(2, '0')}-${hireDate.day.toString().padLeft(2, '0')}",
        "facility_id": facilityId,
        "equipment_id": equipmentId,
        "roles": List<dynamic>.from(roles.map((x) => x)),
      };
}
