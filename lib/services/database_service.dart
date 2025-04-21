import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retorki_feladatkezelo/models/user.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(User user) async {
    try {
      await _db.collection('users').doc(user.id).set({
        'id': user.id,
        'email': user.email,
        'displayName': user.displayName, // name helyett displayName
        'role': user.role,
      });
    } catch (e) {
      print('Hiba a felhasználó mentése közben: $e');
      rethrow;
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return User(
          id: data['id'],
          email: data['email'],
          displayName: data['displayName'], // name helyett displayName
          role: data['role'],
        );
      }
      return null;
    } catch (e) {
      print('Hiba a felhasználó lekérdezése közben: $e');
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Hiba a felhasználó frissítése közben: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
    } catch (e) {
      print('Hiba a felhasználó törlése közben: $e');
      rethrow;
    }
  }
}
