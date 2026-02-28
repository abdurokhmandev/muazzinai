class UserModel {
  final String id;
  final String email;
  final String name;
  final String avatarUrl;
  final String languageLevel; // e.g., A1, A2, B1, B2
  final DateTime joinDate;
  final int totalLearningHours;
  final int streak;
  final bool isPro;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl = '',
    this.languageLevel = 'A1',
    required this.joinDate,
    this.totalLearningHours = 0,
    this.streak = 0,
    this.isPro = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      languageLevel: json['languageLevel'] ?? 'A1',
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
      totalLearningHours: json['totalLearningHours'] ?? 0,
      streak: json['streak'] ?? 0,
      isPro: json['isPro'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'languageLevel': languageLevel,
      'joinDate': joinDate.toIso8601String(),
      'totalLearningHours': totalLearningHours,
      'streak': streak,
      'isPro': isPro,
    };
  }
}
