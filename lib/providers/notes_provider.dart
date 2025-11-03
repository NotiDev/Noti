import 'package:flutter/material.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void toggleDone(Note note, bool? value) {
    note.isDone = value ?? false;
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  int get noteCount => _notes.length;
}
