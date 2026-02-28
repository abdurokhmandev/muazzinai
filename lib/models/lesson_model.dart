class LessonModel {
  final String id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final String transcript;
  final bool isCompleted;
  final String unitName;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeVideoId,
    this.transcript = '',
    this.isCompleted = false,
    required this.unitName,
  });

  LessonModel copyWith({bool? isCompleted}) {
    return LessonModel(
      id: id,
      title: title,
      description: description,
      youtubeVideoId: youtubeVideoId,
      transcript: transcript,
      isCompleted: isCompleted ?? this.isCompleted,
      unitName: unitName,
    );
  }
}
