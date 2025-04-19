import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/boards_page.dart';
import 'pages/personal_board_page.dart';
import 'pages/team_board_page.dart';
import 'pages/calendar_page.dart';
import 'pages/messages_page.dart';
import 'pages/notifications_page.dart';
import 'pages/profile_page.dart';
import 'pages/archive_page.dart';
import 'pages/users_management_page.dart';
import 'providers/project_provider.dart';
import 'providers/user_provider.dart';
import 'services/auth_service.dart';
import 'theme.dart';

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
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'RETÖRKI Feladatkezelő',
        theme: AppTheme.lightTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/boards': (context) => const BoardsPage(),
          '/personal_board': (context) =>
              const PersonalBoardPage(boardId: 'default'),
          '/team_board': (context) => const TeamBoardPage(boardId: 'default'),
          '/calendar': (context) => const CalendarPage(),
          '/messages': (context) => const MessagesPage(),
          '/notifications': (context) => const NotificationsPage(),
          '/profile': (context) => const ProfilePage(),
          '/archive': (context) => const ArchivePage(),
          '/users_management': (context) => const UsersManagementPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name != null) {
            if (settings.name!.startsWith('/personal_board/')) {
              final id = settings.name!.split('/').last;
              return MaterialPageRoute(
                builder: (context) => PersonalBoardPage(boardId: id),
              );
            }
            if (settings.name!.startsWith('/team_board/')) {
              final id = settings.name!.split('/').last;
              return MaterialPageRoute(
                builder: (context) => TeamBoardPage(boardId: id),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
