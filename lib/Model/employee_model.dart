class Employee {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String? password; // Optional field
  final int hourlyWage;
  final DateTime hireDate;
  final Facility facility; // This should be an object
  final Equipment equipment; // This should be an object
  final List<Role> roles; // List of Role objects

  Employee({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    this.password,
    required this.hourlyWage,
    required this.hireDate,
    required this.facility,
    required this.equipment,
    required this.roles,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      password: json['password'],
      hourlyWage: (json['hourly_wage'] ?? 0).toDouble(),
      hireDate: DateTime.parse(json['hire_date'] ?? DateTime.now().toString()),
      facility: Facility.fromJson(
          json['facility'] ?? {}), // Ensure default empty object
      equipment: Equipment.fromJson(
          json['equipment'] ?? {}), // Ensure default empty object
      roles: (json['roles'] as List<dynamic>? ?? [])
          .map((roleJson) => Role.fromJson(roleJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'image': image,
      'password': password,
      'hourly_wage': hourlyWage,
      'hire_date': hireDate.toIso8601String().split('T').first,
      'facility_id': facility.id, // Use facility ID instead of JSON
      'equipment_id': equipment.id, // Convert equipment to JSON
      'roles': roles.map((role) => role.toJson()).toList(),
    };
  }
}

class Facility {
  final int id;
  final String facilityCode;

  Facility({required this.id, required this.facilityCode});

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'] ?? 0,
      facilityCode: json['facility_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facility_code': facilityCode,
    };
  }
}

class Equipment {
  final int id;
  final String name;
  final String description;

  Equipment({required this.id, required this.name, required this.description});

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

class Role {
  final int id;
  final String name;
  final List<Permission> permissions;

  Role({required this.id, required this.name, required this.permissions});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      permissions: (json['permissions'] as List)
          .map((permission) => Permission.fromJson(permission))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'permissions':
          permissions.map((permission) => permission.toJson()).toList(),
    };
  }
}

class Permission {
  final int id;
  final String name;

  Permission({required this.id, required this.name});

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
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
