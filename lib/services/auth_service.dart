import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as custom;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter for the current user
  custom.User? get user {
    final firebaseUser = _auth.currentUser;
    return firebaseUser != null
        ? custom.User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            displayName: firebaseUser.displayName ?? '',
            role: 'user', // Default role
          )
        : null;
  }

  // Sign in with email and password
  Future<custom.User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      return firebaseUser != null
          ? custom.User(
              id: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              displayName: firebaseUser.displayName ?? '',
              role: 'user', // Default role
            )
          : null;
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  // Register with email and password
  Future<custom.User?> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(displayName);
        await firebaseUser.reload();
        return custom.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
          role: 'user', // Default role
        );
      }
      return null;
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  // Update user profile (display name)
  Future<void> updateUserProfile(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.reload();
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
      rethrow;
    }
  }
}
