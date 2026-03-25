import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';
import '../../widgets/glass_container.dart';

class MockExamScreen extends StatefulWidget {
  const MockExamScreen({super.key});

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 60;
  Timer? _timer;
  bool _isFinished = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Quyidagi so\'zning ma\'nosi nima? "مَدْرَسَةٌ"',
      'options': ['Uy', 'Maktab', 'Kitob', 'Ruchka'],
      'correctIndex': 1,
    },
    {
      'question': 'Arab alifbosida nechta harf bor?',
      'options': ['26', '28', '29', '32'],
      'correctIndex': 1,
    },
    {
      'question': 'Qaysi biri "Rahmat" degani?',
      'options': ['مَرْحَبًا', 'شُكْرًا', 'نَعَمْ', 'لَا'],
      'correctIndex': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _finishExam();
      }
    });
  }

  void _finishExam() {
    _timer?.cancel();
    setState(() => _isFinished = true);
  }

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _questions[_currentQuestionIndex]['correctIndex']) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      _finishExam();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
          child: _isFinished ? _buildResultsScreen() : _buildExamContent(),
        ),
      ),
    );
  }

  Widget _buildExamContent() {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryPurple, AppColors.tealCyan],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryPurple.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Savol ${_currentQuestionIndex + 1} / ${_questions.length}'.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                GlassContainer(
                  borderRadius: 28,
                  padding: const EdgeInsets.all(28),
                  opacity: 0.1,
                  child: Text(
                    question['question'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ...List.generate(
                  (question['options'] as List<String>).length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => _answerQuestion(index),
                      child: GlassContainer(
                        borderRadius: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        opacity: 0.06,
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.textPrimary.withValues(alpha: 0.2),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                (question['options'] as List<String>)[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: AppColors.textSecondary.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 28),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: 8),
              const Text(
                'MOCK IMTIHON',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          GlassContainer(
            borderRadius: 14,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            opacity: 0.1,
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppColors.yellowGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${_timeLeft ~/ 60}:${(_timeLeft % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.yellowGold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    final double percentage = _score / _questions.length;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: GlassContainer(
          borderRadius: 40,
          padding: const EdgeInsets.all(40),
          opacity: 0.2,
          gradient: LinearGradient(
            colors: [
              (percentage >= 0.5 ? AppColors.tealCyan : AppColors.primaryPurple).withValues(alpha: 0.3),
              AppColors.primaryBlue.withValues(alpha: 0.1),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (percentage >= 0.5 ? AppColors.tealCyan : Colors.redAccent).withValues(alpha: 0.1),
                ),
                child: Icon(
                  percentage >= 0.5 ? Icons.emoji_events_rounded : Icons.sentiment_dissatisfied_rounded,
                  size: 100,
                  color: percentage >= 0.5 ? AppColors.yellowGold : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                percentage >= 0.5 ? 'TABRIKLAYMIZ!' : 'URINIB KO\'RING',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Siz ${_questions.length} ta savoldan $_score tasiga to\'g\'ri javob berdingiz.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text('BOSH SAHIFAGA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex = 0;
                    _score = 0;
                    _timeLeft = 60;
                    _isFinished = false;
                  });
                  _startTimer();
                },
                child: const Text(
                  'QAYTADAN URINISH',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1,
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
