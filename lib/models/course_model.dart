import 'lesson_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String level;
  final String thumbnailUrl;
  final List<LessonModel> lessons;
  final int totalLessons;
  final int completedLessons;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.level = 'A1',
    this.thumbnailUrl = '',
    required this.lessons,
    required this.totalLessons,
    this.completedLessons = 0,
  });

  double get progress =>
      totalLessons > 0 ? completedLessons / totalLessons : 0.0;
}
