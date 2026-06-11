// lib/src/data/models/user_model.dart
class UserModel {
  final String token;
  final String role;
  final String username;
  final String email;

  UserModel({
    required this.token,
    required this.role,
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String,
      role: json['role'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }

  bool get isTeacher => role == 'teacher';
}
