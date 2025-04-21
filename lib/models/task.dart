class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final List<String> assignedUsers;
  final String createdBy;
  final bool isTeamTask;
  final DateTime? dueDate;
  final DateTime? deadline;
  final String priority;
  final String assignedTo;
  final String boardId;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedUsers,
    required this.createdBy,
    required this.isTeamTask,
    this.dueDate,
    this.deadline,
    required this.priority,
    required this.assignedTo,
    required this.boardId,
    required this.isCompleted,
  });

  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'todo',
      assignedUsers: List<String>.from(data['assignedUsers'] ?? []),
      createdBy: data['createdBy'] ?? '',
      isTeamTask: data['isTeamTask'] ?? false,
      dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
      deadline:
          data['deadline'] != null ? DateTime.parse(data['deadline']) : null,
      priority: data['priority'] ?? 'medium',
      assignedTo: data['assignedTo'] ?? '',
      boardId: data['boardId'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'assignedUsers': assignedUsers,
      'createdBy': createdBy,
      'isTeamTask': isTeamTask,
      'dueDate': dueDate?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'priority': priority,
      'assignedTo': assignedTo,
      'boardId': boardId,
      'isCompleted': isCompleted,
    };
  }
}
