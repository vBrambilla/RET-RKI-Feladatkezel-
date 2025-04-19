import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';
import '../widgets/app_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _usernameController;
  bool _emailNotifications = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.users.firstWhere(
      (user) =>
          user.id ==
          '1', // Ideiglenesen feltételezzük, hogy az első felhasználó
      orElse: () => User(
        id: '1',
        username: 'admin',
        email: 'admin@example.com',
        name: 'Admin',
        role: 'admin',
        emailNotifications: true,
      ),
    );
    _usernameController = TextEditingController(text: user.username);
    _emailNotifications = user.emailNotifications;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.users.firstWhere((user) => user.id == '1');
    await authService.updateUserProfile(
      user,
      _usernameController.text,
      _emailNotifications,
      user.role,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil frissítve')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.users.firstWhere((user) => user.id == '1');

    return Scaffold(
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profil',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Felhasználónév',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Email: ${user.email}',
              style: GoogleFonts.openSans(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Checkbox(
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value!;
                    });
                  },
                ),
                Text(
                  'Email értesítések',
                  style: GoogleFonts.openSans(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Mentés'),
            ),
          ],
        ),
      ),
    );
  }
}
