import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  final String title;
  final String content;
  final bool isDone;
  final ValueChanged<bool?> onToggleDone;
  final VoidCallback onDelete;

  const NoteItem({
    super.key,
    required this.title,
    required this.content,
    required this.isDone,
    required this.onToggleDone,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: onToggleDone,
          activeColor: Colors.green,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            decoration:
            isDone ? TextDecoration.lineThrough : TextDecoration.none,
            color: isDone ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: isDone ? Colors.grey : Colors.black54,
            decoration:
            isDone ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
