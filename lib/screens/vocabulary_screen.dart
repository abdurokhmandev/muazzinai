import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/text_styles.dart';
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
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Greetings',
    'Education',
    'Transport',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref
        .read(vocabularyProvider.notifier)
        .filter(_searchController.text, _selectedCategory);
  }

  void _onCategoryChanged(String cat) {
    setState(() => _selectedCategory = cat);
    ref
        .read(vocabularyProvider.notifier)
        .filter(_searchController.text, _selectedCategory);
  }

  Future<void> _playAudio(String url) async {
    // In production, load actual URL. Here we mock success or show not available.
    try {
      if (url.isNotEmpty) {
        await _audioPlayer.setUrl(url);
        _audioPlayer.play();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Audio topilmadi')));
        }
      }
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordsState = ref.watch(vocabularyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lug\'at'),
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
                    hintText: 'So\'z qidiring...',
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
                      return ActionChip(
                        label: Text(cat),
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
            return const Center(child: Text('So\'zlar topilmadi'));
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
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  word.arabic,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        'Amiri', // Assuming an Arabic font is available or generic fallback
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppColors.tealCyan,
                ),
                onPressed: () => _playAudio(word.audioUrl),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(word.uzbek, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.yellowGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  word.difficulty,
                  style: const TextStyle(
                    color: AppColors.yellowGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  word.isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: word.isBookmarked
                      ? AppColors.primaryPurple
                      : Colors.grey,
                ),
                onPressed: () {
                  ref.read(vocabularyProvider.notifier).toggleBookmark(word.id);
                },
              ),
            ],
          ),
          if (word.exampleArabic.isNotEmpty) ...[
            const Divider(),
            Text(
              word.exampleArabic,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(word.exampleUzbek, style: AppTextStyles.body2),
          ],
        ],
      ),
    );
  }
}
