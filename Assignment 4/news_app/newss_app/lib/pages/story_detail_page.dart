import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter_html/flutter_html.dart';
import '../repositories/stories_repository.dart';
import '../models/story.dart';
import '../models/comment.dart';
import '../services/hacker_news_api.dart';
import 'story_list_page.dart' show repoProvider;

final storyDetailProvider =
    FutureProvider.family<Story, int>((ref, id) async {
  final repo = ref.watch(repoProvider);
  return repo.fetchStory(id);
});

// NEW: provider to fetch comments
final commentsProvider =
    FutureProvider.family<List<Comment>, int>((ref, storyId) async {
  final api = HackerNewsApi();
  return api.fetchCommentsForStory(storyId, depth: 2, topLevelLimit: 30);
});

class StoryDetailPage extends ConsumerWidget {
  final int id;
  const StoryDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyDetailProvider(id));
    final commentsAsync = ref.watch(commentsProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Story Details')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // -------- Story header --------
            storyAsync.when(
              data: (story) => _StoryHeader(story: story),
              loading: () => const Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              )),
              error: (e, _) => Text('Error loading story: $e'),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // -------- Comments header --------
            Row(
              children: [
                Text('Comments', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 8),
                commentsAsync.maybeWhen(
                  data: (list) => Text('(${list.length})', style: Theme.of(context).textTheme.labelMedium),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // -------- Comments list --------
            commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Text('No comments yet.');
                }
                return Column(
                  children: comments
                      .map((c) => _CommentTile(comment: c, depth: 0))
                      .toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error loading comments: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  const _StoryHeader({required this.story});
  final Story story;

  @override
  Widget build(BuildContext context) {
    final String targetUrl = (story.url.isNotEmpty)
        ? story.url
        : 'https://news.ycombinator.com/item?id=${story.id}';
    final uri = Uri.parse(targetUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(story.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('by ${story.by} • ${story.descendants} comments'),
        const SizedBox(height: 16),
        Link(
          uri: uri,
          target: LinkTarget.blank,
          builder: (context, followLink) => InkWell(
            onTap: followLink,
            child: Text(
              targetUrl,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Link(
          uri: uri,
          target: LinkTarget.blank,
          builder: (context, followLink) => FilledButton(
            onPressed: followLink,
            child: Text(
              story.url.isNotEmpty ? 'Open article' : 'Open on Hacker News',
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- Comment UI ----------

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, required this.depth});
  final Comment comment;
  final int depth;

  @override
  Widget build(BuildContext context) {
    if (!comment.isVisible) return const SizedBox.shrink();

    final indent = (depth * 12.0).clamp(0.0, 48.0);

    return Container(
      margin: EdgeInsets.only(left: indent, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // author
          Text(
            comment.by,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          // HTML body
          Html(
            data: comment.text,
            style: {
              // keep it readable
              'body': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
              'p': Style(margin: Margins.only(bottom: 6)),
            },
            shrinkWrap: true,
          ),
          // children
          if (comment.kids.isNotEmpty) ...[
            const SizedBox(height: 8),
            Column(
              children: comment.kids
                  .map((k) => _CommentTile(comment: k, depth: depth + 1))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
