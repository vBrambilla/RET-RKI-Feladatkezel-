import 'package:flutter/material.dart';
import 'package:retorki_feladatkezelo/models/user.dart';
import 'package:retorki_feladatkezelo/services/auth_service.dart';
import 'package:retorki_feladatkezelo/services/database_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  String? _token;
  final DatabaseService _databaseService = DatabaseService();
  List<User> _users = []; // Hozzáadjuk a users listát

  UserProvider() {
    // Figyeljük az AuthService user streamjét
    AuthService().user.listen((user) {
      _currentUser = user;
      _isAuthenticated = user != null;
      notifyListeners();
    });

    // Inicializáljuk a users listát (példa, később adatbázisból jöhet)
    _fetchUsers();
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  List<User> get users => _users; // Hozzáadjuk a users gettert

  void setUser(User user, String token) {
    _currentUser = user;
    _token = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  bool hasRole(String role) {
    return _currentUser?.role == role;
  }

  bool canManageUsers() {
    return hasRole('superadmin');
  }

  bool canEditProfile() {
    return _isAuthenticated;
  }

  // Új metódus: felhasználók lekérdezése (most memóriában, később adatbázisból)
  Future<void> _fetchUsers() async {
    // Ez egy placeholder, később adatbázisból kell lekérdezni
    _users = [];
    notifyListeners();
  }

  // Új metódus: felhasználó hozzáadása
  Future<void> addUser(User user) async {
    await _databaseService.saveUser(user);
    _users.add(user);
    notifyListeners();
  }

  // Új metódus: felhasználó törlése
  Future<void> deleteUser(String userId) async {
    await _databaseService.deleteUser(userId);
    _users.removeWhere((user) => user.id == userId);
    notifyListeners();
  }
}
