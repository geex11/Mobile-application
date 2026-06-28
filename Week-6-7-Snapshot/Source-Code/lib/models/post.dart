class Post {
  final int id;
  final String title;
  final String description;
  final String authorName;
  final String publishedAt;
  final List<String> tags;
  final int readingTime;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    required this.publishedAt,
    required this.tags,
    required this.readingTime,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int? ?? 0,
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        authorName:
            (json['user'] as Map<String, dynamic>?)?['name']?.toString() ??
                'Unknown',
        publishedAt: json['readable_publish_date']?.toString() ?? '',
        tags: (json['tag_list'] as List<dynamic>?)
                ?.map((t) => t?.toString() ?? '')
                .where((t) => t.isNotEmpty)
                .toList() ??
            [],
        readingTime: json['reading_time_minutes'] as int? ?? 1,
      );
}
