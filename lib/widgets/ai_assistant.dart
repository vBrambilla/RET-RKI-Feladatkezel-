import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/chat_widget.dart';

enum AssistantSize { icon, small, large } // Enum top-level scope-ban

class AIAssistant extends StatefulWidget {
  const AIAssistant({super.key});

  @override
  State<AIAssistant> createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistant> {
  AssistantSize _size = AssistantSize.icon; // Alapértelmezett: ikon
  bool _hasUnreadMessages = false; // Mock: később valódi logika

  void _toggleSize() {
    setState(() {
      if (_size == AssistantSize.icon) {
        _size = AssistantSize.small;
        _hasUnreadMessages = false; // Olvasatlan üzenetek törlése
      } else if (_size == AssistantSize.small) {
        _size = AssistantSize.large;
      } else {
        _size = AssistantSize.icon;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _size == AssistantSize.large
            ? MediaQuery.of(context).size.width * 0.7
            : _size == AssistantSize.small
                ? MediaQuery.of(context).size.width * 0.3
                : 56.0,
        height: _size == AssistantSize.large
            ? MediaQuery.of(context).size.height * 0.7
            : _size == AssistantSize.small
                ? MediaQuery.of(context).size.height * 0.4
                : 56.0,
        decoration: BoxDecoration(
          color: _size == AssistantSize.icon
              ? Colors.white // Fehér háttér az ikonhoz
              : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _size == AssistantSize.icon
            ? Stack(
                children: [
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape
                            .circle, // Rombusz helyett kör (nincs rombusz ikon)
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4.0,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'AI',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD9BB8A), // Arany szín
                          ),
                        ),
                      ),
                    ),
                    onPressed: _toggleSize,
                  ),
                  if (_hasUnreadMessages)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD9BB8A), // Arany pötty
                        ),
                      ),
                    ),
                ],
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'AI Segéd',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6A778A),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _toggleSize,
                      ),
                    ],
                  ),
                  Expanded(child: ChatWidget()),
                ],
              ),
      ),
    );
  }
}
