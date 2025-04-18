import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/ai_assistant.dart'; // Frissítve
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedMonth = DateTime.now();
  bool _isWeeklyView = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('hu_HU', null); // Magyar lokalizáció
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
    });
  }

  void _showAddEventDialog(BuildContext context) {
    final titleController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Új esemény hozzáadása',
                style: GoogleFonts.openSans(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Esemény címe',
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
                                : DateFormat('yyyy.MM.dd')
                                    .format(selectedDate!),
                            style: GoogleFonts.openSans(color: Colors.grey),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
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
                    // Itt később implementálhatjuk az események mentését
                    Navigator.pop(context);
                  },
                  child: const Text('Hozzáadás'),
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
    final projectProvider = Provider.of<ProjectProvider>(context);
    final projects = projectProvider.projects;

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
                  'Naptár',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A778A),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showAddEventDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9BB8A),
                      ),
                      child: Text(
                        'Új esemény',
                        style: GoogleFonts.openSans(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isWeeklyView = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isWeeklyView
                            ? Colors.grey[300]
                            : const Color(0xFFD9BB8A),
                      ),
                      child: Text(
                        'Havi nézet',
                        style: GoogleFonts.openSans(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isWeeklyView = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isWeeklyView
                            ? const Color(0xFFD9BB8A)
                            : Colors.grey[300],
                      ),
                      child: Text(
                        'Heti nézet',
                        style: GoogleFonts.openSans(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _isWeeklyView
                      ? _buildWeeklyView(projects)
                      : _buildMonthlyView(projects),
                ),
              ],
            ),
          ),
          const AIAssistant(), // Frissítve
        ],
      ),
    );
  }

  Widget _buildMonthlyView(List<Project> projects) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _selectedMonth =
                      DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                });
              },
            ),
            Text(
              DateFormat('yyyy. MMMM', 'hu_HU').format(_selectedMonth),
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _selectedMonth =
                      DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Table(
          border: TableBorder.all(color: Colors.grey),
          children: [
            TableRow(
              children: [
                _buildDayHeader('Hétfő'),
                _buildDayHeader('Kedd'),
                _buildDayHeader('Szerda'),
                _buildDayHeader('Csütörtök'),
                _buildDayHeader('Péntek'),
                _buildDayHeader('Szombat'),
                _buildDayHeader('Vasárnap'),
              ],
            ),
            ...List.generate(
              DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day,
              (index) {
                final day = index + 1;
                return TableRow(
                  children: List.generate(
                    7,
                    (colIndex) {
                      final firstDayOfMonth = DateTime(
                          _selectedMonth.year, _selectedMonth.month, 1);
                      final weekday =
                          (firstDayOfMonth.weekday - 1 + colIndex) % 7;
                      if (index == 0 && colIndex < weekday) {
                        return const SizedBox();
                      }
                      if (day - (weekday - colIndex) <= 0) {
                        return const SizedBox();
                      }
                      final currentDate = DateTime(_selectedMonth.year,
                          _selectedMonth.month, day - (weekday - colIndex));
                      return _buildDayCell(currentDate, projects);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyView(List<Project> projects) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _selectedMonth =
                      _selectedMonth.subtract(const Duration(days: 7));
                });
              },
            ),
            Text(
              'Heti nézet: ${DateFormat('yyyy. MMMM dd', 'hu_HU').format(_selectedMonth)} - ${DateFormat('yyyy. MMMM dd', 'hu_HU').format(_selectedMonth.add(const Duration(days: 6)))}',
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _selectedMonth = _selectedMonth.add(const Duration(days: 7));
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = _selectedMonth.add(Duration(days: index));
              return Column(
                children: [
                  Text(
                    DateFormat('EEEE', 'hu_HU').format(date),
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6A778A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        children: List.generate(
                          24,
                          (hour) => _buildHourCell(hour, date, projects),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeader(String day) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xFFD9BB8A),
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime date, List<Project> projects) {
    final tasksForDate = projects
        .expand((p) => p.tasks)
        .where((t) => isSameDate(t.deadline, date))
        .toList();
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            date.day.toString(),
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: const Color(0xFF6A778A),
            ),
          ),
          if (tasksForDate.isNotEmpty)
            ...tasksForDate.map((task) => Text(
                  task.title,
                  style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey),
                )),
        ],
      ),
    );
  }

  Widget _buildHourCell(int hour, DateTime date, List<Project> projects) {
    final tasksForHour = projects
        .expand((p) => p.tasks)
        .where((t) => isSameDate(t.deadline, date) && t.deadline.hour == hour)
        .toList();
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Text(
            '$hour:00',
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: const Color(0xFF6A778A),
            ),
          ),
          if (tasksForHour.isNotEmpty)
            ...tasksForHour.map((task) => Text(
                  task.title,
                  style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey),
                )),
        ],
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
