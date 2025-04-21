import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retorki_feladatkezelo/pages/archive_page.dart'; // Módosítva
import 'package:retorki_feladatkezelo/pages/calendar_page.dart';
import 'package:retorki_feladatkezelo/pages/dashboard_page.dart';
import 'package:retorki_feladatkezelo/pages/login_page.dart';
import 'package:retorki_feladatkezelo/pages/messages_page.dart';
import 'package:retorki_feladatkezelo/pages/notifications_page.dart';
import 'package:retorki_feladatkezelo/pages/personal_board_page.dart';
import 'package:retorki_feladatkezelo/pages/profile_page.dart';
import 'package:retorki_feladatkezelo/pages/register_page.dart';
import 'package:retorki_feladatkezelo/pages/team_board_page.dart';
import 'package:retorki_feladatkezelo/pages/users_management_page.dart';
import 'package:retorki_feladatkezelo/providers/project_provider.dart';
import 'package:retorki_feladatkezelo/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
          '/personal_board/default': (context) =>
              const PersonalBoardPage(boardId: 'default'),
          '/team_board/default': (context) =>
              const TeamBoardPage(boardId: 'default'),
          '/calendar': (context) => const CalendarPage(),
          '/messages': (context) => const MessagesPage(),
          '/notifications': (context) => const NotificationsPage(),
          '/archived': (context) => const ArchivePage(), // Módosítva
          '/profile': (context) => const ProfilePage(),
          '/users_management': (context) => const UsersManagementPage(),
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}
