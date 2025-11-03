import 'package:flutter/material.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteCount = Provider.of<NotesProvider>(context).noteCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
      ),
      body: Center(
        child: Text(
          'Всего заметок: $noteCount',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
