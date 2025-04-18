import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/personal_board_page.dart';
import 'pages/team_board_page.dart';
import 'pages/calendar_page.dart';
import 'pages/notifications_page.dart';
import 'pages/messages_page.dart';
import 'pages/archive_page.dart';
import 'pages/profile_page.dart';
import 'pages/users_management_page.dart';
import 'models/user.dart';
import 'providers/project_provider.dart'; // Hozzáadva

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'RETÖRKI Feladatkezelő',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/personal_board': (context) => const PersonalBoardPage(),
          '/team_board': (context) => const TeamBoardPage(),
          '/calendar': (context) => const CalendarPage(),
          '/notifications': (context) => const NotificationsPage(),
          '/messages': (context) => const MessagesPage(),
          '/archive': (context) => const ArchivePage(),
          '/profile': (context) => const ProfilePage(),
          '/users_management': (context) => const UsersManagementPage(),
        },
      ),
    );
  }
}

// Mock user a teszteléshez
final User mockUser = User(
  id: '1',
  username: 'Superadmin',
  email: 'superadmin@retorki.hu',
  role: 'Admin',
);
