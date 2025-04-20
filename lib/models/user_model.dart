class UserModel {
  final String? id;
  final String name;
  final String email;
  final bool isAdmin;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    return UserModel(
      id: docId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}