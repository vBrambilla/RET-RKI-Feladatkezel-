import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/user_provider.dart';
import '../theme.dart';

class TeamBoardPage extends StatefulWidget {
  const TeamBoardPage({Key? key}) : super(key: key);

  @override
  State<TeamBoardPage> createState() => _TeamBoardPageState();
}

class _TeamBoardPageState extends State<TeamBoardPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _boardNameController = TextEditingController();
  String _selectedStatus = 'todo';
  DateTime? _selectedDueDate;
  String _selectedPriority = 'medium';
  String _selectedAssignee = '';
  bool _isAddingBoard = false;

  void _addTask(BuildContext context, TaskProvider taskProvider) {
    if (_titleController.text.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.user;
      taskProvider.addTask(Task(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
        dueDate: _selectedDueDate,
        deadline: _selectedDueDate,
        priority: _selectedPriority,
        assignedTo: _selectedAssignee ?? '',
        assignedUsers: [],
        createdBy: currentUser?.id ?? 'unknown',
        isTeamTask: true,
        boardId: 'teamBoard',
        isCompleted: false,
      ));
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedStatus = 'todo';
        _selectedDueDate = null;
        _selectedPriority = 'medium';
        _selectedAssignee = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Team Board',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              setState(() {
                _isAddingBoard = true;
              });
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final todoTasks = taskProvider.tasks
              .where((task) => task.status == 'todo')
              .toList();
          final inProgressTasks = taskProvider.tasks
              .where((task) => task.status == 'in_progress')
              .toList();
          final doneTasks = taskProvider.tasks
              .where((task) => task.status == 'done')
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isAddingBoard) _buildAddBoardForm(context),
                  const SizedBox(height: 20),
                  _buildAddTaskForm(context, taskProvider),
                  const SizedBox(height: 20),
                  _buildTaskColumn('To Do', todoTasks, taskProvider),
                  const SizedBox(height: 20),
                  _buildTaskColumn(
                      'In Progress', inProgressTasks, taskProvider),
                  const SizedBox(height: 20),
                  _buildTaskColumn('Done', doneTasks, taskProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddBoardForm(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Board',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _boardNameController,
              decoration: const InputDecoration(
                labelText: 'Board Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isAddingBoard = false;
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_boardNameController.text.isNotEmpty) {
                      setState(() {
                        _isAddingBoard = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    'Add Board',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTaskForm(BuildContext context, TaskProvider taskProvider) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Task',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ['todo', 'in_progress', 'done']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: ['low', 'medium', 'high']
                  .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Assignee',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedAssignee = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _selectedDueDate == null
                      ? 'No Due Date'
                      : 'Due: ${_selectedDueDate!.toString().substring(0, 10)}',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDueDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    'Pick Due Date',
                    style: GoogleFonts.poppins(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _addTask(context, taskProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text(
                'Add Task',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskColumn(
      String title, List<Task> tasks, TaskProvider taskProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        tasks.isEmpty
            ? Text(
                'No tasks',
                style: GoogleFonts.poppins(fontSize: 16),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.description),
                          Text('Priority: ${task.priority}'),
                          Text('Assigned to: ${task.assignedTo}'),
                          Text(
                            task.dueDate == null
                                ? 'No Due Date'
                                : 'Due: ${task.dueDate!.toString().substring(0, 10)}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _editTask(context, task, taskProvider),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              taskProvider.deleteTask(task.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  void _editTask(BuildContext context, Task task, TaskProvider taskProvider) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    setState(() {
      _selectedStatus = task.status;
      _selectedDueDate = task.dueDate;
      _selectedPriority = task.priority;
      _selectedAssignee = task.assignedTo;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Task',
          style: GoogleFonts.poppins(),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: ['todo', 'in_progress', 'done']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: ['low', 'medium', 'high']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Assignee'),
                onChanged: (value) {
                  setState(() {
                    _selectedAssignee = value;
                  });
                },
              ),
              Row(
                children: [
                  Text(
                    _selectedDueDate == null
                        ? 'No Due Date'
                        : 'Due: ${_selectedDueDate!.toString().substring(0, 10)}',
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDueDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Pick Due Date'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final currentUser = userProvider.user;
              taskProvider.updateTask(Task(
                id: task.id,
                title: _titleController.text,
                description: _descriptionController.text,
                status: _selectedStatus,
                dueDate: _selectedDueDate,
                deadline: _selectedDueDate,
                priority: _selectedPriority,
                assignedTo: _selectedAssignee ?? '',
                assignedUsers: task.assignedUsers,
                createdBy: currentUser?.id ?? 'unknown',
                isTeamTask: task.isTeamTask,
                boardId: task.boardId,
                isCompleted: task.isCompleted,
              ));
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetails(Task task, TaskProvider taskProvider) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            task.description,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Priority: ${task.priority}',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          Text(
            'Assigned to: ${task.assignedTo}',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          Text(
            'Created by: ${task.createdBy}',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          Text(
            task.dueDate == null
                ? 'No Due Date'
                : 'Due: ${task.dueDate!.toString().substring(0, 10)}',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (currentUser != null && task.createdBy == currentUser.id)
                TextButton(
                  onPressed: () {
                    _editTask(context, task, taskProvider);
                  },
                  child: Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                      color: Colors.blue,
                    ),
                  ),
                ),
              if (currentUser != null && task.createdBy == currentUser.id)
                TextButton(
                  onPressed: () {
                    taskProvider.deleteTask(task.id);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
