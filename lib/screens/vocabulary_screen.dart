import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_translate/flutter_translate.dart';
import '../../config/theme/colors.dart';

import '../../providers/vocabulary_provider.dart';
import '../../models/word_model.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedCategory = 'All';
  Timer? _debounce;
  String? _playingWordId;

  final List<String> _categories = [
    'All',
    'Greetings',
    'Education',
    'Transport',
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    if (kIsWeb) {
      await _flutterTts.setLanguage("ar");
    } else {
      await _flutterTts.setLanguage("ar-SA");
      await _flutterTts.setSpeechRate(0.4);
    }

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _playingWordId = null;
        });
      }
    });

    _flutterTts.setErrorHandler((msg) {
      debugPrint("TTS Error: $msg");
      if (mounted) {
        setState(() {
          _playingWordId = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref
            .read(vocabularyProvider.notifier)
            .filter(_searchController.text, _selectedCategory);
      }
    });
  }

  void _onCategoryChanged(String cat) {
    setState(() => _selectedCategory = cat);
    ref
        .read(vocabularyProvider.notifier)
        .filter(_searchController.text, _selectedCategory);
  }

  Future<void> _playAudio(WordModel word) async {
    if (_playingWordId == word.id) return; // Already playing this word

    setState(() {
      _playingWordId = word.id;
    });

    try {
      if (word.audioUrl.isNotEmpty) {
        // Play via just_audio if native URL exists
        await _audioPlayer.setUrl(word.audioUrl);
        await _audioPlayer.play();
      } else {
        // Use flutter_tts package as requested
        await _flutterTts.speak(word.arabic);
      }

      if (mounted) {
        setState(() {
          _playingWordId = null;
        });
      }
    } catch (e) {
      debugPrint('Audio error: $e');
      if (mounted) {
        setState(() {
          _playingWordId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(translate('dictionary.error_audio')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordsState = ref.watch(vocabularyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(translate('dictionary.title')),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: translate('dictionary.search_hint'),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (c, i) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;

                      // Map internal category name to localized string
                      final categoryKey = cat.toLowerCase();
                      final localizedCat = translate(
                        'dictionary.categories.$categoryKey',
                      );
                      return ActionChip(
                        label: Text(localizedCat),
                        backgroundColor: isSelected
                            ? AppColors.primaryPurple
                            : AppColors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.withValues(alpha: 0.2),
                        ),
                        onPressed: () => _onCategoryChanged(cat),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      body: wordsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (words) {
          if (words.isEmpty) {
            return Center(child: Text(translate('dictionary.no_words')));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: words.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildWordCard(words[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildWordCard(WordModel word) {
    final isPlaying = _playingWordId == word.id;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.arabic,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri', // Adjust font later if needed
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      word.uzbek,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _playAudio(word),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? AppColors.tealCyan.withValues(alpha: 0.2)
                        : AppColors.primaryPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: isPlaying
                      ? const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.tealCyan,
                          ),
                        )
                      : const Icon(
                          Icons.volume_up_rounded,
                          color: AppColors.primaryPurple,
                          size: 26,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellowGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  word.difficulty,
                  style: const TextStyle(
                    color: AppColors.yellowGold,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  word.isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: word.isBookmarked
                      ? AppColors.yellowGold
                      : Colors.grey.withValues(alpha: 0.5),
                  size: 26,
                ),
                onPressed: () {
                  ref.read(vocabularyProvider.notifier).toggleBookmark(word.id);
                },
              ),
            ],
          ),
          if (word.exampleArabic.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Text(
              word.exampleArabic,
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 6),
            Text(
              word.exampleUzbek,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
