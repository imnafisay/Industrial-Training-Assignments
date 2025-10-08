import 'package:sembast/sembast.dart';
import '../db/sembast_db.dart';
import '../models/story.dart';
import '../services/hacker_news_api.dart';

class StoriesRepository {
  StoriesRepository(this._api);
  final HackerNewsApi _api;

  // Store keyed by story id
  final _store = intMapStoreFactory.store('stories');

  // ---------- FIXED: save list using a transaction ----------
  Future<void> _saveStories(List<Story> stories) async {
    final db = await AppDatabase.instance.database;
    await db.transaction((txn) async {
      for (final s in stories) {
        await _store.record(s.id).put(txn, s.toMap());
      }
    });
  }

  // (Alternative bulk form, also OK)
  // Future<void> _saveStories(List<Story> stories) async {
  //   final db = await AppDatabase.instance.database;
  //   final keys = stories.map((s) => s.id).toList();
  //   final values = stories.map((s) => s.toMap()).toList();
  //   await _store.records(keys).put(db, values);
  // }

  Future<Story?> _getStoryFromCache(int id) async {
    final db = await AppDatabase.instance.database;
    final map = await _store.record(id).get(db);
    if (map == null) return null;
    return Story.fromMap(map);
  }

  Future<List<Story>> _getRecentFromCache(int limit) async {
    final db = await AppDatabase.instance.database;
    // Sort by 'id' field inside the stored map; descending
    final finder = Finder(
      sortOrders: [SortOrder('id', false)],
      limit: limit,
    );
    final records = await _store.find(db, finder: finder);
    return records.map((r) => Story.fromMap(r.value)).toList();
  }

  Future<List<Story>> fetchStories(String category, {int limit = 20}) async {
    try {
      final stories = await _api.fetchStories(category, limit: limit);
      await _saveStories(stories);
      return stories;
    } catch (_) {
      final cached = await _getRecentFromCache(limit);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<Story> fetchStory(int id) async {
    final cached = await _getStoryFromCache(id);
    if (cached != null) return cached;
    final s = await _api.fetchStory(id);
    await _saveStories([s]);
    return s;
  }
}
