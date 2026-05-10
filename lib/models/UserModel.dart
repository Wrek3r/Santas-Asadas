class UserModel {
  final String name;
  final String phone;
  final String address;
  final String notes;

  UserModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'address': address, 'notes': notes};
  }
}
