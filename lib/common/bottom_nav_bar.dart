import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    switch (location) {
      case '/profile':
        return 1;
      case '/notifications':
        return 2;
      case '/settings':
        return 3;
      default:
        return 0; // Home
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    final List<String> routes = [
      '/home',
      '/profile',
      '/notifications',
      '/settings',
    ];

    final String currentRoute = GoRouterState.of(context).uri.toString();

    if (currentRoute != routes[index]) {
      context.go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = _getSelectedIndex(context);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(
        0xFF054C5E,
      ), // اللون الأزرق الداكن للعنصر المحدد
      unselectedItemColor: Colors.grey, // اللون الرمادي للعناصر غير المحددة
      showSelectedLabels:
          false, // إخفاء النصوص لأن التصميم يعتمد على الأيقونات فقط
      showUnselectedLabels: false,
      items: [
        _buildNavItem(
          icon: Icons.home,
          label: 'Home',
          isSelected: selectedIndex == 0,
        ),
        _buildNavItem(
          icon: Icons.person,
          label: 'Profile',
          isSelected: selectedIndex == 1,
        ),
        _buildNavItem(
          icon: Icons.notifications,
          label: 'Notification',
          isSelected: selectedIndex == 2,
        ),
        _buildNavItem(
          icon: Icons.settings,
          label: 'Setting',
          isSelected: selectedIndex == 3,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 30, // حجم أكبر ليتناسب مع التصميم
      ),
      label: label,
    );
  }
}
