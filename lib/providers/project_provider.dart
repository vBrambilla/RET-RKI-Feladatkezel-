import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  final List<Project> _projects = [];
  final Map<String, List<Task>> _tasks = {
    'personal': [],
    'team': [],
  };

  List<Project> get projects => _projects;

  List<Task> getTasks(String boardId) {
    return _tasks[boardId] ?? [];
  }

  void fetchProjects() {
    _projects.add(Project(
      id: '1',
      name: 'Sample Project',
      description: 'A sample project',
      tasks: [],
    ));
    notifyListeners();
  }

  void addTask(String boardId, Task task) {
    if (!_tasks.containsKey(boardId)) {
      _tasks[boardId] = [];
    }
    _tasks[boardId]!.add(task);
    notifyListeners();
  }

  void updateTaskStatus(String boardId, String taskId, String newStatus) {
    final tasks = _tasks[boardId];
    if (tasks != null) {
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final updatedTask = Task(
          id: tasks[taskIndex].id,
          title: tasks[taskIndex].title,
          description: tasks[taskIndex].description,
          deadline: tasks[taskIndex].deadline,
          status: newStatus,
          assignee: tasks[taskIndex].assignee,
          assignedUsers: tasks[taskIndex].assignedUsers,
          boardId: tasks[taskIndex].boardId,
          createdBy: tasks[taskIndex].createdBy,
          isTeamTask: tasks[taskIndex].isTeamTask,
          priority: tasks[taskIndex].priority,
          isCompleted: tasks[taskIndex].isCompleted,
        );
        tasks[taskIndex] = updatedTask;
        notifyListeners();
      }
    }
  }
}
