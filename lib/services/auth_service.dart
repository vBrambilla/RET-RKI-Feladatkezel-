import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:retorki_feladatkezelo/models/user.dart';
import 'package:retorki_feladatkezelo/services/database_service.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  final StreamController<User?> _userController =
      StreamController<User?>.broadcast();

  Stream<User?> get user => _userController.stream;

  AuthService() {
    _auth.authStateChanges().listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser == null) {
        _userController.add(null);
      } else {
        final user = await _databaseService.getUser(firebaseUser.uid);
        _userController.add(user);
      }
    });
  }

  Future<void> signUp(String email, String password, String displayName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        final user = User(
          id: credential.user!.uid,
          email: email,
          displayName: displayName, // name helyett displayName
          role: 'user',
        );
        await _databaseService.saveUser(user);
        _userController.add(user);
      }
    } catch (e) {
      print('Hiba a regisztráció során: $e');
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        final user = await _databaseService.getUser(credential.user!.uid);
        if (user != null) {
          _userController.add(user);
        } else {
          final newUser = User(
            id: credential.user!.uid,
            email: email,
            displayName: email.split('@')[0], // Alapértelmezett displayName
            role: 'user',
          );
          await _databaseService.saveUser(newUser);
          _userController.add(newUser);
        }
      }
    } catch (e) {
      print('Hiba a bejelentkezés során: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userController.add(null);
    } catch (e) {
      print('Hiba a kijelentkezés során: $e');
      rethrow;
    }
  }
}
