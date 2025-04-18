import 'comment.dart';
import 'attachment.dart';

class Task {
  final String id;
  final String title;
  final String description; // Hozzáadva a kompatibilitás miatt
  final String boardId;
  final List<String> assignedUsers;
  final String createdBy;
  final DateTime deadline;
  final String priority;
  final List<Task> subtasks;
  final List<Comment> comments;
  final List<Attachment> attachments;
  bool isCompleted;
  bool isArchived;
  DateTime? completedAt;
  String? completedBy;
  DateTime? archivedAt;
  final bool isTeamTask;
  final bool isSubtask;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.boardId,
    required this.assignedUsers,
    required this.createdBy,
    required this.deadline,
    required this.priority,
    this.subtasks = const [],
    this.comments = const [],
    this.attachments = const [],
    this.isCompleted = false,
    this.isArchived = false,
    this.completedAt,
    this.completedBy,
    this.archivedAt,
    required this.isTeamTask,
    this.isSubtask = false,
  });
}
