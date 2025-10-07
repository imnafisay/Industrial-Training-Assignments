import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'sembast_db.dart';

class Note {
  final String id;
  final String title;
  final String body;
  final DateTime updatedAt;
  Note({required this.id, required this.title, required this.body, required this.updatedAt});

  Note copyWith({String? title, String? body, DateTime? updatedAt}) =>
      Note(id: id, title: title ?? this.title, body: body ?? this.body, updatedAt: updatedAt ?? this.updatedAt);

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'updatedAt': updatedAt.toIso8601String(),
  };

  static Note fromMap(Map<String, dynamic> m) => Note(
    id: m['id'] as String,
    title: m['title'] as String,
    body: m['body'] as String,
    updatedAt: DateTime.parse(m['updatedAt'] as String),
  );
}

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]) {
    _init();
  }

  Database? _db;
  final _dbHelper = AppDB.instance;

  Future<void> _init() async {
    _db = await _dbHelper.database;
    final records = await _dbHelper.notesStore.find(_db!,
        finder: Finder(sortOrders: [SortOrder('updatedAt', false)]));
    final loaded = records.map((r) => Note.fromMap(r.value)).toList();
    state = loaded;
    await _updateMeta(); // ensure meta exists
  }

  Future<void> addNote(String title, String body) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final note = Note(id: id, title: title, body: body, updatedAt: DateTime.now());
    state = [...state, note];
    await _dbHelper.notesStore.record(id).put(_db!, note.toMap());
    await _updateMeta();
  }

  Future<void> updateNote(String id, String title, String body) async {
    final idx = state.indexWhere((n) => n.id == id);
    if (idx == -1) return;
    final updated = state[idx].copyWith(title: title, body: body, updatedAt: DateTime.now());
    final newList = [...state]..[idx] = updated;
    state = newList;
    await _dbHelper.notesStore.record(id).put(_db!, updated.toMap());
    await _updateMeta();
  }

  Future<void> deleteNote(String id) async {
    state = state.where((n) => n.id != id).toList();
    await _dbHelper.notesStore.record(id).delete(_db!);
    await _updateMeta();
  }

  Note? getById(String id) {
    try {
      return state.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _updateMeta() async {
    final count = state.length;
    final lastUpdated = state.isEmpty
        ? null
        : (state..sort((a, b) => b.updatedAt.compareTo(a.updatedAt))).first.updatedAt.toIso8601String();
    await _dbHelper.metaStore.record('notesCount').put(_db!, count);
    await _dbHelper.metaStore.record('notesLastUpdated').put(_db!, lastUpdated);
  }
}

final notesProvider =
    StateNotifierProvider<NotesNotifier, List<Note>>((ref) => NotesNotifier());
