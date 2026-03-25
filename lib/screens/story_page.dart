import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../config/theme/colors.dart';
import '../widgets/glass_container.dart';

class WordToken {
  final String original;
  final String clean;
  final String trailing;

  const WordToken({
    required this.original,
    required this.clean,
    required this.trailing,
  });
}

class TranslationService {
  final Map<String, String> _cache = {};
  final Map<String, String> _fallback = {
    'اسمي': 'mening ismim',
    'أنا': 'men',
    'في': 'da/ichida',
    'من': 'dan/kimdan',
    'على': 'ustida',
    'هذا': 'bu',
    'هو': 'u (erkak)',
    'هي': 'u (ayol)',
    'نعم': 'ha',
    'لا': "yo'q",
    'مكتب': 'ofis',
    'كمبيوتر': 'kompyuter',
    'هاتف': 'telefon',
    'كتاب': 'kitob',
    'قلم': 'qalam',
    'يوم': 'kun',
    'عمل': 'ish',
    'جدid': 'yangi',
    'مرحبا': 'salom',
    'شكرا': 'rahmat',
    'آسف': 'kechirasiz',
    'طاولة': 'stol',
    'كرسي': 'stul',
    'صباح': 'ertalab',
    'مساء': 'kechqurun',
    'بيت': 'uy',
    'ماء': 'suv',
    'طعام': 'ovqat',
    'صديق': "do'st",
    'زميل': 'hamkasb',
  };

  Future<String> translate(String word) async {
    if (word.isEmpty) return '';
    final key = word.trim();
    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final uri = Uri.parse('https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(key)}&langpair=ar|uz');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final translated = data['responseData']?['translatedText'] as String? ?? '';
        if (translated.isNotEmpty && translated != key) {
          _cache[key] = translated;
          return translated;
        }
      }
    } catch (_) {}

    final fallbackResult = _fallback[key] ?? '';
    _cache[key] = fallbackResult;
    return fallbackResult;
  }
}

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final TranslationService _translator = TranslationService();
  final String storyText =
      "اِسْمِي أَحْمَد. هَذَا هُوَ أَوَّلُ يَوْمٍ لِي فِي الْعَمَلِ الْجَدِيد. "
      "لَدَيَّ مَكْتَبٌ وَكُرْسِيٌّ. عَلَى مَكْتَبِي يُوجَدُ كُمْبِيُوتَرٌ وَهَاتِفٌ وَقَلَمٌ. "
      "قَالَ مُدِيرِي: مَرْحَبًا أَحْمَد! أَهْلاً بِكَ فِي الْعَمَل. "
      "قَابَلْتُ زَمِيلِي. قُلْتُ لَهُ: مِنْ فَضْلِكَ نَادِنِي أَحْمَد. "
      "قَالَ: شُكْرًا. قُلْتُ: عَفْوًا. أَنَا سَعِيدٌ بِوُجُودِي هُنَا. "
      "إِذَا أَخْطَأْتُ سَأَقُولُ آسِف. أَتَمَنَّى أَنْ أَعْمَلَ بِشَكْلٍ جَيِّد. "
      "نَعَمْ سَأَبْذُلُ قُصَارَى جُهْدِي. لَنْ أَسْتَسْلِم. مَعَ السَّلَامَة.";

  final Set<String> preHighlighted = {'مكتب', 'كمبيوتر', 'آسف', 'نعم'};
  int? selectedIndex;
  final Map<int, String> _translations = {};
  final Map<int, bool> _loading = {};

  List<WordToken> _tokenize(String input) {
    final List<WordToken> tokens = [];
    final words = input.split(' ');
    for (final word in words) {
      if (word.isEmpty) continue;
      final trailMatch = RegExp(r'[.,!?؟،؛\u060C\u061B\u061F]+$').firstMatch(word);
      final trailing = trailMatch != null ? trailMatch.group(0)! : '';
      final core = trailing.isNotEmpty ? word.substring(0, word.length - trailing.length) : word;
      final clean = core.replaceAll(RegExp(r'[^\u0600-\u06FF]'), '').trim();
      tokens.add(WordToken(original: core, clean: clean, trailing: trailing));
    }
    return tokens;
  }

  Future<void> _onWordTap(int index, String clean) async {
    if (selectedIndex == index) {
      setState(() => selectedIndex = null);
      return;
    }
    setState(() => selectedIndex = index);
    if (_translations.containsKey(index)) return;
    setState(() => _loading[index] = true);
    final result = await _translator.translate(clean);
    if (mounted) {
      setState(() {
        _translations[index] = result;
        _loading[index] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = _tokenize(storyText);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.darkGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GestureDetector(
          onTap: () => setState(() => selectedIndex = null),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Text(
                    'Arabcha Hikoya',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 8,
                        children: List.generate(tokens.length, (index) {
                          final token = tokens[index];
                          final isSelected = selectedIndex == index;
                          final isLoading = _loading[index] == true;
                          final translation = _translations[index] ?? '';
                          final isHighlighted = preHighlighted.contains(token.clean);

                          return _buildWordWidget(index, token, isSelected, isLoading, translation, isHighlighted);
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 22),
            onPressed: () => context.pop(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '1-DARS',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_voice_rounded, color: AppColors.textSecondary, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildWordWidget(int index, WordToken token, bool isSelected, bool isLoading, String translation, bool isHighlighted) {
    return GestureDetector(
      onTap: () => _onWordTap(index, token.clean),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Positioned(
              bottom: 44,
              child: GlassContainer(
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                opacity: 0.2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      token.clean,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    if (isLoading)
                      const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: AppColors.primaryPurple, strokeWidth: 2))
                    else
                      Text(
                        translation.isNotEmpty ? translation : 'Tarjima...',
                        style: const TextStyle(color: AppColors.tealCyan, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                  ],
                ),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryPurple : (isHighlighted ? AppColors.primaryPurple.withValues(alpha: 0.1) : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${token.original}${token.trailing}',
              style: TextStyle(
                fontSize: 22,
                height: 1.6,
                fontWeight: isHighlighted || isSelected ? FontWeight.w900 : FontWeight.w500,
                color: isSelected ? Colors.white : (isHighlighted ? AppColors.primaryPurple : AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
