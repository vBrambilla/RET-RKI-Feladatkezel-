import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  List<User> _users = [];

  User? get user => _user;

  List<User> get users => _users;

  UserProvider() {
    _authService.user != null
        ? _firestore
            .collection('users')
            .doc(_authService.user!.id)
            .snapshots()
            .listen((snapshot) {
            if (snapshot.exists) {
              _user = User.fromFirestore(snapshot.data()!, snapshot.id);
              notifyListeners();
            }
          })
        : null;
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs
          .map((doc) => User.fromFirestore(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      await _authService.updateUserProfile(displayName);
      if (_user != null) {
        await _firestore.collection('users').doc(_user!.id).update({
          'displayName': displayName,
        });
        _user = User(
          id: _user!.id,
          email: _user!.email,
          displayName: displayName,
          role: _user!.role,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error updating display name: $e');
      rethrow;
    }
  }
}
