class Note {
  final String title;
  final String content;
  bool isDone;

  Note({
    required this.title,
    required this.content,
    this.isDone = false,
  });
}
