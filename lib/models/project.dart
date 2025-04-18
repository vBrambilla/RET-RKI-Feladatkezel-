import 'task.dart';

class Project {
  final String id;
  final String name;
  final String createdBy;
  final List<Task> tasks;

  Project({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.tasks,
  });
}
