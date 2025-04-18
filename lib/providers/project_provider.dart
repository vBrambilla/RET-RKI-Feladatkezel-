import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/comment.dart';
import '../models/attachment.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  void fetchProjects() {
    // Mock adatbetöltés, később adatbázisból jöhet
    _projects = [
      Project(
        id: '1',
        name: 'Teszt Projekt',
        createdBy: 'Superadmin',
        tasks: [
          Task(
            id: 't1',
            title: 'Első feladat',
            description: 'Ez egy teszt feladat',
            boardId: 'board1',
            assignedUsers: ['Superadmin'],
            createdBy: 'Superadmin',
            deadline: DateTime.now().add(const Duration(days: 1)),
            priority: 'Közepes',
            isCompleted: false,
            isTeamTask: false,
            comments: [
              Comment(
                author: 'Superadmin',
                content: 'Ez egy teszt hozzászólás',
                timestamp: DateTime.now(),
              ),
            ],
            attachments: [
              Attachment(
                filename: 'test.pdf',
                uploadedBy: 'Superadmin',
                uploadedAt: DateTime.now(),
              ),
            ],
          ),
        ],
      ),
    ];
    notifyListeners();
  }

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void addTaskToProject(String projectId, Task task) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final updatedProject = Project(
      id: project.id,
      name: project.name,
      createdBy: project.createdBy,
      tasks: List.from(project.tasks)..add(task),
    );
    final index = _projects.indexWhere((p) => p.id == projectId);
    _projects[index] = updatedProject;
    notifyListeners();
  }

  void updateProject(Project updatedProject) {
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);
    if (index != -1) {
      _projects[index] = updatedProject;
      notifyListeners();
    }
  }
}
