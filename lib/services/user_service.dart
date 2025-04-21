import '../models/user.dart';
import 'database_service.dart';

class UserService {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<User>> getUsers() async {
    return await _databaseService.getUsers();
  }

  Future<void> addUser(String username, String email, String role) async {
    await _databaseService.addUser(username, email, role);
  }

  Future<void> updateUser(User user) async {
    await _databaseService.updateUser(user);
  }

  Future<void> deleteUser(String userId) async {
    await _databaseService.deleteUser(userId);
  }
}
