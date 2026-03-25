import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_provider.dart';
import '../config/theme/colors.dart';
import '../widgets/glass_container.dart';

class VersusGameScreen extends ConsumerStatefulWidget {
  const VersusGameScreen({super.key});

  @override
  ConsumerState<VersusGameScreen> createState() => _VersusGameScreenState();
}

class _VersusGameScreenState extends ConsumerState<VersusGameScreen> {
  int playerLevel = 1;
  int botLevel = 1;
  int playerScore = 0;
  int botScore = 0;
  int currentQuestionIndex = 0;
  bool isGameOver = false;
  String? selectedOption;
  bool showFeedback = false;
  bool isCorrect = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'كتاب',
      'options': ['Qalam', 'Kitob', 'Stul', 'Uy'],
      'answer': 'Kitob',
    },
    {
      'question': 'قلم',
      'options': ['Kitob', 'Maktab', 'Qalam', 'Suv'],
      'answer': 'Qalam',
    },
    {
      'question': 'بيت',
      'options': ['Shahar', 'Ko\'cha', 'Uy', 'Bino'],
      'answer': 'Uy',
    },
    {
      'question': 'مدرسة',
      'options': ['Maktab', 'Kasalxona', 'Do\'kon', 'Zavod'],
      'answer': 'Maktab',
    },
    {
      'question': 'ماء',
      'options': ['Sut', 'Choy', 'Sharbat', 'Suv'],
      'answer': 'Suv',
    },
  ];

  Timer? botTimer;

  @override
  void initState() {
    super.initState();
    _startBotTurn();
  }

  @override
  void dispose() {
    botTimer?.cancel();
    super.dispose();
  }

  void _startBotTurn() {
    botTimer?.cancel();
    // Bot decides after 3-6 seconds
    final delay = 3 + Random().nextInt(4);
    botTimer = Timer(Duration(seconds: delay), () {
      if (!isGameOver && !showFeedback) {
        _botAnswer();
      }
    });
  }

  void _botAnswer() {
    // Bot has 70% accuracy
    final correct = Random().nextDouble() < 0.7;
    setState(() {
      if (correct) {
        botScore += 10;
        if (botScore >= 100) isGameOver = true;
      }
      if (!isGameOver) {
        _nextQuestion();
      }
    });
  }

  void _handleOptionTap(String option) {
    if (showFeedback || isGameOver) return;

    setState(() {
      selectedOption = option;
      showFeedback = true;
      isCorrect = option == questions[currentQuestionIndex]['answer'];

      if (isCorrect) {
        playerScore += 10;
        ref.read(appProvider).addScore(10);
        if (playerScore >= 100) isGameOver = true;
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          showFeedback = false;
          selectedOption = null;
          if (!isGameOver) {
            _nextQuestion();
          }
        });
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
    });
    _startBotTurn();
  }

  @override
  Widget build(BuildContext context) {
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
              _buildAppBar(context),
              _buildScores(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: isGameOver ? _buildGameOver() : _buildGameContent(),
                  ),
                ),
              ),
            ],
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
          const Text(
            'VERSUS ARENA',
            style: TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.pause_circle_outline_rounded, color: AppColors.textPrimary, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildScores() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        opacity: 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPlayerScore('Siz', playerScore, AppColors.tealCyan),
            Stack(
              alignment: Alignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.primaryBlue],
                  ).createShader(bounds),
                  child: const Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            _buildPlayerScore('Bot', botScore, Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScore(String name, int score, Color color) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
          ),
          child: Center(
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$score XP',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildGameContent() {
    final question = questions[currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryPurple, AppColors.primaryBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                question['question'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          ...List.generate(question['options'].length, (index) {
            final option = question['options'][index];
            final isSelected = selectedOption == option;

            return GestureDetector(
              onTap: () => _handleOptionTap(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: showFeedback && isSelected
                      ? (isCorrect ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2))
                      : (isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: showFeedback && isSelected
                        ? (isCorrect ? Colors.greenAccent : Colors.redAccent)
                        : (isSelected ? AppColors.tealCyan : Colors.white.withValues(alpha: 0.1)),
                    width: 2,
                  ),
                  boxShadow: showFeedback && isSelected
                      ? [
                          BoxShadow(
                            color: isCorrect ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (showFeedback && isSelected)
                      Icon(
                        isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                        size: 24,
                      )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGameOver() {
    final won = playerScore >= 100;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: won ? [AppColors.yellowGold, Colors.yellowAccent] : [Colors.grey, Colors.white38],
          ).createShader(bounds),
          child: Icon(
            won ? Icons.emoji_events_rounded : Icons.sentiment_very_dissatisfied_rounded,
            color: Colors.white,
            size: 140,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          won ? 'G‘ALABA!' : 'MAG‘LUBIYAT',
          style: TextStyle(
            color: won ? AppColors.yellowGold : AppColors.textSecondary,
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          won ? 'Tabriklaymiz, siz g‘olib bo‘ldingiz!' : 'Keyingi safar albatta yutasiz.',
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 48),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'YAKUNLASH',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
