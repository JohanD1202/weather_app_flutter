import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavWrapper extends StatelessWidget {
  final GoRouterState state;

  const BottomNavWrapper({
    super.key, 
    required this.state
  });

  int _getCurrentIndex() {
    final location = state.uri.toString();

    if(location == '/favorites') return 0;
    if(location == '/') return 1;
    if(location == '/saved') return 2;

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return _WeatherBottomNavigationBar(
      currentIndex: _getCurrentIndex(),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/favorites');
            break;
          case 1:
            context.go('/');
            break;

          case 2:
            context.go('/saved');
            break;
        }
      },
    );
  }
}


class _WeatherBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const _WeatherBottomNavigationBar({
    required this.currentIndex,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Theme.of(context).colorScheme.surface,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
        showUnselectedLabels: true,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.star),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.listPlus),
            label: '',
          ),
        ],
      ),
    );
  }
}
