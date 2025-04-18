import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/user_service.dart';

class NameInputDialog extends StatefulWidget {
  final String currentName;
  final Function(String) onNameSaved;

  const NameInputDialog({
    Key? key,
    required this.currentName,
    required this.onNameSaved,
  }) : super(key: key);

  @override
  State<NameInputDialog> createState() => _NameInputDialogState();
}

class _NameInputDialogState extends State<NameInputDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Név megadása',
        style: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF666666),
        ),
      ),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Felhasználónév',
                hintText: 'Add meg a neved',
                labelStyle: GoogleFonts.roboto(
                  color: const Color(0xFF666666),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: const Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Figyelem: A név csak egyszer szerkeszthető!',
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Mégsem',
            style: GoogleFonts.roboto(
              color: Colors.grey,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onNameSaved(_nameController.text);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Mentés',
            style: GoogleFonts.roboto(),
          ),
        ),
      ],
    );
  }
}