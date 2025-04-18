class User {
  final String id;
  String username;
  final String email;
  String role;
  String profileImage;
  bool emailNotifications;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.profileImage = '',
    this.emailNotifications = false,
  });
}
