import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleCompletion;
  final VoidCallback onArchive;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleCompletion,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: task.isCompleted ? Colors.grey : const Color(0xFF6A778A),
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Határidő: ${task.deadline.toString()} | Prioritás: ${task.priority}',
              style: GoogleFonts.openSans(
                fontSize: 12,
                color: const Color(0xFF6A778A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onToggleCompletion,
                  child: Text(
                    task.isCompleted ? 'Visszavonás' : 'Teljesítve',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onArchive,
                  child: Text(
                    'Archiválás',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
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
}
