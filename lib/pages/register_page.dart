import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isCodeSent = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_formKey.currentState!.validate()) {
      await AuthService().sendVerificationCode(_emailController.text);
      setState(() {
        _isCodeSent = true;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      bool success = await AuthService().verifyCode(
        _emailController.text,
        _codeController.text,
      );
      if (success) {
        await AuthService().register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
          _usernameController.text, // name
          'user', // role
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hibás kód')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Regisztráció',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Felhasználónév',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kérlek, add meg a felhasználónevet!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kérlek, add meg az email címet!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Jelszó',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kérlek, add meg a jelszót!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                if (_isCodeSent)
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'Ellenőrző kód',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kérlek, add meg a kódot!';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16.0),
                if (!_isCodeSent)
                  ElevatedButton(
                    onPressed: _sendCode,
                    child: const Text('Kód küldése'),
                  )
                else
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Regisztráció'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Bejelentkezés'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
