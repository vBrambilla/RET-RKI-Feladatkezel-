import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retorki_feladatkezelo/models/user.dart';
import 'package:retorki_feladatkezelo/providers/user_provider.dart';
import 'package:retorki_feladatkezelo/widgets/app_header.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  String _selectedRole = 'user';

  @override
  void dispose() {
    _emailController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _showAddUserDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Új Felhasználó Hozzáadása',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6A778A),
            ),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: GoogleFonts.openSans(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kérlek, add meg az email címet';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Kérlek, adj meg egy érvényes email címet';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: InputDecoration(
                      labelText: 'Név',
                      labelStyle: GoogleFonts.openSans(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kérlek, add meg a nevet';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Szerepkör',
                      labelStyle: GoogleFonts.openSans(),
                      border: const OutlineInputBorder(),
                    ),
                    items: ['user', 'superadmin']
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(
                                role == 'user' ? 'Felhasználó' : 'Superadmin',
                                style: GoogleFonts.openSans(),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Mégse',
                style: GoogleFonts.openSans(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newUser = User(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    email: _emailController.text,
                    displayName: _displayNameController.text,
                    role: _selectedRole,
                  );
                  userProvider.addUser(newUser);
                  Navigator.of(context).pop();
                  _emailController.clear();
                  _displayNameController.clear();
                  setState(() {
                    _selectedRole = 'user';
                  });
                }
              },
              child: Text(
                'Hozzáadás',
                style: GoogleFonts.openSans(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users;

    return Scaffold(
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Felhasználók Kezelése',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 16.0),
            if (userProvider.canManageUsers())
              ElevatedButton(
                onPressed: () => _showAddUserDialog(context),
                child: Text(
                  'Új Felhasználó Hozzáadása',
                  style: GoogleFonts.openSans(),
                ),
              ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(
                        user.displayName, // name helyett displayName
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Email: ${user.email}\nSzerepkör: ${user.role}',
                        style: GoogleFonts.openSans(),
                      ),
                      trailing: userProvider.canManageUsers()
                          ? IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                userProvider.deleteUser(user.id);
                              },
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
