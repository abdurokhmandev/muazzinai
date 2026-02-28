import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme/colors.dart';

class CustomBottomNav extends StatelessWidget {
  final Widget child;

  const CustomBottomNav({required this.child, super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/videos')) return 1;
    if (location.startsWith('/vocabulary')) return 2;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/leaderboard')) return 4;
    if (location.startsWith('/profile')) return 5;
    return 0; // default home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/videos');
        break;
      case 2:
        context.go('/vocabulary');
        break;
      case 3:
        context.go('/chat');
        break;
      case 4:
        context.go('/leaderboard');
        break;
      case 5:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, 0, Icons.home_rounded, 'Home'),
                _buildNavItem(
                  context,
                  1,
                  Icons.play_circle_fill_rounded,
                  'Videos',
                ),
                _buildNavItem(context, 2, Icons.menu_book_rounded, 'Vocab'),
                _buildNavItem(context, 3, Icons.chat_bubble_rounded, 'Chat'),
                _buildNavItem(context, 4, Icons.military_tech_rounded, 'Rank'),
                _buildNavItem(context, 5, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = _calculateSelectedIndex(context) == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.yellowGold : Colors.grey.shade400,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.yellowGold : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
