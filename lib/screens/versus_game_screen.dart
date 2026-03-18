import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

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
      backgroundColor: const Color(0xFF0F0823),
      body: SafeArea(
        child: Column(
          children: [
            _buildScores(),
            const Spacer(),
            if (isGameOver) _buildGameOver() else _buildGameContent(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildScores() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPlayerScore('Siz', playerScore, Colors.blue),
          const Text(
            'VS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          _buildPlayerScore('Bot', botScore, Colors.red),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String name, int score, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              name[0],
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$score XP',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildGameContent() {
    final question = questions[currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            question['question'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ...List.generate(question['options'].length, (index) {
            final option = question['options'][index];
            final isSelected = selectedOption == option;
            Color bgColor = Colors.white.withValues(alpha: 0.05);
            Color borderColor = Colors.white.withValues(alpha: 0.1);

            if (showFeedback && isSelected) {
              bgColor = isCorrect
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2);
              borderColor = isCorrect ? Colors.green : Colors.red;
            }

            return GestureDetector(
              onTap: () => _handleOptionTap(option),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
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
      children: [
        Icon(
          won
              ? Icons.emoji_events_rounded
              : Icons.sentiment_very_dissatisfied_rounded,
          color: won ? Colors.amber : Colors.grey,
          size: 100,
        ),
        const SizedBox(height: 20),
        Text(
          won ? 'G‘ALABA!' : 'MAG‘LUBIYAT',
          style: TextStyle(
            color: won ? Colors.amber : Colors.white70,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B12FF),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'ORQAGA',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
