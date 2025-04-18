import '../models/user.dart';

class AuthService {
  static final List<User> _users = [
    User(
        id: '1',
        username: 'Superadmin',
        email: 'superadmin@retorki.hu',
        role: 'Superadmin'),
  ];

  Future<bool> sendVerificationCode(String email) async {
    // Mock e-mail küldés
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> verifyCode(
      String email, String code, String password, String username) async {
    // Mock ellenőrzés
    await Future.delayed(const Duration(seconds: 1));
    if (code == '1234') {
      _users.add(User(
        id: DateTime.now().toString(),
        username: username,
        email: email,
        role: 'Pending',
      ));
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password, bool stayLoggedIn) async {
    // Mock bejelentkezés
    await Future.delayed(const Duration(seconds: 1));
    return _users.any((user) => user.email == email && user.role != 'Pending');
  }

  void logout() {
    // Mock kijelentkezés
  }

  Future<List<User>> getPendingUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return _users.where((user) => user.role == 'Pending').toList();
  }

  Future<List<User>> getApprovedUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return _users.where((user) => user.role != 'Pending').toList();
  }

  Future<void> approveUser(String userId, String role) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = _users.firstWhere((user) => user.id == userId);
    user.role = role;
  }

  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    _users.removeWhere((user) => user.id == userId);
  }

  Future<void> updateUser(
      String userId, String username, bool emailNotifications) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = _users.firstWhere((user) => user.id == userId);
    user.username = username;
    user.emailNotifications = emailNotifications;
  }

  Future<User?> getUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _users.firstWhere((user) => user.id == userId);
  }
}
