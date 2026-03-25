import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';
import '../providers/app_provider.dart';
import '../../widgets/glass_container.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(appProvider).user;
    final List<Map<String, dynamic>> leaders = [
      {'name': 'Alisher', 'score': 1250, 'level': 'B1', 'streak': 45, 'emoji': '👳'},
      {'name': 'Dilnoza', 'score': 1120, 'level': 'A2', 'streak': 30, 'emoji': '🧕'},
      {'name': 'Rustam', 'score': 980, 'level': 'A2', 'streak': 12, 'emoji': '👦'},
      {
        'name': '${me.name} (Siz)',
        'score': me.score,
        'level': 'A${me.level}',
        'streak': me.streak,
        'isMe': true,
        'emoji': me.profileEmoji,
      },
      {'name': 'Zarina', 'score': 740, 'level': 'A1', 'streak': 2, 'emoji': '👧'},
    ];

    leaders.sort((a, b) => b['score'].compareTo(a['score']));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.darkGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildTabs(),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: leaders.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final user = leaders[index];
                    final isMe = user['isMe'] == true;
                    final rank = index + 1;

                    return GlassContainer(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(20),
                      opacity: isMe ? 0.2 : 0.08,
                      gradient: isMe
                          ? const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue])
                          : null,
                      child: Row(
                        children: [
                          _buildRankBadge(rank),
                          const SizedBox(width: 16),
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            child: Center(
                              child: Text(
                                user['emoji'] ?? user['name'][0],
                                style: const TextStyle(fontSize: 28),
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
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                    color: isMe ? Colors.white : AppColors.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '${user['level']} daraja',
                                      style: TextStyle(
                                        color: isMe ? Colors.white.withValues(alpha: 0.7) : AppColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.local_fire_department_rounded, color: Colors.orangeAccent, size: 14),
                                    Text(
                                      '${user['streak']}',
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  color: isMe ? Colors.white : AppColors.tealCyan,
                                ),
                              ),
                              Text(
                                'XP',
                                style: TextStyle(
                                  color: isMe ? Colors.white.withValues(alpha: 0.6) : AppColors.textSecondary.withValues(alpha: 0.5),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
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
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 22),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: 8),
              const Text(
                'Reyting',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: AppColors.textSecondary, size: 26),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassContainer(
        borderRadius: 18,
        padding: const EdgeInsets.all(4),
        opacity: 0.1,
        child: Row(
          children: [
            Expanded(child: _buildTab('Shu hafta', true)),
            Expanded(child: _buildTab('Umumiy', false)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color? color;
    if (rank == 1) color = AppColors.yellowGold;
    if (rank == 2) color = const Color(0xFFC0C0C0);
    if (rank == 3) color = const Color(0xFFCD7F32);

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color?.withValues(alpha: 0.2) ?? Colors.white.withValues(alpha: 0.05),
      ),
      child: Center(
        child: rank <= 3
            ? Icon(Icons.emoji_events_rounded, color: color, size: 16)
            : Text(
                '$rank',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}
