import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/app_header.dart';
import '../widgets/ai_assistant.dart'; // Frissítve

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  final UserService _userService = UserService();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _userService.getUsers();
    setState(() {
      _users = users;
    });
  }

  void _showAddUserDialog() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Új felhasználó regisztrációja',
            style:
                GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Felhasználónév',
                  hintStyle: GoogleFonts.openSans(color: Colors.grey),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: GoogleFonts.openSans(color: Colors.grey),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mégse'),
            ),
            ElevatedButton(
              onPressed: () {
                if (usernameController.text.isEmpty ||
                    emailController.text.isEmpty) return;
                final user = User(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  username: usernameController.text,
                  email: emailController.text,
                  role: 'User',
                );
                _userService.addUser(user);
                _loadUsers();
                Navigator.pop(context);
              },
              child: const Text('Regisztráció'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(),
                Text(
                  'Felhasználók kezelése',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _showAddUserDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9BB8A),
                  ),
                  child: Text(
                    'Új felhasználó regisztrációja',
                    style:
                        GoogleFonts.openSans(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            user.username,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6A778A),
                            ),
                          ),
                          subtitle: Text(
                            user.email,
                            style: GoogleFonts.openSans(
                                fontSize: 14, color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _userService.deleteUser(user.id);
                              _loadUsers();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const AIAssistant(), // Frissítve
        ],
      ),
    );
  }
}
