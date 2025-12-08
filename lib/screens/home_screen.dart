import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_item.dart';
import 'create_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
  }

  /// Загружаем настройку из SharedPreferences
  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('isGrid') ?? false;
    setState(() => _isGrid = saved);
  }

  /// Сохраняем при переключении
  Future<void> _toggleView() async {
    setState(() => _isGrid = !_isGrid);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGrid', _isGrid);
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NotesProvider>(context).notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Noti'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list_rounded : Icons.grid_view_rounded),
            onPressed: _toggleView,
            tooltip: _isGrid ? 'Показать списком' : 'Показать сеткой',
          ),
        ],
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
          : _isGrid
              ? GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: notes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteItem(
                      title: note.title,
                      content: note.content,
                      isDone: note.isDone,
                      deadline: note.deadline,
                      category: note.category,
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
                      deadline: note.deadline,
                      category: note.category,
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
            MaterialPageRoute(builder: (context) => const CreateNoteScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
