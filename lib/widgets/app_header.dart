import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/dashboard';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4.0,
      leading: currentRoute != '/dashboard'
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF6A778A)),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/dashboard', (route) => false);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'RETÖRKI ',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD9BB8A),
                    ),
                  ),
                  TextSpan(
                    text: 'Feladatkezelő',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6A778A),
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      actions: [
        _buildNavItem(context, Icons.home, 'Főoldal', '/dashboard',
            currentRoute == '/dashboard'),
        _buildNavItem(
            context,
            Icons.person,
            'Személyes munkatábla',
            '/personal_board/default',
            currentRoute == '/personal_board/default'),
        _buildNavItem(context, Icons.group, 'Közös munkatáblák',
            '/team_board/default', currentRoute == '/team_board/default'),
        _buildNavItem(context, Icons.calendar_today, 'Naptár', '/calendar',
            currentRoute == '/calendar'),
        _buildNavItem(context, Icons.message, 'Üzenetek', '/messages',
            currentRoute == '/messages'),
        _buildNavItem(context, Icons.notifications, 'Értesítések',
            '/notifications', currentRoute == '/notifications'),
        _buildNavItem(context, Icons.person_outline, 'Profil', '/profile',
            currentRoute == '/profile'),
        _buildNavItem(context, Icons.archive, 'Archivált elemek', '/archive',
            currentRoute == '/archive'),
        _buildNavItem(
            context,
            Icons.supervisor_account,
            'Felhasználók kezelése',
            '/users_management',
            currentRoute == '/users_management'),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: Text(
              'Kijelentkezés',
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: const Color(0xFF6A778A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label,
      String route, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFD9BB8A).withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? const Color(0xFFD9BB8A)
                      : const Color(0xFF6A778A),
                  size: 20,
                ),
                const SizedBox(height: 4.0),
                SizedBox(
                  width: 80,
                  child: Text(
                    label,
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      color: isSelected
                          ? const Color(0xFFD9BB8A)
                          : const Color(0xFF6A778A),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
