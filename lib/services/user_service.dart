import '../models/user.dart';
import 'database_service.dart';

class UserService {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<User>> getUsers() async {
    return await _databaseService.getUsers();
  }

  Future<void> addUser(User user) async {
    await _databaseService.addUser(user);
  }

  Future<void> updateUser(User user) async {
    await _databaseService.updateUser(user);
  }

  Future<void> deleteUser(String userId) async {
    await _databaseService.deleteUser(userId); // Javítva: _databaseService
  }
}
