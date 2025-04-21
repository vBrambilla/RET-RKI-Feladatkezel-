import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:retorki_feladatkezelo/models/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Felhasználó konvertálása Firebase User-ből a saját User modellünkbe
  User? _userFromFirebase(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      role: firebaseUser.email == 'superadmin@example.com'
          ? 'superadmin'
          : 'user',
    );
  }

  // Bejelentkezés email és jelszó alapján
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(credential.user);
    } catch (e) {
      print('Bejelentkezési hiba: $e');
      return null;
    }
  }

  // Regisztráció email és jelszó alapján
  Future<User?> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      return _userFromFirebase(credential.user);
    } catch (e) {
      print('Regisztrációs hiba: $e');
      return null;
    }
  }

  // Felhasználói profil frissítése
  Future<void> updateUserProfile(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      print('Profil frissítési hiba: $e');
      rethrow;
    }
  }

  // Kijelentkezés
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Aktuális felhasználó lekérdezése
  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}
