import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retorki_feladatkezelo/widgets/app_header.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Archívum',
        showBackButton: true,
        showMenu: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Archívum',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 16.0),
            const Expanded(
              child: Center(
                child: Text('Jelenleg üres az archívum'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
