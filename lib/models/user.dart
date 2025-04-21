class User {
  final String id;
  final String email;
  final String displayName; // name helyett displayName
  final String role;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
  });

  // JSON konverzió, ha később szükséges
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      role: json['role'],
    );
  }
}
