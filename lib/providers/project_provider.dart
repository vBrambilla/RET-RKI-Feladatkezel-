import 'package:flutter/material.dart';
import '../models/task.dart';

class ProjectProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void addProjectTask(String projectId) {
    _tasks.add(Task(
      id: DateTime.now().toString(),
      title: 'New Task in $projectId',
      description: 'Description for task in $projectId',
      status: 'todo',
      dueDate: DateTime.now().add(Duration(days: 7)),
      deadline: DateTime.now().add(Duration(days: 7)),
      priority: 'medium',
      assignedTo: 'userId',
      assignedUsers: [],
      createdBy: 'currentUserId',
      isTeamTask: true,
      boardId: projectId,
      isCompleted: false,
    ));
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }
}
