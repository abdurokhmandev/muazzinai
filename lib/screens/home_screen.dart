import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_provider.dart';
import '../config/theme/colors.dart';
import '../widgets/glass_container.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appProvider).user;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.darkGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(user),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => context.push('/course'),
                  child: _buildCourseProgress(),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => context.push('/videos'),
                  child: _buildHeroBanner(),
                ),
                const SizedBox(height: 24),
                _buildGridCards(context),
                const SizedBox(height: 24),
                _buildStoryBanner(context),
                const SizedBox(height: 24),
                _buildSpeakingMockRow(context),
                const SizedBox(height: 24),
                _buildPromoBanner(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GlassContainer(
              borderRadius: 50,
              padding: const EdgeInsets.all(4),
              opacity: 0.15,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user.profileEmoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
              size: 28,
            ),
          ],
        ),
        GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          opacity: 0.1,
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                '${user.streak}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (user.isPro) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC084FC), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Super Arab tili',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        GlassContainer(
          borderRadius: 16,
          padding: const EdgeInsets.all(2),
          opacity: 0.05,
          child: Stack(
            children: [
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 10,
                width: 120, // Example progress
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.primaryBlue],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return GlassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(24),
      opacity: 0.1,
      gradient: LinearGradient(
        colors: [
          const Color(0xFF8B5CF6).withValues(alpha: 0.3),
          const Color(0xFF3B82F6).withValues(alpha: 0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1-bo'lim • 6 ta dars",
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Unit 1 Session 1',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.primaryGradient),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 12,
          child: GestureDetector(
            onTap: () => context.push('/videos'),
            child: _buildActionCard(
              title: 'Bepul\nkurslar',
              hasAction: true,
              icon: Icons.school_rounded,
              hasRotatedBox: true,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 8,
          child: GestureDetector(
            onTap: () => context.push('/vocabulary'),
            child: _buildActionCard(
              title: "Lug'at",
              icon: Icons.format_list_bulleted_rounded,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    bool hasAction = false,
    required IconData icon,
    bool hasRotatedBox = false,
  }) {
    return GlassContainer(
      borderRadius: 32,
      opacity: 0.08,
      child: Stack(
        children: [
          if (hasRotatedBox)
            Positioned(
              bottom: -20,
              right: -20,
              child: Transform.rotate(
                angle: -0.2,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryPurple.withValues(alpha: 0.2),
                        AppColors.primaryBlue.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: hasRotatedBox
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: hasRotatedBox
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryPurple,
                    size: hasRotatedBox ? 28 : 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: hasRotatedBox ? TextAlign.start : TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                if (hasAction) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Text(
                        "Ko'rish",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakingMockRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/speaking'),
            child: _buildSmallCard(
              title: 'Speaking Club',
              icon: Icons.graphic_eq_rounded,
              badge: 'YANGI',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/exam'),
            child: _buildSmallCard(
              title: 'Mock Exam',
              icon: Icons.assignment_outlined,
              hasDecoration: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallCard({
    required String title,
    required IconData icon,
    String? badge,
    bool hasDecoration = false,
  }) {
    return GlassContainer(
      borderRadius: 32,
      opacity: 0.08,
      child: Stack(
        children: [
          if (hasDecoration)
            Positioned(
              right: -40,
              bottom: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.05),
                    width: 25,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: AppColors.accentCyan, size: 36),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: AppColors.accentCyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/premium'),
      child: GlassContainer(
        borderRadius: 32,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        opacity: 0.1,
        gradient: LinearGradient(
          colors: [
            const Color(0xFFC084FC).withValues(alpha: 0.4),
            const Color(0xFF8B5CF6).withValues(alpha: 0.4),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Muazzin Pro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Barcha premium funksiyalar bitta\nobunada',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/story'),
      child: GlassContainer(
        borderRadius: 32,
        padding: const EdgeInsets.all(24),
        opacity: 0.1,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: AppColors.primaryPurple,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hikoyalar',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Arab tilida qiziqarli hikoyalar',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
