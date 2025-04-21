import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retorki_feladatkezelo/models/task.dart';
import 'package:retorki_feladatkezelo/models/user.dart';
import 'package:retorki_feladatkezelo/providers/task_provider.dart';
import 'package:retorki_feladatkezelo/providers/user_provider.dart';
import 'package:retorki_feladatkezelo/widgets/app_header.dart';

class TeamBoardPage extends StatefulWidget {
  final String boardId;

  const TeamBoardPage({super.key, required this.boardId});

  @override
  State<TeamBoardPage> createState() => _TeamBoardPageState();
}

class _TeamBoardPageState extends State<TeamBoardPage> {
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescriptionController;
  String _selectedPriority = 'Alacsony';
  String? _selectedAssigneeId;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // A users helyett az aktuális felhasználót használjuk, később módosítjuk
    final currentUser = userProvider.currentUser;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Új Feladat',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6A778A),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _taskTitleController,
                      decoration: InputDecoration(
                        labelText: 'Feladat Címe',
                        labelStyle: GoogleFonts.openSans(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _taskDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Leírás',
                        labelStyle: GoogleFonts.openSans(),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: InputDecoration(
                        labelText: 'Prioritás',
                        labelStyle: GoogleFonts.openSans(),
                        border: const OutlineInputBorder(),
                      ),
                      items: ['Alacsony', 'Közepes', 'Magas']
                          .map((priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: GoogleFonts.openSans(),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedAssigneeId,
                      decoration: InputDecoration(
                        labelText: 'Hozzárendelve',
                        labelStyle: GoogleFonts.openSans(),
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        if (currentUser != null)
                          DropdownMenuItem(
                            value: currentUser.id,
                            child: Text(
                              currentUser
                                  .displayName, // name helyett displayName
                              style: GoogleFonts.openSans(),
                            ),
                          ),
                        // Ha később lesz users lista, itt lehet bővíteni
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAssigneeId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _selectedDueDate = selectedDate;
                          });
                        }
                      },
                      child: Text(
                        _selectedDueDate == null
                            ? 'Határidő Kiválasztása'
                            : 'Határidő: ${_selectedDueDate!.toString().split(' ')[0]}',
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF6A778A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Mégse',
                    style: GoogleFonts.openSans(
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_taskTitleController.text.isNotEmpty) {
                      final newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _taskTitleController.text,
                        description: _taskDescriptionController.text,
                        priority: _selectedPriority,
                        assignedTo: _selectedAssigneeId,
                        dueDate: _selectedDueDate,
                        boardId: widget.boardId,
                        status: 'todo',
                      );
                      taskProvider.addTask(newTask);
                      Navigator.of(context).pop();
                      _taskTitleController.clear();
                      _taskDescriptionController.clear();
                      setState(() {
                        _selectedPriority = 'Alacsony';
                        _selectedAssigneeId = null;
                        _selectedDueDate = null;
                      });
                    }
                  },
                  child: Text(
                    'Hozzáadás',
                    style: GoogleFonts.openSans(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    _taskTitleController.text = task.title;
    _taskDescriptionController.text = task.description ?? '';
    _selectedPriority = task.priority;
    _selectedAssigneeId = task.assignedTo;
    _selectedDueDate = task.dueDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Feladat Szerkesztése',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6A778A),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _taskTitleController,
                      decoration: InputDecoration(
                        labelText: 'Feladat Címe',
                        labelStyle: GoogleFonts.openSans(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _taskDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Leírás',
                        labelStyle: GoogleFonts.openSans(),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: InputDecoration(
                        labelText: 'Prioritás',
                        labelStyle: GoogleFonts.openSans(),
                        border: const OutlineInputBorder(),
                      ),
                      items: ['Alacsony', 'Közepes', 'Magas']
                          .map((priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: GoogleFonts.openSans(),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedAssigneeId,
                      decoration: InputDecoration(
                        labelText: 'Hozzárendelve',
                        labelStyle: GoogleFonts.openSans(),
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        if (userProvider.currentUser != null)
                          DropdownMenuItem(
                            value: userProvider.currentUser!.id,
                            child: Text(
                              userProvider.currentUser!
                                  .displayName, // name helyett displayName
                              style: GoogleFonts.openSans(),
                            ),
                          ),
                        // Ha később lesz users lista, itt lehet bővíteni
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAssigneeId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _selectedDueDate = selectedDate;
                          });
                        }
                      },
                      child: Text(
                        _selectedDueDate == null
                            ? 'Határidő Kiválasztása'
                            : 'Határidő: ${_selectedDueDate!.toString().split(' ')[0]}',
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF6A778A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Mégse',
                    style: GoogleFonts.openSans(
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_taskTitleController.text.isNotEmpty) {
                      final updatedTask = Task(
                        id: task.id,
                        title: _taskTitleController.text,
                        description: _taskDescriptionController.text,
                        priority: _selectedPriority,
                        assignedTo: _selectedAssigneeId,
                        dueDate: _selectedDueDate,
                        boardId: task.boardId,
                        status: task.status,
                      );
                      taskProvider.updateTask(updatedTask);
                      Navigator.of(context).pop();
                      _taskTitleController.clear();
                      _taskDescriptionController.clear();
                      setState(() {
                        _selectedPriority = 'Alacsony';
                        _selectedAssigneeId = null;
                        _selectedDueDate = null;
                      });
                    }
                  },
                  child: Text(
                    'Mentés',
                    style: GoogleFonts.openSans(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks
        .where((task) => task.boardId == widget.boardId)
        .toList();

    return Scaffold(
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Csapat Tábla: ${widget.boardId}',
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
                  _buildTaskColumn(context, 'todo', 'Teendő', tasks),
                  const SizedBox(width: 16.0),
                  _buildTaskColumn(
                      context, 'in_progress', 'Folyamatban', tasks),
                  const SizedBox(width: 16.0),
                  _buildTaskColumn(context, 'done', 'Kész', tasks),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: const Color(0xFF6A778A),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskColumn(
      BuildContext context, String status, String title, List<Task> tasks) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final columnTasks = tasks.where((task) => task.status == status).toList();

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: columnTasks.length,
                itemBuilder: (context, index) {
                  final task = columnTasks[index];
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task.description != null)
                            Text(
                              task.description!,
                              style: GoogleFonts.openSans(),
                            ),
                          Text(
                            'Prioritás: ${task.priority}',
                            style: GoogleFonts.openSans(),
                          ),
                          if (task.assignedTo != null)
                            Text(
                              'Hozzárendelve: ${task.assignedTo == userProvider.currentUser?.id ? userProvider.currentUser?.displayName : 'Ismeretlen'}',
                              style: GoogleFonts.openSans(),
                            ),
                          if (task.dueDate != null)
                            Text(
                              'Határidő: ${task.dueDate!.toString().split(' ')[0]}',
                              style: GoogleFonts.openSans(),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditTaskDialog(context, task),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              taskProvider.deleteTask(task.id);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        final newStatus = status == 'todo'
                            ? 'in_progress'
                            : status == 'in_progress'
                                ? 'done'
                                : 'todo';
                        final updatedTask = Task(
                          id: task.id,
                          title: task.title,
                          description: task.description,
                          priority: task.priority,
                          assignedTo: task.assignedTo,
                          dueDate: task.dueDate,
                          boardId: task.boardId,
                          status: newStatus,
                        );
                        taskProvider.updateTask(updatedTask);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
