import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'settings_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeMode initialTheme = ThemeMode.light;
  double initialFont = 16;

  try {
    await SettingsStore.instance.init();
    initialTheme = await SettingsStore.instance.loadThemeMode();
    initialFont = await SettingsStore.instance.loadFontSize();
  } catch (e) {
    // If anything goes wrong (e.g., storage not available), still boot with defaults
    // print('Settings init failed: $e');  // optional
  }

  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith((ref) => initialTheme),
        fontSizeProvider.overrideWith((ref) => initialFont),
      ],
      child: const MyApp(),
    ),
  );
}
