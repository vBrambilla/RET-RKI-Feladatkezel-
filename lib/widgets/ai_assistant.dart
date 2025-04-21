import 'package:flutter/material.dart';
import 'package:retorki_feladatkezelo/widgets/chat_widget.dart';

enum AssistantSize { icon, small, large }

class AIAssistant extends StatefulWidget {
  const AIAssistant({super.key});

  @override
  State<AIAssistant> createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistant> {
  AssistantSize _size = AssistantSize.icon;
  bool _hasUnreadMessages = false;
  bool _isHovered = false;

  void _toggleSize() {
    setState(() {
      if (_size == AssistantSize.icon) {
        _size = AssistantSize.small;
        _hasUnreadMessages = false;
      } else if (_size == AssistantSize.small) {
        _size = AssistantSize.large;
      } else {
        _size = AssistantSize.small;
      }
    });
  }

  void _closeAssistant() {
    setState(() {
      _size = AssistantSize.icon;
      _hasUnreadMessages = false;
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
        decoration: _size == AssistantSize.icon
            ? null
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
        child: _size == AssistantSize.icon
            ? Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: InkWell(
                      onTap: _toggleSize,
                      onHover: (isHovering) {
                        setState(() {
                          _isHovered = isHovering;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56.0,
                        height: 56.0,
                        color: _isHovered
                            ? const Color(0xFFD9BB8A).withValues(alpha: 0.2)
                            : Colors.white,
                        child: const Center(
                          child: Icon(
                            Icons.smart_toy,
                            color: Color(0xFFD9BB8A),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_hasUnreadMessages)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD9BB8A),
                        ),
                      ),
                    ),
                ],
              )
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9BB8A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'AI Segéd',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _size == AssistantSize.small
                                    ? Icons.fullscreen
                                    : Icons.fullscreen_exit,
                                color: Colors.white,
                              ),
                              onPressed: _toggleSize,
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: _closeAssistant,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: ChatWidget()),
                ],
              ),
      ),
    );
  }
}
