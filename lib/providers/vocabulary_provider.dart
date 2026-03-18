import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator/translator.dart';
import '../models/word_model.dart';

final vocabularyProvider =
    StateNotifierProvider<VocabularyNotifier, AsyncValue<List<WordModel>>>((
      ref,
    ) {
      return VocabularyNotifier();
    });

class VocabularyNotifier extends StateNotifier<AsyncValue<List<WordModel>>> {
  List<WordModel> _allWords = [];
  final _translator = GoogleTranslator();

  VocabularyNotifier() : super(const AsyncValue.loading()) {
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _allWords = [
      WordModel(
        id: 'w1',
        arabic: 'مَرْحَبًا',
        uzbek: 'Salom',
        difficulty: 'A1',
        category: 'Greetings',
        exampleArabic: 'مَرْحَبًا بِكَ',
        exampleUzbek: 'Sizga salom (Xush kelibsiz)',
      ),
      WordModel(
        id: 'w2',
        arabic: 'شُكْرًا',
        uzbek: 'Rahmat',
        difficulty: 'A1',
        category: 'Greetings',
        exampleArabic: 'شُكْرًا جَزِيلًا',
        exampleUzbek: 'Katta rahmat',
      ),
      WordModel(
        id: 'w3',
        arabic: 'كِتَابٌ',
        uzbek: 'Kitob',
        difficulty: 'A1',
        category: 'Education',
        exampleArabic: 'هٰذَا كِتَابِي',
        exampleUzbek: 'Bu mening kitobim',
      ),
      WordModel(
        id: 'w4',
        arabic: 'مَدْرَسَةٌ',
        uzbek: 'Maktab',
        difficulty: 'A1',
        category: 'Education',
        exampleArabic: 'أَذْهَبُ إِلَى الْمَدْرَسَةِ',
        exampleUzbek: 'Men maktabga borayapman',
      ),
      WordModel(
        id: 'w5',
        arabic: 'سَيَّارَةٌ',
        uzbek: 'Avtomobil',
        difficulty: 'A1',
        category: 'Transport',
        exampleArabic: 'سَيَّارَتِي جَدِيدَةٌ',
        exampleUzbek: 'Mening avtomobilim yangi',
        isBookmarked: true,
      ),
    ];

    state = AsyncValue.data(_allWords);
  }

  void toggleBookmark(String id) {
    state.whenData((words) {
      final updatedWords = words.map((w) {
        if (w.id == id) return w.copyWith(isBookmarked: !w.isBookmarked);
        return w;
      }).toList();
      _allWords = updatedWords;
      state = AsyncValue.data(updatedWords);
    });
  }

  Future<void> filter(String query, String category) async {
    state = const AsyncValue.loading();
    var filtered = _allWords;

    if (category != 'All') {
      filtered = filtered.where((w) => w.category == category).toList();
    }

    if (query.isNotEmpty) {
      final localMatches = filtered
          .where(
            (w) =>
                w.uzbek.toLowerCase().contains(query.toLowerCase()) ||
                w.arabic.contains(query),
          )
          .toList();

      if (localMatches.isNotEmpty) {
        state = AsyncValue.data(localMatches);
      } else {
        // Dynamic translation
        try {
          final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(query);
          String translatedUzbek = '';
          String translatedArabic = '';

          if (isArabic) {
            translatedArabic = query;
            final translation = await _translator.translate(query, to: 'uz');
            translatedUzbek = translation.text;
          } else {
            translatedUzbek = query;
            final translation = await _translator.translate(query, to: 'ar');
            translatedArabic = translation.text;
          }

          final dynamicWord = WordModel(
            id: 'dyn_${DateTime.now().millisecondsSinceEpoch}',
            arabic: translatedArabic,
            uzbek: translatedUzbek,
            difficulty: 'Tarjima',
            category: 'Search',
            exampleArabic: '',
            exampleUzbek: '',
          );

          state = AsyncValue.data([dynamicWord]);
        } catch (e) {
          state = AsyncValue.error(
            'Tarjima qilishda xatolik yuz berdi: $e',
            StackTrace.current,
          );
        }
      }
    } else {
      state = AsyncValue.data(filtered);
    }
  }
}
