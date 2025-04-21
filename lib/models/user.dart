class User {
  final String id;
  final String email;
  final String displayName;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
  });

  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
    };
  }
}
