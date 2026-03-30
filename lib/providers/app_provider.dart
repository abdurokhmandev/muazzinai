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
      title: 'VERSUS',
      description:
          'Boshqalar bilan o\'ynang va to\'g\'ri tarjima variantlarini tanlang.',
      gradientColors: [const Color(0xFF6B12FF), const Color(0xFF4b0091)],
    ),
  ];

}
