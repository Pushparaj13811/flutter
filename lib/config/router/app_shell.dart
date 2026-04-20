import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', path: RouteNames.dashboard),
    _TabItem(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Discover', path: RouteNames.matching),
    _TabItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'Connects', path: RouteNames.connections),
    _TabItem(icon: Icons.groups_outlined, activeIcon: Icons.groups, label: 'Community', path: RouteNames.community),
    _TabItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', path: RouteNames.profile),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.go(_tabs[index].path);
        },
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.activeIcon),
                label: tab.label,
                tooltip: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
  });
}
