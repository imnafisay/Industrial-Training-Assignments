import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  
  final _notesStore = intMapStoreFactory.store('notes');
  final _settingsStore = StoreRef<String, dynamic>.main();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final dbPath = join(appDir.path, 'notes_app.db');
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  // NOTES CRUD
  
  Future<int> saveNote(Map<String, dynamic> note) async {
    final db = await database;
    return await _notesStore.add(db, note);
  }

  Future<void> updateNote(int id, Map<String, dynamic> note) async {
    final db = await database;
    await _notesStore.record(id).update(db, note);
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await _notesStore.record(id).delete(db);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    final snapshots = await _notesStore.find(db);
    return snapshots.map((snapshot) {
      final map = Map<String, dynamic>.from(snapshot.value);
      map['id'] = snapshot.key;
      return map;
    }).toList();
  }

  Future<Map<String, dynamic>?> getNoteById(int id) async {
    final db = await database;
    final snapshot = await _notesStore.record(id).get(db);
    if (snapshot != null) {
      final map = Map<String, dynamic>.from(snapshot);
      map['id'] = id;
      return map;
    }
    return null;
  }

  // SETTINGS
  
  Future<void> saveThemeMode(String mode) async {
    final db = await database;
    await _settingsStore.record('themeMode').put(db, mode);
  }

  Future<String?> getThemeMode() async {
    final db = await database;
    return await _settingsStore.record('themeMode').get(db) as String?;
  }

  Future<void> saveFontSize(double size) async {
    final db = await database;
    await _settingsStore.record('fontSize').put(db, size);
  }

  Future<double?> getFontSize() async {
    final db = await database;
    return await _settingsStore.record('fontSize').get(db) as double?;
  }

  // STATS
  
  Future<int> getNotesCount() async {
    final notes = await getAllNotes();
    return notes.length;
  }

  Future<DateTime?> getLastUpdated() async {
    final notes = await getAllNotes();
    if (notes.isEmpty) return null;
    
    DateTime? latest;
    for (final note in notes) {
      final updatedAt = DateTime.parse(note['updatedAt'] as String);
      if (latest == null || updatedAt.isAfter(latest)) {
        latest = updatedAt;
      }
    }
    return latest;
  }
}

final databaseService = DatabaseService();