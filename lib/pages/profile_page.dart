import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';
import '../widgets/app_header.dart';
import '../widgets/ai_assistant.dart'; // Frissítve

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  bool _emailNotifications = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)!.settings.arguments as User;
    _usernameController.text = user.username;
    _emailNotifications = user.emailNotifications ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;

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
                  'Profil',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFD9BB8A),
                  child: Text(
                    _usernameController.text.isNotEmpty
                        ? _usernameController.text[0] +
                            (_usernameController.text.split(' ').length > 1
                                ? _usernameController.text.split(' ')[1][0]
                                : '')
                        : 'A',
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Felhasználónév',
                    hintStyle: GoogleFonts.openSans(color: Colors.grey),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
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
                      'E-mail értesítések',
                      style: GoogleFonts.openSans(
                          fontSize: 16, color: const Color(0xFF6A778A)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Profil mentése logika később
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9BB8A),
                  ),
                  child: Text(
                    'Mentés',
                    style:
                        GoogleFonts.openSans(fontSize: 16, color: Colors.white),
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
