import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
final fontSizeProvider  = StateProvider<double>((ref) => 16);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize  = ref.watch(fontSizeProvider);
    final scale = fontSize / 16.0;

    ThemeData _buildTheme(Brightness brightness) {
      final baseScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF7C4DFF),
        brightness: brightness,
      );

      return ThemeData(
        useMaterial3: true,
        colorScheme: baseScheme,
        scaffoldBackgroundColor:
            brightness == Brightness.light ? const Color(0xFFF8F9FB) : const Color(0xFF0F1013),
        cardTheme: CardThemeData(
          elevation: 0,
          color: brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF16181C),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),

        // ✅ Fix: dynamic AppBarTheme
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: baseScheme.surface,
          foregroundColor: baseScheme.onSurface, // <-- adapts text & icon color
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: baseScheme.onSurface,
          ),
          iconTheme: IconThemeData(color: baseScheme.onSurface),
        ),

        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Notes App',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        child: child!,
      ),
    );
  }
}
