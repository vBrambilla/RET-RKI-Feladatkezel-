import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isDashboard = currentRoute == '/dashboard';

    return Container(
      color: Colors.white, // Fehér háttérszín
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (!isDashboard)
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey, // Vizuálisan megkülönböztetve
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  Text(
                    'RETÖRKI Feladatkezelő',
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6A778A),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                child: Text(
                  'Kijelentkezés',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: const Color(0xFFD9BB8A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _NavIcon(
                icon: Icons.person,
                label: 'Személyes',
                route: '/personal_board',
                isActive: currentRoute == '/personal_board',
              ),
              _NavIcon(
                icon: Icons.group,
                label: 'Közös',
                route: '/team_board',
                isActive: currentRoute == '/team_board',
              ),
              _NavIcon(
                icon: Icons.calendar_today,
                label: 'Naptár',
                route: '/calendar',
                isActive: currentRoute == '/calendar',
              ),
              _NavIcon(
                icon: Icons.notifications,
                label: 'Értesítések',
                route: '/notifications',
                isActive: currentRoute == '/notifications',
              ),
              _NavIcon(
                icon: Icons.message,
                label: 'Üzenetek',
                route: '/messages',
                isActive: currentRoute == '/messages',
              ),
              _NavIcon(
                icon: Icons.archive,
                label: 'Archivált',
                route: '/archive',
                isActive: currentRoute == '/archive',
              ),
              _NavIcon(
                icon: Icons.person_outline,
                label: 'Profil',
                route: '/profile',
                isActive: currentRoute == '/profile',
              ),
              _NavIcon(
                icon: Icons.supervisor_account,
                label: 'Felhasználók',
                route: '/users_management',
                isActive: currentRoute == '/users_management',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFD9BB8A) : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF6A778A),
                size: 24,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFFD9BB8A)
                    : const Color(0xFF6A778A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
