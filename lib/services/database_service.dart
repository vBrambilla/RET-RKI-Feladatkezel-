import '../models/user.dart';
import '../models/project.dart';

class DatabaseService {
  final List<User> _users = [];
  final List<Project> _projects = [];

  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return _users;
  }

  Future<void> addUser(String username, String email, String role) async {
    await Future.delayed(const Duration(seconds: 1));
    _users.add(User(
      id: DateTime.now().toString(),
      username: username,
      email: email,
      name: username,
      role: role,
      emailNotifications: false,
    ));
  }

  Future<List<Project>> getProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    return _projects;
  }

  Future<void> addProject(String name, String description) async {
    await Future.delayed(const Duration(seconds: 1));
    _projects.add(Project(
      id: DateTime.now().toString(),
      name: name,
      description: description,
      tasks: [],
    ));
  }

  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    _users.removeWhere((user) => user.id == userId);
  }
}
