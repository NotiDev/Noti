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
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDone ? Colors.blue.shade100 : Colors.blue.shade50,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
leading: Transform.scale(
  scale: 1.2,
  child: Checkbox(
    value: isDone,
    onChanged: onToggleDone,
    activeColor: Colors.blue, // фон при отмеченном
    checkColor: Colors.white, // цвет галочки
    side: BorderSide(
      color: Colors.blue, // цвет рамки
      width: 1.8,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        // отмеченный
        return Colors.blue;
      } else {
        // неотмеченный — фон прозрачный
        return Colors.transparent;
      }
    }),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
),


        title: Text(
          title,
          style: theme.textTheme.titleMedium!.copyWith(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            content,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: isDone ? Colors.grey : Colors.black54,
              decoration: isDone ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
