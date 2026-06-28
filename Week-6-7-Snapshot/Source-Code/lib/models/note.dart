class Note {
  final int? id;
  final String title;
  final String content;
  final String createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt,
      };

  factory Note.fromMap(Map<String, dynamic> m) => Note(
        id: m['id'] as int,
        title: m['title'] as String,
        content: m['content'] as String,
        createdAt: m['createdAt'] as String,
      );
}
