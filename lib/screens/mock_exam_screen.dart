import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/text_styles.dart';

class MockExamScreen extends StatefulWidget {
  const MockExamScreen({super.key});

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 60; // 60 seconds per test
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
    if (_isFinished) {
      return _buildResultsScreen();
    }

    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mock Exam'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '00:${_timeLeft.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.yellowGold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPurple,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 32),
              Text(
                'Savol ${_currentQuestionIndex + 1} / ${_questions.length}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(question['question'] as String, style: AppTextStyles.h2),
              const SizedBox(height: 48),
              ...List.generate(
                (question['options'] as List<String>).length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.1),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      (question['options'] as List<String>)[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildResultsScreen() {
    final double percentage = _score / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Natijalar')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                percentage >= 0.5
                    ? Icons.emoji_events_rounded
                    : Icons.sentiment_dissatisfied_rounded,
                size: 100,
                color: percentage >= 0.5 ? AppColors.yellowGold : Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                percentage >= 0.5 ? 'Tabriklaymiz!' : 'Yana harakat qiling',
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 16),
              Text(
                'Siz ${_questions.length} ta savoldan $_score tasiga to\'g\'ri javob berdingiz.',
                style: AppTextStyles.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text('Bosh sahifaga qaytish'),
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
                  'Qaytadan urinish',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
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
