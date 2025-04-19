import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_header.dart';
import '../widgets/ai_assistant.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(),
                  Text(
                    'Üdvözöljük a RETÖRKI Feladatkezelőben!',
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6A778A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Válasszon egy munkatáblát a kezdéshez',
                        style: GoogleFonts.openSans(
                            fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const AIAssistant(),
          ],
        ),
      ),
    );
  }
}
