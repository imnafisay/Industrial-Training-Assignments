import 'package:dio/dio.dart';
import '../models/story.dart';
import '../models/comment.dart';

class HackerNewsApi {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://hacker-news.firebaseio.com/v0/'));

  Future<List<int>> fetchStoryIds(String category) async {
    final response = await _dio.get('$category.json');
    return List<int>.from(response.data);
  }

  Future<Story> fetchStory(int id) async {
    final response = await _dio.get('item/$id.json');
    return Story.fromJson(response.data);
  }

  Future<List<Story>> fetchStories(String category, {int limit = 20}) async {
    final ids = await fetchStoryIds(category);
    final limitedIds = ids.take(limit).toList();
    final stories = await Future.wait(limitedIds.map(fetchStory));
    return stories;
  }

  // ---------------- Comments support ----------------

  Future<Map<String, dynamic>> _fetchItemRaw(int id) async {
    final resp = await _dio.get('item/$id.json');
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// Fetch a single comment with nested replies up to [depth] levels.
  Future<Comment?> _fetchCommentTree(
    int id, {
    int depth = 2,
    int perNodeKidLimit = 10,
  }) async {
    final json = await _fetchItemRaw(id);
    if (json['type'] != 'comment') return null;

    // Build children first (if any and depth allows)
    List<Comment> kids = const [];
    if (depth > 0 && json['kids'] is List) {
      final kidIds = (json['kids'] as List).cast<int>().take(perNodeKidLimit).toList();
      final futures = kidIds.map(
        (kidId) => _fetchCommentTree(kidId, depth: depth - 1, perNodeKidLimit: perNodeKidLimit),
      );
      final results = await Future.wait(futures);
      kids = results.whereType<Comment>().toList();
    }

    return Comment.fromJson(json, kids: kids);
  }

  /// Fetch top-level comments for a story (with nested replies).
  Future<List<Comment>> fetchCommentsForStory(
    int storyId, {
    int depth = 2,
    int topLevelLimit = 30,
    int perNodeKidLimit = 10,
  }) async {
    final storyRaw = await _fetchItemRaw(storyId);
    final kidIds = (storyRaw['kids'] is List)
        ? (storyRaw['kids'] as List).cast<int>().take(topLevelLimit).toList()
        : <int>[];

    final futures = kidIds.map(
      (id) => _fetchCommentTree(id, depth: depth, perNodeKidLimit: perNodeKidLimit),
    );
    final results = await Future.wait(futures);

    return results.whereType<Comment>().where((c) => c.isVisible).toList();
  }
}
