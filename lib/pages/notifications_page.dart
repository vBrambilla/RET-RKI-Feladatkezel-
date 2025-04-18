import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_header.dart';
import '../widgets/ai_assistant.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Material widget hozzáadva a lokalizációhoz
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(),
                  Text(
                    'Értesítések',
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
                        'Nincsenek értesítések',
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
