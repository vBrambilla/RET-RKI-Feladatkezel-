class User {
  final String id;
  String username;
  final String email;
  String name;
  String role;
  bool emailNotifications;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.role,
    this.emailNotifications = false,
  });
}
