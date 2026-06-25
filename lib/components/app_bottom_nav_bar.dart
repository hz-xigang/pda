import 'package:flutter/material.dart';
import 'package:hz_xg_pda/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 64,
      selectedIndex: currentIndex,
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        if (index == currentIndex) {
          return;
        }

        final targetRoute = index == 0 ? AppRoutes.home : AppRoutes.mine;
        Navigator.pushReplacementNamed(context, targetRoute);
      },
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF2E61F3)),
          icon: Icon(Icons.home_rounded, color: Color(0xFF7B8494)),
          label: '首页',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF6A48E7)),
          icon: Icon(Icons.person_rounded, color: Color(0xFF7B8494)),
          label: '我的',
        ),
      ],
    );
  }
}
