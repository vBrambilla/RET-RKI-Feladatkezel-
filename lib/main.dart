import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:retorki_feladatkezelo/pages/login_page.dart';
import 'package:retorki_feladatkezelo/pages/register_page.dart';
import 'package:retorki_feladatkezelo/pages/dashboard_page.dart';
import 'package:retorki_feladatkezelo/pages/personal_board_page.dart';
import 'package:retorki_feladatkezelo/pages/team_board_page.dart';
import 'package:retorki_feladatkezelo/pages/notifications_page.dart';
import 'package:retorki_feladatkezelo/pages/messages_page.dart';
import 'package:retorki_feladatkezelo/pages/calendar_page.dart';
import 'package:retorki_feladatkezelo/pages/boards_page.dart';
import 'package:retorki_feladatkezelo/pages/profile_page.dart';
import 'package:retorki_feladatkezelo/pages/users_management_page.dart';
import 'package:retorki_feladatkezelo/pages/archive_page.dart';
import 'package:retorki_feladatkezelo/providers/user_provider.dart';
import 'package:retorki_feladatkezelo/providers/task_provider.dart';
import 'package:retorki_feladatkezelo/providers/project_provider.dart';
import 'package:retorki_feladatkezelo/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'RETORKI Feladatkezelő',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/personal-board': (context) => const PersonalBoardPage(),
          '/team-board': (context) => const TeamBoardPage(),
          '/notifications': (context) => const NotificationsPage(),
          '/messages': (context) => const MessagesPage(),
          '/calendar': (context) => const CalendarPage(),
          '/boards': (context) => const BoardsPage(),
          '/profile': (context) => const ProfilePage(),
          '/users-management': (context) => const UsersManagementPage(),
          '/archive': (context) => const ArchivePage(),
        },
      ),
    );
  }
}
