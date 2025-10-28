import 'package:flutter/material.dart';
import 'create_note_screen.dart';
import 'statistics_screen.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/note_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NotesProvider>(context).notes;

    return Scaffold(
      appBar: AppBar(
        title: Text('Noti'),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteItem(
            title: note.title!,
            content: note.content!,
            isDone: note.isDone!,
            onToggleDone: (value) {
              Provider.of<NotesProvider>(context, listen: false)
                  .toggleDone(note, value);
            },
            onDelete: () {
              Provider.of<NotesProvider>(context, listen: false).deleteNote(note);
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
        child: Icon(Icons.add),
      ),
    );
  }
}
