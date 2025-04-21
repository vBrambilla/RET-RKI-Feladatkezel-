import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retorki_feladatkezelo/models/task.dart';
import 'package:retorki_feladatkezelo/providers/project_provider.dart';
import 'package:retorki_feladatkezelo/widgets/app_header.dart';
import 'package:retorki_feladatkezelo/widgets/ai_assistant.dart';

class PersonalBoardPage extends StatefulWidget {
  final String boardId;

  const PersonalBoardPage({super.key, required this.boardId});

  @override
  State<PersonalBoardPage> createState() => _PersonalBoardPageState();
}

class _PersonalBoardPageState extends State<PersonalBoardPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      final newTask = Task(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _selectedDate,
        status: 'Folyamatban',
        assignedUsers: [],
        boardId: widget.boardId,
        createdBy: 'current_user',
        isTeamTask: false,
        priority: 'Közepes',
      );
      projectProvider.addTask(widget.boardId, newTask);
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedDate = null;
      });
      Navigator.pop(context);
    }
  }

  void _updateTaskStatus(Task task, String newStatus) {
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    projectProvider.updateTaskStatus(widget.boardId, task.id, newStatus);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final tasks = projectProvider.getTasks(widget.boardId);

    return Scaffold(
      appBar: AppHeader(
        title: 'Személyes Tábla',
        showBackButton: true,
        showMenu: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Személyes Munkatábla - ${widget.boardId}',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildColumn(
                          'Folyamatban',
                          tasks
                              .where((task) => task.status == 'Folyamatban')
                              .toList()),
                      const SizedBox(width: 16.0),
                      _buildColumn(
                          'Elvégzett',
                          tasks
                              .where((task) => task.status == 'Elvégzett')
                              .toList()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const AIAssistant(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildColumn(String status, List<Task> tasks) {
    return Expanded(
      child: DragTarget<Task>(
        onAcceptWithDetails: (details) {
          _updateTaskStatus(details.data, status);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9BB8A)),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Draggable<Task>(
                        data: task,
                        feedback: Material(
                          child: Card(
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                task.title,
                                style: GoogleFonts.openSans(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Container(),
                        child: Card(
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  task.description,
                                  style: GoogleFonts.openSans(fontSize: 14),
                                ),
                                const SizedBox(height: 4.0),
                                if (task.deadline != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 16),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        'Határidő: ${task.deadline!.toString().substring(0, 10)}',
                                        style:
                                            GoogleFonts.openSans(fontSize: 14),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Új Feladat',
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Cím',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kérlek, add meg a címet!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Leírás',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Nincs határidő kiválasztva'
                              : 'Határidő: ${_selectedDate!.toString().substring(0, 10)}',
                          style: GoogleFonts.openSans(fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Dátum választás'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mégse'),
            ),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text('Hozzáadás'),
            ),
          ],
        );
      },
    );
  }
}
