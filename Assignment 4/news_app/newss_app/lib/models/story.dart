class Story {
  final int id;
  final String title;
  final String by;
  final int descendants; // comments count
  final String url;

  Story({
    required this.id,
    required this.title,
    required this.by,
    required this.descendants,
    required this.url,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'] ?? 'No title',
      by: json['by'] ?? 'Unknown',
      descendants: json['descendants'] ?? 0,
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'by': by,
        'descendants': descendants,
        'url': url,
      };

  factory Story.fromMap(Map<String, dynamic> map) => Story.fromJson(map);
}
