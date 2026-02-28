import 'package:flutter/material.dart';

class GameModel {
  final String title;
  final String description;
  final String? iconPath;
  final List<Color> gradientColors;
  final dynamic extraData;

  GameModel({
    required this.title,
    required this.description,
    this.iconPath,
    required this.gradientColors,
    this.extraData,
  });
}

class CourseModel {
  final String title;
  final String subtitle;
  final String progressText;
  final double progress;

  CourseModel({
    required this.title,
    required this.subtitle,
    required this.progressText,
    required this.progress,
  });
}

class UserModel {
  final String name;
  final int level;
  final int streak;
  final bool isPro;
  final String profileEmoji;

  UserModel({
    required this.name,
    required this.level,
    required this.streak,
    required this.isPro,
    required this.profileEmoji,
  });
}
