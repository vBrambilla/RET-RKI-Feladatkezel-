import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retorki_feladatkezelo/widgets/app_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Irányítópult',
        showBackButton: false,
        showMenu: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Üdvözöllek az Irányítópulton!',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 16.0),
            const Expanded(
              child: Center(
                child: Text('Itt láthatod az összefoglalót.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
