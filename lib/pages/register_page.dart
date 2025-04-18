import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;

  void _register() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      return;
    }
    bool success =
        await AuthService().sendVerificationCode(_emailController.text);
    if (success) {
      setState(() {
        _codeSent = true;
      });
    }
  }

  void _verifyCode() async {
    if (_codeController.text.isEmpty) return;
    bool success = await AuthService().verifyCode(
      _emailController.text,
      _codeController.text,
      _passwordController.text,
      _usernameController.text,
    );
    if (success) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'RETÖRKI ',
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD9BB8A),
                  ),
                ),
                Text(
                  'Feladatkezelő',
                  style: GoogleFonts.merriweather(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Regisztráció',
              style: GoogleFonts.merriweather(
                fontSize: 16,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail cím',
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
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Jelszó',
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
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Felhasználónév',
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
            const SizedBox(height: 16),
            if (_codeSent)
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Ellenőrző kód',
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
            ElevatedButton(
              onPressed: _codeSent ? _verifyCode : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9BB8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _codeSent ? 'Kód ellenőrzése' : 'Regisztráció',
                style: GoogleFonts.openSans(fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Már van fiókod? Bejelentkezés',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: const Color(0xFF6A778A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
