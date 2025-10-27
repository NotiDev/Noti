import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final content = _contentController.text;

                if (title.isNotEmpty && content.isNotEmpty) {
                  final newNote = Note(
                    title: title,
                    content: content,
                  );
                  Provider.of<NotesProvider>(context, listen: false)
                      .addNote(newNote);
                  Navigator.pop(context);
                }
              },
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
