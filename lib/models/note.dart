class Note {
  final String title;
  final String content;
  final String category;
  final DateTime deadline;
  bool isDone;

  Note({
    required this.title,
    required this.content,
    required this.category,
    required this.deadline,
    this.isDone = false,
  });
}
