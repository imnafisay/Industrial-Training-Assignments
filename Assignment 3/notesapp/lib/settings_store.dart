import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'sembast_db.dart';

class SettingsStore {
  SettingsStore._();
  static final SettingsStore instance = SettingsStore._();
  Database? _db;

  Future<void> init() async {
    _db = await AppDB.instance.database; // make sure DB ready on all platforms
  }

  Future<ThemeMode> loadThemeMode() async {
    final v = await AppDB.instance.settingsStore.record('themeMode').get(_db!);
    switch (v) {
      case 'dark': return ThemeMode.dark;
      case 'light': return ThemeMode.light;
      case 'system': return ThemeMode.system;
      default: return ThemeMode.light;
    }
  }

  Future<void> saveThemeMode(ThemeMode m) async {
    final s = switch (m) { ThemeMode.dark => 'dark', ThemeMode.light => 'light', _ => 'system' };
    await AppDB.instance.settingsStore.record('themeMode').put(_db!, s);
  }

  Future<double> loadFontSize() async {
    final v = await AppDB.instance.settingsStore.record('fontSize').get(_db!);
    if (v is num) return v.toDouble();
    return 16.0;
  }

  Future<void> saveFontSize(double size) async {
    await AppDB.instance.settingsStore.record('fontSize').put(_db!, size);
  }
}
