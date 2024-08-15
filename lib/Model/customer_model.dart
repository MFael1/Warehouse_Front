class Customer {
  int id;
  String name;
  Contact contact;

  Customer({
    required this.id,
    required this.name,
    required this.contact,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
  String phoneNumber;

  Contact({
    required this.phoneNumber,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
      };
}
