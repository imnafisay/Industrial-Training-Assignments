class Comment {
  final int id;
  final String by;
  final String text; // HTML string from HN
  final List<Comment> kids; // nested replies
  final bool deleted;
  final bool dead;

  Comment({
    required this.id,
    required this.by,
    required this.text,
    required this.kids,
    required this.deleted,
    required this.dead,
  });

  factory Comment.fromJson(Map<String, dynamic> json, {List<Comment> kids = const []}) {
    return Comment(
      id: json['id'],
      by: (json['by'] ?? 'unknown').toString(),
      text: (json['text'] ?? '').toString(),
      kids: kids,
      deleted: json['deleted'] == true,
      dead: json['dead'] == true,
    );
  }

  bool get isVisible => !deleted && !dead && (text.isNotEmpty || kids.isNotEmpty);
}
