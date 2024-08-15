class Status {
  final int id;
  final String status;

  Status({required this.id, required this.status});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }
}
