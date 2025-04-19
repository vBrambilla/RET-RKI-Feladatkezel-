import 'package:flutter/foundation.dart' show kDebugMode;
import '../models/user.dart';

class AuthService {
  final List<User> _users = [
    User(
        id: '1',
        username: 'admin',
        email: 'admin@example.com',
        name: 'Admin',
        role: 'admin',
        emailNotifications: true),
    User(
        id: '2',
        username: 'superadmin',
        email: 'superadmin@example.com',
        name: 'Superadmin Moch',
        role: 'superadmin',
        emailNotifications: true),
  ];
  String? _lastSentCode;

  Future<bool> login(User user, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('Login attempt: ${user.username}, password: $password');
    }
    return password == 'password';
  }

  Future<void> register(String username, String email, String password,
      String name, String role) async {
    await Future.delayed(const Duration(seconds: 1));
    _users.add(User(
      id: DateTime.now().toString(),
      username: username,
      email: email,
      name: name,
      role: role,
      emailNotifications: false,
    ));
  }

  Future<void> sendVerificationCode(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    _lastSentCode = '123456';
    if (kDebugMode) {
      print('Verification code for $email: $_lastSentCode');
    }
  }

  Future<bool> verifyCode(String email, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    return code == _lastSentCode;
  }

  Future<void> updateUserProfile(
      User user, String username, bool emailNotifications, String role) async {
    await Future.delayed(const Duration(seconds: 1));
    user.username = username;
    user.emailNotifications = emailNotifications;
    user.role = role;
  }
}
