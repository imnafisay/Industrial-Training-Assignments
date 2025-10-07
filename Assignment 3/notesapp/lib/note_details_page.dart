import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'notes_provider.dart';

class NoteDetailsPage extends ConsumerWidget {
  final String noteId;
  const NoteDetailsPage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(notesProvider).firstWhere(
      (n) => n.id == noteId,
      orElse: () => Note(id: noteId, title: '(Not found)', body: '', updatedAt: DateTime.now()),
    );

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // ✅ Updated AppBar
      appBar: AppBar(
        title: const Text('Note Details'), // changed from note.title → cleaner
        centerTitle: false,
      ),

      // ✅ Keep FABs only at bottom right
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'edit_$noteId',
            onPressed: () async => context.push('/note/$noteId/edit'),
            label: const Text('Edit'),
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'delete_$noteId',
            backgroundColor: cs.errorContainer,
            foregroundColor: cs.onErrorContainer,
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete note?'),
                  content: const Text('This cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (ok == true) {
                await ref.read(notesProvider.notifier).deleteNote(noteId);
                if (context.mounted) context.pop();
              }
            },
            label: const Text('Delete'),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),

      // ✅ Refined body layout (no duplicate title)
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Single title here — looks cleaner
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.schedule_outlined, size: 16, color: cs.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          'Updated ${_friendly(note.updatedAt)}',
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      note.body,
                      style: const TextStyle(height: 1.4, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _friendly(DateTime dt) {
    final now = DateTime.now();
    final d = now.difference(dt);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    if (d.inDays == 1) return 'yesterday';
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }
}
