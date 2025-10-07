import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'settings_store.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeMode == ThemeMode.dark,
              onChanged: (val) async {
                final m = val ? ThemeMode.dark : ThemeMode.light;
                ref.read(themeModeProvider.notifier).state = m;
                await SettingsStore.instance.saveThemeMode(m); // persist
              },
            ),
            const SizedBox(height: 24),
            const Text('Font Size', style: TextStyle(fontSize: 18)),
            Slider(
              min: 12,
              max: 32,
              divisions: 20,
              value: fontSize,
              label: fontSize.round().toString(),
              onChanged: (val) {
                ref.read(fontSizeProvider.notifier).state = val;
              },
              onChangeEnd: (val) async {
                await SettingsStore.instance.saveFontSize(val); // persist
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
