class Task {
  final String id;
  final String title;
  final String description;
  final DateTime? deadline;
  final String status;
  final String? assignee;
  final List<String> assignedUsers;
  final String boardId;
  final String createdBy;
  final bool isTeamTask;
  final String priority;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    required this.status,
    this.assignee,
    required this.assignedUsers,
    required this.boardId,
    required this.createdBy,
    required this.isTeamTask,
    required this.priority,
    this.isCompleted = false,
  });
}
