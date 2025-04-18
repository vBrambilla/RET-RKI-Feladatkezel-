import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/project_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/ai_assistant.dart';

class BoardsPage extends StatefulWidget {
  const BoardsPage({super.key});

  @override
  State<BoardsPage> createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final tasks = projectProvider.projects.expand((p) => p.tasks).toList();

    return Scaffold(
      backgroundColor: Colors.white, // Fehér háttér
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(),
                Text(
                  'Munkatáblák',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: Text(
                            'Nincsenek feladatok',
                            style: GoogleFonts.openSans(
                                fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  task.title,
                                  style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  task.description,
                                  style: GoogleFonts.openSans(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          const AIAssistant(),
        ],
      ),
    );
  }
}
