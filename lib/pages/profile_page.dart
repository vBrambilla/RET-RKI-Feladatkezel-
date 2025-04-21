import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retorki_feladatkezelo/providers/user_provider.dart';
import 'package:retorki_feladatkezelo/services/auth_service.dart';
import 'package:retorki_feladatkezelo/widgets/app_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _displayNameController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final displayName = _displayNameController.text.trim();
    if (displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kérlek, adj meg egy nevet!')),
      );
      return;
    }

    try {
      await AuthService().updateUserProfile(displayName);
      Provider.of<UserProvider>(context, listen: false)
          .updateDisplayName(displayName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil frissítve!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hiba történt: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    _displayNameController.text = userProvider.user?.displayName ?? '';

    return Scaffold(
      appBar: AppHeader(
        title: 'Profil',
        showBackButton: true,
        showMenu: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Email: ${userProvider.user?.email ?? 'N/A'}'),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(labelText: 'Név'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Profil frissítése'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Kijelentkezés'),
            ),
          ],
        ),
      ),
    );
  }
}
