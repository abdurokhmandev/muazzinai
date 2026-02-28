import 'package:flutter/material.dart';
import '../models/models.dart';

class AppProvider with ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Mock Data
  UserModel get user => UserModel(
    name: 'User',
    level: 1,
    streak: 0,
    isPro: true,
    profileEmoji: '🇸🇦',
  );

  List<GameModel> get games => [
    GameModel(
      title: 'LETTER BOX',
      description: 'Kataklar ortidagi yashirin so\'zni toping',
      gradientColors: [const Color(0xFFF59E0B), const Color(0xFFFFD60A)],
      extraData: 'GAME_GRID',
    ),
    GameModel(
      title: 'MEMORY PATH',
      description:
          'Rasmlarni eslang va ularni to\'g\'ri so\'zlar bilan moslang.',
      gradientColors: [Colors.red, Colors.orange],
    ),
    GameModel(
      title: 'CRAFT IT',
      description: 'Harfalar orasiga yashiringan so\'zlarni toping',
      gradientColors: [const Color(0xFF7C3AED), const Color(0xFF916BFF)],
    ),
    GameModel(
      title: 'VERSUS',
      description:
          'Boshqalar bilan o\'ynang va to\'g\'ri tarjima variantlarini tanlang.',
      gradientColors: [const Color(0xFF6B12FF), const Color(0xFF4b0091)],
    ),
    GameModel(
      title: 'LAST LETTER',
      description:
          'Keyingi so\'z oldingi so\'zning oxirgi harfi bilan boshlanadi.',
      gradientColors: [const Color(0xFF7C3AED), const Color(0xFF8B12FF)],
    ),
  ];
}
