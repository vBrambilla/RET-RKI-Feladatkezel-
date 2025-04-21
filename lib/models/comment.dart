class Comment {
  final String author;
  final String content;
  final DateTime timestamp;
  final bool isInitial;

  Comment({
    required this.author,
    required this.content,
    required this.timestamp,
    this.isInitial = false,
  });
}
