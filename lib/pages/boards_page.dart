import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retorki_feladatkezelo/pages/personal_board_page.dart';
import 'package:retorki_feladatkezelo/pages/team_board_page.dart';
import 'package:retorki_feladatkezelo/widgets/app_header.dart';

class BoardsPage extends StatelessWidget {
  const BoardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Táblák',
        showBackButton: true,
        showMenu: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Táblák',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  _buildBoardCard(
                    context,
                    'Személyes Tábla',
                    'Saját feladataid és teendőid.',
                    '/personal_board',
                  ),
                  const SizedBox(height: 16.0),
                  _buildBoardCard(
                    context,
                    'Csapat Tábla',
                    'Csapat feladatai és projektjei.',
                    '/team_board/default',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardCard(
      BuildContext context, String title, String description, String route) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6A778A),
          ),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF6A778A),
        ),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
