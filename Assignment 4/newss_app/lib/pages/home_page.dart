import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final tabs = ['/', '/best', '/new'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
          context.go(tabs[index]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.star), label: 'Top'),
          NavigationDestination(icon: Icon(Icons.thumb_up), label: 'Best'),
          NavigationDestination(icon: Icon(Icons.fiber_new), label: 'New'),
        ],
      ),
    );
  }
}
