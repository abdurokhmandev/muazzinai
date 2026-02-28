class WordModel {
  final String id;
  final String arabic;
  final String uzbek;
  final String audioUrl;
  final String exampleArabic;
  final String exampleUzbek;
  final String difficulty;
  final String category;
  final bool isBookmarked;

  WordModel({
    required this.id,
    required this.arabic,
    required this.uzbek,
    this.audioUrl = '',
    this.exampleArabic = '',
    this.exampleUzbek = '',
    required this.difficulty,
    required this.category,
    this.isBookmarked = false,
  });

  WordModel copyWith({bool? isBookmarked}) {
    return WordModel(
      id: id,
      arabic: arabic,
      uzbek: uzbek,
      audioUrl: audioUrl,
      exampleArabic: exampleArabic,
      exampleUzbek: exampleUzbek,
      difficulty: difficulty,
      category: category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
