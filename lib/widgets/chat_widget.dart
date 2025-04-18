import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _messages.add(_controller.text);
      // Mock AI válasz
      _messages.add('AI: Ez egy válasz: ${_controller.text}');
      // Példa Task létrehozása (ez lehet a hibás rész)
      final exampleTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _controller.text,
        description: 'AI által generált leírás',
        boardId: 'chat_board',
        assignedUsers: ['Superadmin'],
        createdBy: 'AI Assistant',
        deadline: DateTime.now().add(const Duration(days: 1)),
        priority: 'Közepes',
        isTeamTask: false,
      );
      // Ide később hozzáadhatjuk a Task mentését
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  _messages[index],
                  style: GoogleFonts.openSans(fontSize: 16),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Üzenet küldése...',
                    hintStyle: GoogleFonts.openSans(color: Colors.grey),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
