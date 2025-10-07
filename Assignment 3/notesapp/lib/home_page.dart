import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'notes_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.note_alt_outlined, size: 22),
            SizedBox(width: 8),
            Text('My Notes'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Add note',
            onPressed: () => context.go('/add'),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add'),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: ListView(
          children: [
            // ----- SECTION 1: notes or empty state -----
            if (notes.isEmpty)
              _EmptyState(onAdd: () => context.go('/add'))
            else
              ...List.generate(notes.length, (i) {
                final n = notes[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: i == notes.length - 1 ? 0 : 12),
                  child: _NoteCard(
                    title: n.title,
                    body: n.body,
                    updatedAt: n.updatedAt,
                    onTap: () => context.go('/note/${n.id}'),
                    color: Theme.of(context).cardTheme.color,
                  ),
                );
              }),

            const SizedBox(height: 16),
            const Divider(height: 24, thickness: 0.6),

            // ----- SECTION 2: settings tile (always visible) -----
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.settings),
              title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String title;
  final String body;
  final DateTime updatedAt;
  final VoidCallback onTap;
  final Color? color;

  const _NoteCard({
    required this.title,
    required this.body,
    required this.updatedAt,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: cs.onSurface.withOpacity(0.6),
        );

    return Card(
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(body, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _Chip(text: 'Updated ${_friendly(updatedAt)}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: cs.onSurface.withOpacity(0.6)),
              const SizedBox(width: 6),
            ],
          ),
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

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: TextStyle(color: cs.primary, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
        child: Column(
          children: [
            Icon(Icons.edit_note, size: 72, color: cs.primary),
            const SizedBox(height: 16),
            Text('No notes yet',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Create your first note to get started.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.7))),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: onAdd,
              child: const Text('Add a note'),
            ),
          ],
        ),
      ),
    );
  }
}
