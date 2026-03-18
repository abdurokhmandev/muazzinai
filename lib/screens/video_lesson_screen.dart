import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/text_styles.dart';
import '../../providers/courses_provider.dart';

class VideoLessonScreen extends ConsumerWidget {
  const VideoLessonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesState = ref.watch(coursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Video Darslar'), centerTitle: false),
      body: coursesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(child: Text('Hozircha darslar yo\'q'));
          }
          final course = courses.first; // For simplicity, take the first course

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _buildCourseHeader(course.title, course.progress),
              const SizedBox(height: 24),
              ...course.lessons.map(
                (lesson) => _buildLessonCard(context, lesson),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCourseHeader(String title, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h2.copyWith(color: AppColors.white)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Umumiy jarayon',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.yellowGold,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, dynamic lesson) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => context.push('/videos/play/${lesson.id}', extra: lesson),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: lesson.isCompleted
                    ? AppColors.tealCyan.withValues(alpha: 0.1)
                    : AppColors.primaryPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                lesson.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.play_arrow_rounded,
                color: lesson.isCompleted
                    ? AppColors.tealCyan
                    : AppColors.primaryPurple,
              ),
            ),
            title: Text(
              lesson.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                lesson.unitName,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),
        ),
      ),
    );
  }
}
