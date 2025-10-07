import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_page.dart';
import 'settings_page.dart';
import 'note_details_page.dart';
import 'add_notepage.dart';
import 'edit_note_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'note/:id',
          builder: (context, state) {
            final noteId = state.pathParameters['id']!;
            return NoteDetailsPage(noteId: noteId);
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final noteId = state.pathParameters['id']!;
                return EditNotePage(noteId: noteId);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddNotePage(),
        ),
      ],
    ),
  ],
);
