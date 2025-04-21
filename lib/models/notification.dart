class Notification {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;
  bool isRead;
  final String? relatedTaskId;

  Notification({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    this.relatedTaskId,
  });
}
