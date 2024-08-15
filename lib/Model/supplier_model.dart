class Supplier {
  int id;
  String name;
  Contact contact;

  Supplier({required this.id, required this.name, required this.contact});

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        id: json["id"],
        name: json["name"],
        contact: Contact.fromJson(json["contact"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact": contact.toJson(),
      };
}

class Contact {
  int? id;
  String phoneNumber;

  Contact({this.id, required this.phoneNumber});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone_number": phoneNumber,
      };
}
