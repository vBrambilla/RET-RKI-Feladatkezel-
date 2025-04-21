import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showMenu;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showMenu = false,
  });

  Widget buildMenuItem(BuildContext context, String label, String route) {
    return ListTile(
      title: Text(label),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushNamed(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Vissza',
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      centerTitle: true,
      actions: showMenu
          ? [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ]
          : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey[300],
          height: 1.0,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);

  Widget? buildEndDrawer(BuildContext context) {
    if (!showMenu) return null;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          buildMenuItem(context, 'Archivált elemek', '/archived'),
          buildMenuItem(context, 'Profil', '/profile'),
        ],
      ),
    );
  }
}
