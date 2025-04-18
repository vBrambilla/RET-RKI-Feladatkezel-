import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/database_service.dart';
import '../models/user.dart';
import '../widgets/app_header.dart'; // Csak AppHeader, AIAssistant nincs

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() async {
    String username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() {
        _errorMessage = 'Kérlek, add meg a felhasználónevet!';
      });
      return;
    }

    List<User> users = await DatabaseService().getUsers();
    User? user = users.firstWhere(
      (u) => u.username == username,
      orElse: () => User(id: '', username: '', email: '', role: ''),
    );

    if (user.id.isEmpty) {
      setState(() {
        _errorMessage = 'Hibás felhasználónév!';
      });
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/dashboard',
      arguments: user, // arguments használata a currentUser helyett
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppHeader(),
            const SizedBox(height: 40),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Felhasználónév',
                hintStyle: GoogleFonts.openSans(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF8A7E8D)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFFD9BB8A), width: 2.0),
                ),
              ),
              style: GoogleFonts.openSans(
                  fontSize: 14, color: const Color(0xFF6A778A)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Jelszó',
                hintStyle: GoogleFonts.openSans(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF8A7E8D)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFFD9BB8A), width: 2.0),
                ),
              ),
              style: GoogleFonts.openSans(
                  fontSize: 14, color: const Color(0xFF6A778A)),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9BB8A),
              ),
              child: Text(
                'Bejelentkezés',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
