import '../models/task.dart';
import '../models/user.dart';
import '../models/notification.dart';
import '../models/comment.dart';
import '../models/attachment.dart';
import '../models/message.dart';
import '../models/board.dart';

class DatabaseService {
  final List<Task> _tasks = [];
  final List<User> _users = [];
  final List<Notification> _notifications = [];
  final List<Message> _messages = [];
  final List<Board> _boards = [];

  DatabaseService() {
    _users.add(User(
      id: '1',
      username: 'Superadmin',
      email: 'superadmin@retorki.hu',
      role: 'Superadmin',
    ));
    _boards.add(Board(
      id: 'board1',
      name: 'Teszt Munkatábla',
      createdBy: '1',
      members: ['1'],
    ));
  }

  Future<List<Task>> getTasks(String userId, {bool? isTeamTask}) async {
    var filteredTasks = _tasks
        .where((task) =>
            task.assignedUsers.contains(userId) || task.createdBy == userId)
        .toList();
    if (isTeamTask != null) {
      filteredTasks =
          filteredTasks.where((task) => task.isTeamTask == isTeamTask).toList();
    }
    return filteredTasks;
  }

  Future<List<Task>> getArchivedTasks(String userId) async {
    return _tasks
        .where((task) =>
            task.isArchived &&
            (task.assignedUsers.contains(userId) || task.createdBy == userId))
        .toList();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
  }

  Future<List<Board>> getBoards(String userId) async {
    return _boards
        .where((board) =>
            board.members.contains(userId) || board.createdBy == userId)
        .toList();
  }

  Future<void> addBoard(Board board) async {
    _boards.add(board);
  }

  Future<List<User>> getUsers() async {
    return _users;
  }

  Future<List<User>> getAllUsers() async {
    return _users;
  }

  Future<void> addUser(User user) async {
    _users.add(user);
  }

  Future<void> updateUser(User user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  Future<void> deleteUser(String userId) async {
    _users.removeWhere((user) => user.id == userId);
  }

  Future<List<Message>> getMessages(String userId) async {
    return _messages
        .where((message) =>
            message.senderId == userId || message.recipientId == userId)
        .toList();
  }

  Future<void> sendMessage(Message message) async {
    _messages.add(message);
  }

  Future<void> deleteMessage(String messageId) async {
    _messages.removeWhere((message) => message.id == messageId);
  }

  Future<List<Notification>> getNotifications(String userId) async {
    return _notifications
        .where((notification) => notification.userId == userId)
        .toList();
  }

  Future<void> addNotification(Notification notification) async {
    _notifications.add(notification);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = Notification(
        id: _notifications[index].id,
        userId: _notifications[index].userId,
        content: _notifications[index].content,
        timestamp: _notifications[index].timestamp,
        relatedTaskId: _notifications[index].relatedTaskId,
        isRead: true,
      );
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    _notifications
        .removeWhere((notification) => notification.id == notificationId);
  }
}
