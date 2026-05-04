import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', path: RouteNames.dashboard),
    _TabItem(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Discover', path: RouteNames.matching),
    _TabItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'Connects', path: RouteNames.connections),
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
    final colors = context.colors;

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.bookings),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.card,
          border: Border(
            top: BorderSide(color: colors.border.withValues(alpha: 0.3)),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, 0, currentIndex, colors),
                _buildNavItem(context, 1, currentIndex, colors),
                const SizedBox(width: 56),
                _buildNavItem(context, 2, currentIndex, colors),
                _buildNavItem(context, 3, currentIndex, colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, int currentIndex, AppColorsExtension colors) {
    final tab = _tabs[index];
    final isSelected = index == currentIndex;
    final color = isSelected ? colors.primary : colors.mutedForeground;

    return Expanded(
      child: InkWell(
        onTap: () => context.go(tab.path),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? tab.activeIcon : tab.icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
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
