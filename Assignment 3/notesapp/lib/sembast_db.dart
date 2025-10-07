import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart' as sembast_io;
import 'package:sembast_web/sembast_web.dart' as sembast_web;
import 'package:path_provider/path_provider.dart' as pp;

class AppDB {
  AppDB._();
  static final AppDB instance = AppDB._();

  Database? _db;

  // Stores
  final notesStore = stringMapStoreFactory.store('notes');      // key: noteId
  final metaStore  = StoreRef<String, Object?>('meta');         // 'notesCount', 'notesLastUpdated'
  final settingsStore = StoreRef<String, Object?>('settings');  // 'themeMode', 'fontSize'

  Future<Database> get database async {
    if (_db != null) return _db!;

    if (kIsWeb) {
      // Web: use indexedDB via sembast_web. No filesystem/path.
      final factory = sembast_web.databaseFactoryWeb;
      _db = await factory.openDatabase('notes_app.db');
      return _db!;
    } else {
      // Mobile/Desktop: use sembast_io with a file path.
      final dir = await pp.getApplicationDocumentsDirectory();
      final dbPath = '${dir.path}/notes_app.db';
      final factory = sembast_io.databaseFactoryIo;
      _db = await factory.openDatabase(dbPath);
      return _db!;
    }
  }
}
