import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme/colors.dart';
import '../widgets/learning_path_widget.dart';
import '../widgets/glass_container.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      _buildBanner(),
                      const SizedBox(height: 24),
                      _buildAlifboButton(),
                      const SizedBox(height: 48),
                      Text(
                        'Unit 1 Session 1'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const LearningPathWidget(),
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
                'Super Arab tili',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          GlassContainer(
            borderRadius: 14,
            padding: const EdgeInsets.all(8),
            opacity: 0.1,
            child: const Icon(Icons.stars_rounded, color: AppColors.accentCyan, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return GlassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(28),
      opacity: 0.1,
      gradient: LinearGradient(
        colors: [
          AppColors.tealCyan.withValues(alpha: 0.3),
          AppColors.primaryBlue.withValues(alpha: 0.1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1-BO\'LIM • 6 TA DARS',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Unit 1 Session 1',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlifboButton() {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(2),
      opacity: 0.1,
      gradient: LinearGradient(
        colors: [
          const Color(0xFFFBBF24).withValues(alpha: 0.3),
          const Color(0xFFF59E0B).withValues(alpha: 0.3),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.font_download_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            const Text(
              'Alifbo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
