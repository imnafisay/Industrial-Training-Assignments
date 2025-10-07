import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/home_page.dart';
import 'pages/story_list_page.dart';
import 'pages/story_detail_page.dart';

final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => HomePage(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'top',
          builder: (context, state) =>
              const StoryListPage(category: 'topstories'),
        ),
        GoRoute(
          path: '/best',
          name: 'best',
          builder: (context, state) =>
              const StoryListPage(category: 'beststories'),
        ),
        GoRoute(
          path: '/new',
          name: 'new',
          builder: (context, state) =>
              const StoryListPage(category: 'newstories'),
        ),
      ],
    ),
    GoRoute(
      path: '/story/:id',
      name: 'storyDetail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return StoryDetailPage(id: id);
      },
    ),
  ],
);
