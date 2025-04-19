import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task.dart';
import '../widgets/app_header.dart';
import '../providers/project_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Task>> _events = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
      _loadEvents();
    });
  }

  void _loadEvents() {
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    final allTasks = <Task>[];
    final tasks = projectProvider.getTasks('default');
    allTasks.addAll(tasks);

    setState(() {
      _events = {};
      for (var task in allTasks) {
        if (task.deadline != null) {
          final date = DateTime(
              task.deadline!.year, task.deadline!.month, task.deadline!.day);
          _events[date] ??= [];
          _events[date]!.add(task);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Naptár',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 16.0),
            TableCalendar<Task>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFFD9BB8A),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF6A778A),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                formatButtonVisible: false,
              ),
              eventLoader: (day) {
                return _events[DateTime(day.year, day.month, day.day)] ?? [];
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _selectedDay != null &&
                      _events[DateTime(_selectedDay!.year, _selectedDay!.month,
                              _selectedDay!.day)] !=
                          null
                  ? ListView(
                      children: _events[DateTime(_selectedDay!.year,
                              _selectedDay!.month, _selectedDay!.day)]!
                          .map((task) => Card(
                                elevation: 2.0,
                                child: ListTile(
                                  title: Text(
                                    task.title,
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(task.description),
                                ),
                              ))
                          .toList(),
                    )
                  : const Center(
                      child: Text('Nincs esemény ezen a napon'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
