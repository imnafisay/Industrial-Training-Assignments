import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    const dbName = 'hacker_news.db';
    if (kIsWeb) {
      final factory = databaseFactoryWeb;
      return factory.openDatabase(dbName);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final path = p.join(dir.path, dbName);
      final factory = databaseFactoryIo;
      return factory.openDatabase(path);
    }
  }
}
