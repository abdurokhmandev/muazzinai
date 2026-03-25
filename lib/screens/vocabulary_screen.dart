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
import '../../widgets/glass_container.dart';

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
        ref.read(vocabularyProvider.notifier).filter(_searchController.text, _selectedCategory);
      }
    });
  }

  void _onCategoryChanged(String cat) {
    setState(() => _selectedCategory = cat);
    ref.read(vocabularyProvider.notifier).filter(_searchController.text, _selectedCategory);
  }

  Future<void> _playAudio(WordModel word) async {
    if (_playingWordId == word.id) return;

    setState(() {
      _playingWordId = word.id;
    });

    try {
      if (word.audioUrl.isNotEmpty) {
        await _audioPlayer.setUrl(word.audioUrl);
        await _audioPlayer.play();
      } else {
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
            backgroundColor: Colors.redAccent,
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
              _buildHeader(),
              Expanded(
                child: wordsState.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple)),
                  error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
                  data: (words) {
                    if (words.isEmpty) {
                      return Center(
                        child: Text(
                          translate('dictionary.no_words'),
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: words.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildWordCard(words[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('dictionary.title'),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              GlassContainer(
                borderRadius: 14,
                padding: const EdgeInsets.all(10),
                opacity: 0.1,
                child: const Icon(Icons.bookmarks_rounded, color: AppColors.yellowGold, size: 22),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GlassContainer(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            opacity: 0.08,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: translate('dictionary.search_hint'),
                hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (c, i) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat;
              final categoryKey = cat.toLowerCase();
              final localizedCat = translate('dictionary.categories.$categoryKey');

              return GestureDetector(
                onTap: () => _onCategoryChanged(cat),
                child: GlassContainer(
                  borderRadius: 14,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  opacity: isSelected ? 0.2 : 0.06,
                  gradient: isSelected
                      ? const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue])
                      : null,
                  child: Center(
                    child: Text(
                      localizedCat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWordCard(WordModel word) {
    final isPlaying = _playingWordId == word.id;

    return GlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(24),
      opacity: 0.08,
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
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Amiri',
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      word.uzbek,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.tealCyan.withValues(alpha: 0.9),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _playAudio(word),
                child: GlassContainer(
                  width: 56,
                  height: 56,
                  borderRadius: 20,
                  opacity: 0.15,
                  gradient: isPlaying
                      ? const LinearGradient(colors: [AppColors.tealCyan, AppColors.primaryBlue])
                      : null,
                  child: Center(
                    child: isPlaying
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  word.difficulty.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryPurple,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => ref.read(vocabularyProvider.notifier).toggleBookmark(word.id),
                icon: Icon(
                  word.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: word.isBookmarked ? AppColors.yellowGold : AppColors.textSecondary.withValues(alpha: 0.4),
                  size: 28,
                ),
              ),
            ],
          ),
          if (word.exampleArabic.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Colors.white10, height: 1),
            ),
            Text(
              word.exampleArabic,
              style: const TextStyle(
                fontSize: 22,
                color: AppColors.textPrimary,
                height: 1.6,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            Text(
              word.exampleUzbek,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
