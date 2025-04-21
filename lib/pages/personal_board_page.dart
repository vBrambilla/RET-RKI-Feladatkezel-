import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme.dart';

class PersonalBoardPage extends StatefulWidget {
  const PersonalBoardPage({Key? key}) : super(key: key);

  @override
  State<PersonalBoardPage> createState() => _PersonalBoardPageState();
}

class _PersonalBoardPageState extends State<PersonalBoardPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedStatus = 'todo';
  DateTime? _selectedDueDate;
  String _selectedPriority = 'medium';
  String _selectedAssignee = '';

  void _addTask(BuildContext context) {
    if (_titleController.text.isNotEmpty) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.addTask(Task(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
        assignedTo: _selectedAssignee,
        assignedUsers: [],
        createdBy: 'currentUserId',
        isTeamTask: false,
        deadline: _selectedDueDate,
        boardId: 'personalBoard',
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
          'Personal Board',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
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
                  _buildAddTaskForm(context),
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

  Widget _buildAddTaskForm(BuildContext context) {
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
              onPressed: () => _addTask(context),
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
                          Text(
                            task.deadline == null
                                ? 'No Deadline'
                                : 'Deadline: ${task.deadline!.toString().substring(0, 10)}',
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          taskProvider.deleteTask(task.id);
                        },
                      ),
                      onTap: () {
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
                                    decoration: const InputDecoration(
                                        labelText: 'Title'),
                                  ),
                                  TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                        labelText: 'Description'),
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
                                    decoration: const InputDecoration(
                                        labelText: 'Assignee'),
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
                                          final pickedDate =
                                              await showDatePicker(
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
                                  taskProvider.updateTask(Task(
                                    id: task.id,
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    status: _selectedStatus,
                                    dueDate: _selectedDueDate,
                                    priority: _selectedPriority,
                                    assignedTo: _selectedAssignee,
                                    assignedUsers: task.assignedUsers,
                                    createdBy: task.createdBy,
                                    isTeamTask: task.isTeamTask,
                                    deadline: _selectedDueDate,
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
                      },
                    ),
                  );
                },
              ),
      ],
    );
  }
}
