import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/project_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/ai_assistant.dart';

class PersonalBoardPage extends StatefulWidget {
  const PersonalBoardPage({super.key});

  @override
  State<PersonalBoardPage> createState() => _PersonalBoardPageState();
}

class _PersonalBoardPageState extends State<PersonalBoardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
    });
  }

  void _showAddTaskDialog(BuildContext context, {Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController =
        TextEditingController(text: task?.description ?? '');
    final priorityController =
        TextEditingController(text: task?.priority ?? 'Közepes');
    DateTime? selectedDate = task?.deadline;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            task == null ? 'Új feladat hozzáadása' : 'Feladat szerkesztése',
            style:
                GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Feladat címe',
                    hintStyle: GoogleFonts.openSans(color: Colors.grey),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Leírás',
                    hintStyle: GoogleFonts.openSans(color: Colors.grey),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priorityController,
                  decoration: InputDecoration(
                    hintText: 'Prioritás (Alacsony, Közepes, Magas)',
                    hintStyle: GoogleFonts.openSans(color: Colors.grey),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'Dátum választása'
                            : DateFormat('yyyy.MM.dd').format(selectedDate!),
                        style: GoogleFonts.openSans(color: Colors.grey),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          locale: const Locale('hu', 'HU'),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mégse'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty || selectedDate == null)
                  return;

                final newTask = Task(
                  id: task?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text.isEmpty
                      ? 'Nincs leírás'
                      : descriptionController.text,
                  boardId: 'personal_board',
                  assignedUsers: ['Superadmin'],
                  createdBy: 'Superadmin',
                  deadline: selectedDate!,
                  priority: priorityController.text.isEmpty
                      ? 'Közepes'
                      : priorityController.text,
                  isTeamTask: false,
                );

                final projectProvider =
                    Provider.of<ProjectProvider>(context, listen: false);
                if (task == null) {
                  // Új feladat hozzáadása
                  projectProvider.addTaskToProject(
                      '1', newTask); // '1' a mock projekt ID
                } else {
                  // Feladat szerkesztése
                  final updatedProject = Project(
                    id: '1',
                    name: projectProvider.projects[0].name,
                    createdBy: projectProvider.projects[0].createdBy,
                    tasks: projectProvider.projects[0].tasks.map((t) {
                      return t.id == task.id ? newTask : t;
                    }).toList(),
                  );
                  projectProvider.updateProject(updatedProject);
                }

                Navigator.pop(context);
              },
              child: const Text('Mentés'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final tasks = projectProvider.projects
        .expand((p) => p.tasks)
        .where((t) => !t.isTeamTask)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(),
                Text(
                  'Személyes munkatábla',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showAddTaskDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9BB8A),
                  ),
                  child: Text(
                    'Új feladat',
                    style:
                        GoogleFonts.openSans(fontSize: 16, color: Colors.white),
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
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showAddTaskDialog(context, task: task),
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
