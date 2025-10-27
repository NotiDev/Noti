import 'package:flutter/material.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteCount = Provider.of<NotesProvider>(context).noteCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Center(
        child: Text(
          'Total Notes: $noteCount',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
