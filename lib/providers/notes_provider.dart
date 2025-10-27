import 'package:flutter/material.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  int get noteCount => _notes.length;
}
