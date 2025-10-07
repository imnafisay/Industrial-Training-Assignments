import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/hacker_news_api.dart';
import '../repositories/stories_repository.dart';
import '../models/story.dart';

// Providers: API → Repository → Data
final apiProvider = Provider((ref) => HackerNewsApi());
final repoProvider =
    Provider((ref) => StoriesRepository(ref.watch(apiProvider)));

final storiesProvider =
    FutureProvider.family<List<Story>, String>((ref, category) async {
  final repo = ref.watch(repoProvider);
  return repo.fetchStories(category);
});

class StoryListPage extends ConsumerWidget {
  final String category;
  const StoryListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider(category));

    return Scaffold(
      appBar:
          AppBar(title: Text(category.replaceAll('stories', '').toUpperCase())),
      body: storiesAsync.when(
        data: (stories) => ListView.builder(
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final s = stories[index];
            return ListTile(
              title: Text(s.title),
              subtitle: Text('by ${s.by} • ${s.descendants} comments'),
              onTap: () => context.push('/story/${s.id}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
