import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_item.dart';
import 'create_note_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NotesProvider>(context).notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Noti'),
      ),
      body: notes.isEmpty
          ? Center(
              child: Text(
                'Нет заметок. Добавьте первую!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue.shade400,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteItem(
                  title: note.title,
                  content: note.content,
                  isDone: note.isDone,
                  onToggleDone: (value) {
                    Provider.of<NotesProvider>(context, listen: false)
                        .toggleDone(note, value);
                  },
                  onDelete: () {
                    Provider.of<NotesProvider>(context, listen: false)
                        .deleteNote(note);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNoteScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
