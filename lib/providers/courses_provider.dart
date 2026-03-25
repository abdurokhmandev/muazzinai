import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';

// Mock data provider
final coursesProvider =
    StateNotifierProvider<CoursesNotifier, AsyncValue<List<CourseModel>>>((
      ref,
    ) {
      return CoursesNotifier();
    });

class CoursesNotifier extends StateNotifier<AsyncValue<List<CourseModel>>> {
  CoursesNotifier() : super(const AsyncValue.loading()) {
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final mockLessons = [
      LessonModel(
        id: 'l1',
        title: 'Alifbo - 1-dars (A, B, T harflari)',
        description:
            'Arab alifbosi bilan tanishishni boshlaymiz. Ushbu darsda 3 ta harfni o\'rganamiz.',
        youtubeVideoId: '7UhChJPJZ9HnE97n', // Random Arabic alphabet video ID
        transcript:
            'Arab alifbosida jami 28 ta harf mavjud. Bugun biz Alif (A), Ba (B), va Ta (T) harflarini ko\'rib chiqamiz...',
        unitName: 'Unit 1: Alifbo',
      ),
      LessonModel(
        id: 'l2',
        title: 'Alifbo - 2-dars',
        description: 'Harflarni o\'rganishda davom etamiz.',
        youtubeVideoId: 'Og5anIb_FUBgv7qx',
        transcript:
            'Oldingi darsda o\'tilganlarni takrorlab, navbatdagi harflarga o\'tamiz...',
        unitName: 'Unit 1: Alifbo',
      ),
    ];

    final mockCourse = CourseModel(
      id: 'c1',
      title: 'Super Arab tili - A1',
      description:
          'Noldan boshlab arab tilida o\'qish va yozishni o\'rganamiz.',
      lessons: mockLessons,
      totalLessons: mockLessons.length,
    );

    state = AsyncValue.data([mockCourse]);
  }

  void markLessonComplete(String courseId, String lessonId) {
    state.whenData((courses) {
      final updatedCourses = courses.map((course) {
        if (course.id == courseId) {
          final updatedLessons = course.lessons.map((lesson) {
            if (lesson.id == lessonId && !lesson.isCompleted) {
              return lesson.copyWith(isCompleted: true);
            }
            return lesson;
          }).toList();

          final completedCount = updatedLessons
              .where((l) => l.isCompleted)
              .length;

          return CourseModel(
            id: course.id,
            title: course.title,
            description: course.description,
            level: course.level,
            thumbnailUrl: course.thumbnailUrl,
            lessons: updatedLessons,
            totalLessons: updatedLessons.length,
            completedLessons: completedCount,
          );
        }
        return course;
      }).toList();

      state = AsyncValue.data(updatedCourses);
    });
  }
}
