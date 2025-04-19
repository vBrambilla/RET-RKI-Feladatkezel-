import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/ai_assistant.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'member';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addUser(UserProvider userProvider) {
    if (_usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      userProvider.addUser(
        _usernameController.text,
        _emailController.text,
        _selectedRole,
      );
      _usernameController.clear();
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    if (currentUser == null || currentUser.role != 'superadmin') {
      return Scaffold(
        appBar: const AppHeader(),
        body: const Center(
          child: Text('Nincs jogosultságod ehhez az oldalhoz.'),
        ),
      );
    }

    return Scaffold(
      appBar: const AppHeader(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Felhasználók kezelése',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Felhasználónév',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    DropdownButton<String>(
                      value: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                            value: 'member', child: Text('Member')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(
                            value: 'superadmin', child: Text('Superadmin')),
                      ],
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () => _addUser(userProvider),
                      child: const Text('Hozzáadás'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: userProvider.users.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.users[index];
                      return ListTile(
                        title: Text(user.username),
                        subtitle:
                            Text('Email: ${user.email}, Szerep: ${user.role}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Szerkesztés logika
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                userProvider.deleteUser(user.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const AIAssistant(),
        ],
      ),
    );
  }
}
