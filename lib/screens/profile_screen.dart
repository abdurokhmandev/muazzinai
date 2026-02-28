import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/text_styles.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => const Center(
          child: Text('Foydalanuvchi ma\'lumotlarini yuklashda xatolik'),
        ),
        data: (user) {
          // Fallback UI for visual testing
          final displayName = user?.name ?? 'Abdurahmon';
          final email = user?.email ?? 'user@superarabtili.com';
          final level = user?.languageLevel ?? 'A1';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryPurple.withValues(
                    alpha: 0.1,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 60,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 16),
                Text(displayName, style: AppTextStyles.h2),
                const SizedBox(height: 4),
                Text(email, style: AppTextStyles.body1),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.yellowGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Daraja: $level',
                    style: const TextStyle(
                      color: AppColors.yellowGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      '12',
                      'Darslar',
                      Icons.play_circle_fill_rounded,
                      AppColors.primaryPurple,
                    ),
                    _buildStatItem(
                      '45',
                      'So\'zlar',
                      Icons.menu_book_rounded,
                      AppColors.tealCyan,
                    ),
                    _buildStatItem(
                      '5',
                      'Kunlar',
                      Icons.local_fire_department_rounded,
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildMenuSection(context, ref),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String val, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          val,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sozlamalar', style: AppTextStyles.h3),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildMenuItem(Icons.person_outline_rounded, 'Tahrirlash', () {}),
              const Divider(height: 1),
              _buildMenuItem(
                Icons.workspace_premium_rounded,
                'Ibrat Pro',
                () => context.push('/premium'),
                color: AppColors.yellowGold,
              ),
              const Divider(height: 1),
              _buildMenuItem(
                Icons.notifications_none_rounded,
                'Bildirishnomalar',
                () {},
              ),
              const Divider(height: 1),
              _buildMenuItem(Icons.dark_mode_outlined, 'Tungi rejim', () {}),
              const Divider(height: 1),
              _buildMenuItem(Icons.logout_rounded, 'Chiqish', () async {
                await ref.read(userProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              }, color: Colors.redAccent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = AppColors.textPrimary,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
