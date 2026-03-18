import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

final appProvider = ChangeNotifierProvider<AppProvider>((ref) {
  return AppProvider();
});

class AppProvider with ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  UserModel _user = UserModel(
    name: 'Abdurahmon MUMINOV',
    level: 1,
    streak: 5,
    score: 850,
    isPro: true,
    profileEmoji: '🇸🇦',
  );

  UserModel get user => _user;

  void updateUser({String? name, String? profileEmoji, int? score}) {
    _user = _user.copyWith(
      name: name,
      profileEmoji: profileEmoji,
      score: score,
    );
    notifyListeners();
  }

  void addScore(int points) {
    _user = _user.copyWith(score: _user.score + points);
    notifyListeners();
  }

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
    GameModel(
      title: 'ARABIC PUZZLE',
      description: 'Harflarni to\'g\'ri tartibda terib so\'z yasang.',
      gradientColors: [const Color(0xFF10B981), const Color(0xFF34D399)],
    ),
    GameModel(
      title: 'VOICE MATCH',
      description: 'Eshitgan so\'zingizni to\'g\'ri variantini tanlang.',
      gradientColors: [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
    ),
  ];
}
