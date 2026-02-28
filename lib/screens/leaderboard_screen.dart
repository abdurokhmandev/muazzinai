import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Leaderboard Data
    final List<Map<String, dynamic>> leaders = [
      {'name': 'Alisher', 'score': 1250, 'level': 'B1', 'streak': 45},
      {'name': 'Dilnoza', 'score': 1120, 'level': 'A2', 'streak': 30},
      {'name': 'Rustam', 'score': 980, 'level': 'A2', 'streak': 12},
      {
        'name': 'Abdurahmon (Siz)',
        'score': 850,
        'level': 'A1',
        'streak': 5,
        'isMe': true,
      },
      {'name': 'Zarina', 'score': 740, 'level': 'A1', 'streak': 2},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reyting'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTab('Shu hafta', true),
                const SizedBox(width: 16),
                _buildTab('Umumiy', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: leaders.length,
              separatorBuilder: (c, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = leaders[index];
                final isMe = user['isMe'] == true;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.yellowGold.withValues(alpha: 0.1)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: isMe
                        ? Border.all(color: AppColors.yellowGold)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildRankBadge(index + 1),
                      const SizedBox(width: 16),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryPurple.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          user['name'][0],
                          style: const TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isMe
                                    ? AppColors.yellowGold
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${user['level']} daraja',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.local_fire_department_rounded,
                                  color: Colors.orange,
                                  size: 14,
                                ),
                                Text(
                                  '${user['streak']}',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${user['score']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          const Text(
                            'XP',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryPurple : AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color color;
    if (rank == 1) {
      color = AppColors.yellowGold;
    } else if (rank == 2) {
      color = Colors.grey.shade400;
    } else if (rank == 3) {
      color = Colors.brown.shade300;
    } else {
      color = Colors.transparent;
    }

    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.2),
      ),
      child: Text(
        '$rank',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: rank <= 3 ? color : AppColors.textSecondary,
        ),
      ),
    );
  }
}
