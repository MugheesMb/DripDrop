// import 'dart:io';

class AppUser {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime createdAt;
  DateTime? updatedAt;

  AppUser(
      {required this.createdAt,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.password,
      this.updatedAt});
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      password: '',
      createdAt: json['createdAt'] ?? DateTime.now(),
      updatedAt: json['updatedAt'] ?? DateTime.now(),
    );
  }
}
