import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';
import '../config/theme/colors.dart';
import '../widgets/glass_container.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appProvider).user;

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
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfoHeader(context, ref, user),
                      const SizedBox(height: 32),
                      _buildCertificateCTA(),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Yutuqlar'),
                      const SizedBox(height: 16),
                      _buildAchievements(),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Faollik'),
                      const SizedBox(height: 16),
                      _buildActivityCard(),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Kurslarim'),
                      const SizedBox(height: 16),
                      _buildMyCourses(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profil',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          GlassContainer(
            borderRadius: 14,
            padding: const EdgeInsets.all(8),
            opacity: 0.1,
            child: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoHeader(BuildContext context, WidgetRef ref, user) {
    return GlassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(24),
      opacity: 0.1,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showEmojiPicker(context, ref),
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6EE7B7), Color(0xFF10B981)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      user.profileEmoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GlassContainer(
                    borderRadius: 50,
                    padding: const EdgeInsets.all(6),
                    opacity: 0.3,
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showNameEditor(context, ref, user.name),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.edit_note_rounded,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Qo\'shilgan: Avgust 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEmojiPicker(BuildContext context, WidgetRef ref) {
    final emojis = ['🇸🇦', '🧕', '👳', '🕌', '📖', '🌟', '🐪', '🌴', '⚔️', '🌙'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 32,
        padding: const EdgeInsets.all(32),
        opacity: 0.2,
        gradient: const LinearGradient(
          colors: AppColors.darkGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil rasmini tanlang',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: emojis
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        ref.read(appProvider).updateUser(profileEmoji: e);
                        Navigator.pop(context);
                      },
                      child: GlassContainer(
                        borderRadius: 16,
                        opacity: 0.1,
                        padding: const EdgeInsets.all(12),
                        child: Text(e, style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showNameEditor(BuildContext context, WidgetRef ref, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Ismni tahrirlash', style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Ismingizni kiriting',
            hintStyle: const TextStyle(color: AppColors.textMuted),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(appProvider).updateUser(name: controller.text);
              Navigator.pop(context);
            },
            child: const Text('Saqlash'),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCTA() {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(2),
      opacity: 0.1,
      gradient: LinearGradient(
        colors: [
          Color(0xFFFBBF24).withValues(alpha: 0.3),
          Color(0xFFF59E0B).withValues(alpha: 0.3),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Text(
          '2+6 SERTIFIKATINI OLISH',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Barchasi',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {'label': 'So\'z jangchisi', 'icon': Icons.shield_rounded, 'color': Colors.blue},
      {'label': 'Vunderkind', 'icon': Icons.school_rounded, 'color': Colors.amber},
      {'label': 'Marafonchi', 'icon': Icons.directions_run_rounded, 'color': Colors.orange},
      {'label': 'Tezkor o\'quvchi', 'icon': Icons.bolt_rounded, 'color': Colors.purple},
    ];

    return SizedBox(
      height: 125,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: achievements.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final color = achievements[index]['color'] as Color;
          return Column(
            children: [
              GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                opacity: 0.08,
                child: Icon(
                  achievements[index]['icon'] as IconData,
                  color: color.withValues(alpha: 0.8),
                  size: 36,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                achievements[index]['label'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivityCard() {
    return GlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(20),
      opacity: 0.08,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5277).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_filled_rounded,
              color: Color(0xFFFF5277),
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarflangan',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  '12 daqiqa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          GlassContainer(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            opacity: 0.1,
            child: Row(
              children: const [
                Text(
                  'Haftalik',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyCourses() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return GlassContainer(
            borderRadius: 24,
            opacity: 0.08,
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: index == 0
                    ? const Text('🇸🇦', style: TextStyle(fontSize: 24))
                    : Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.amber.withValues(alpha: 0.6),
                        size: 28,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
