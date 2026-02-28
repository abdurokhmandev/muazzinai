import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final tabs = [
      {'icon': Icons.home_rounded, 'path': '/'},
      {'icon': Icons.menu_book_rounded, 'path': '/courses'},
      {'icon': Icons.videogame_asset_rounded, 'path': '/games'},
      {'icon': Icons.chat_bubble_rounded, 'path': '/chat'},
      {'icon': Icons.emoji_events_rounded, 'path': '/leaderboard'},
      {'icon': Icons.person_rounded, 'path': '/profile'},
    ];

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 20, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isActive = provider.currentIndex == index;

          return GestureDetector(
            onTap: () {
              provider.setIndex(index);
              context.go(tab['path'] as String);
            },
            child: Icon(
              tab['icon'] as IconData,
              size: 30,
              color: isActive ? Colors.orange : Colors.grey[400],
            ),
          );
        }).toList(),
      ),
    );
  }
}
