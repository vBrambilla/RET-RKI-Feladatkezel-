import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class UserProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<User> _users = [];
  User? _currentUser;

  List<User> get users => _users;
  User? get currentUser => _currentUser;

  UserProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    _users = await _databaseService.getUsers();
    // Ha a DatabaseService üres, adjunk hozzá alapértelmezett felhasználókat
    if (_users.isEmpty) {
      await _databaseService.addUser('admin', 'admin@example.com', 'admin');
      await _databaseService.addUser(
          'superadmin', 'superadmin@example.com', 'superadmin');
      _users = await _databaseService.getUsers();
    }
    notifyListeners();
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> addUser(String username, String email, String role) async {
    await _databaseService.addUser(username, email, role);
    await fetchUsers();
  }

  Future<void> updateUser(User user) async {
    await _databaseService.updateUser(user);
    await fetchUsers();
  }

  Future<void> deleteUser(String userId) async {
    await _databaseService.deleteUser(userId);
    await fetchUsers();
  }
}
