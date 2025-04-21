import 'package:flutter/material.dart';
import 'package:retorki_feladatkezelo/models/user.dart';
import 'package:retorki_feladatkezelo/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  String? _token;

  UserProvider() {
    // Figyeljük az AuthService user streamjét
    AuthService().user.listen((user) {
      _currentUser = user;
      _isAuthenticated = user != null;
      notifyListeners();
    });
  }

  // Getter a jelenlegi felhasználóhoz (a profile_page.dart számára)
  User? get user => _currentUser;

  // Kompatibilitás az eredeti kóddal
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  void setUser(User user, String token) {
    _currentUser = user;
    _token = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  // A felhasználó nevének frissítése (a profile_page.dart számára)
  void updateDisplayName(String displayName) {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        displayName: displayName,
        role: _currentUser!.role,
      );
      notifyListeners();
    }
  }

  // Kompatibilitás az eredeti kóddal
  void updateUserProfile(String displayName) {
    updateDisplayName(displayName); // Átirányítjuk az új metódusra
  }

  void clearUser() {
    _currentUser = null;
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // További metódusok, pl. jogosultságok ellenőrzése
  bool hasRole(String role) {
    return _currentUser?.role == role;
  }

  bool canManageUsers() {
    return hasRole('superadmin');
  }

  bool canEditProfile() {
    return _isAuthenticated;
  }
}
