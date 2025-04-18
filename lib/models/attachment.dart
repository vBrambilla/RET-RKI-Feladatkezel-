class Attachment {
  final String filename;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String description;

  Attachment({
    required this.filename,
    required this.uploadedBy,
    required this.uploadedAt,
    this.description = '',
  });
}
