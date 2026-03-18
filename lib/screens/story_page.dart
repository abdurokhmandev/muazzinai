import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────
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

// ─────────────────────────────────────────────
// Translation Service  (ar → uz)
// ─────────────────────────────────────────────
class TranslationService {
  // Cache: bir marta tarjima qilingan so'z saqlanadi
  final Map<String, String> _cache = {};

  // Lokal fallback map — arabcha so'zlar (internet bo'lmasa)
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
    'جديد': 'yangi',
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

    // 1. Cache dan tekshir
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    // 2. MyMemory API — arabcha → o'zbek
    try {
      final uri = Uri.parse(
        'https://api.mymemory.translated.net/get'
        '?q=${Uri.encodeComponent(key)}&langpair=ar|uz',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final translated =
            data['responseData']?['translatedText'] as String? ?? '';

        if (translated.isNotEmpty && translated != key) {
          _cache[key] = translated;
          return translated;
        }
      }
    } catch (_) {
      // Internet yo'q yoki timeout — fallback ga o'tamiz
    }

    // 3. Fallback: lokal map
    final fallbackResult = _fallback[key] ?? '';
    _cache[key] = fallbackResult;
    return fallbackResult;
  }
}

// ─────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────
class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final TranslationService _translator = TranslationService();

  // ✏️ Shu yerga o'zingning arabcha matnni yoz
  final String storyText =
      "اِسْمِي أَحْمَد. هَذَا هُوَ أَوَّلُ يَوْمٍ لِي فِي الْعَمَلِ الْجَدِيد. "
      "لَدَيَّ مَكْتَبٌ وَكُرْسِيٌّ. عَلَى مَكْتَبِي يُوجَدُ كُمْبِيُوتَرٌ وَهَاتِفٌ وَقَلَمٌ. "
      "قَالَ مُدِيرِي: مَرْحَبًا أَحْمَد! أَهْلاً بِكَ فِي الْعَمَل. "
      "قَابَلْتُ زَمِيلِي. قُلْتُ لَهُ: مِنْ فَضْلِكَ نَادِنِي أَحْمَد. "
      "قَالَ: شُكْرًا. قُلْتُ: عَفْوًا. أَنَا سَعِيدٌ بِوُجُودِي هُنَا. "
      "إِذَا أَخْطَأْتُ سَأَقُولُ آسِف. أَتَمَنَّى أَنْ أَعْمَلَ بِشَكْلٍ جَيِّد. "
      "نَعَمْ سَأَبْذُلُ قُصَارَى جُهْدِي. لَنْ أَسْتَسْلِم. مَعَ السَّلَامَة.";

  // arabcha matnda highlight qilinadigan so'zlar
  final Set<String> preHighlighted = {'مكتب', 'كمبيوتر', 'آسف', 'نعم'};

  int? selectedIndex;

  final Map<int, String> _translations = {};
  final Map<int, bool> _loading = {};

  // Arabcha tokenizer — bo'sh joy va tinish belgilariga qarab bo'ladi
  List<WordToken> _tokenize(String input) {
    final List<WordToken> tokens = [];
    final words = input.split(' ');
    for (final word in words) {
      if (word.isEmpty) continue;
      // Arabcha tinish belgilari: . , ! ? ؟ ، ؛
      final trailMatch = RegExp(
        r'[.,!?؟،؛\u060C\u061B\u061F]+$',
      ).firstMatch(word);
      final trailing = trailMatch != null ? trailMatch.group(0)! : '';
      final core = trailing.isNotEmpty
          ? word.substring(0, word.length - trailing.length)
          : word;
      // clean: faqat arabcha harflar va harakat belgilari
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
      backgroundColor: const Color(0xFF0F0823),
      body: GestureDetector(
        onTap: () => setState(() => selectedIndex = null),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1535),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white70,
                          size: 22,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B4FE0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Darsni tugatish',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Title ─────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 12),
                child: Text(
                  'Rise Story',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // ── Story text (o'ngdan chapga — arabcha) ─────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Directionality(
                    // Arabcha matn o'ngdan chapga
                    textDirection: TextDirection.rtl,
                    child: Wrap(
                      children: List.generate(tokens.length, (index) {
                        final token = tokens[index];
                        final bool isSelected = selectedIndex == index;
                        final bool isLoadingThis = _loading[index] == true;
                        final String translation = _translations[index] ?? '';
                        final bool isHighlighted = preHighlighted.contains(
                          token.clean,
                        );

                        Color wordColor;
                        if (isSelected) {
                          wordColor = Colors.white;
                        } else if (isHighlighted) {
                          wordColor = const Color(0xFF9D6FFF);
                        } else {
                          wordColor = Colors.white70;
                        }

                        return GestureDetector(
                          onTap: () => _onWordTap(index, token.clean),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 1,
                              vertical: 8,
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                // ── Popup tooltip ──────────────
                                if (isSelected && token.clean.isNotEmpty)
                                  Positioned(
                                    bottom: 34,
                                    child: IgnorePointer(
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minWidth: 70,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2A2040),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.5,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Arabcha so'z
                                            Text(
                                              token.original,
                                              textDirection: TextDirection.rtl,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            // Loading yoki tarjima
                                            if (isLoadingThis)
                                              const SizedBox(
                                                width: 14,
                                                height: 14,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Color(0xFF9D6FFF),
                                                    ),
                                              )
                                            else if (translation.isNotEmpty)
                                              Text(
                                                translation,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: const TextStyle(
                                                  color: Color(0xFF9D6FFF),
                                                  fontSize: 13,
                                                ),
                                              )
                                            else
                                              const Text(
                                                '—',
                                                style: TextStyle(
                                                  color: Colors.white38,
                                                  fontSize: 13,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                // ── Word chip ──────────────────
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF7B4FE0)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    token.trailing.isNotEmpty
                                        ? '${token.original}${token.trailing} '
                                        : '${token.original} ',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 19,
                                      height: 1.55,
                                      color: wordColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
