/// User model used by the auth system.
/// Stores phone number instead of email for phone-based authentication.
class UserModel {
  final String id;
  final String phoneNumber;
  final String name;
  final String avatarUrl;
  final String languageLevel; // e.g., A1, A2, B1, B2
  final DateTime joinDate;
  final int totalLearningHours;
  final int streak;
  final bool isPro;

  /// Password hash — only used internally for auth, never exposed to UI.
  final String passwordHash;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.name,
    this.avatarUrl = '',
    this.languageLevel = 'A1',
    required this.joinDate,
    this.totalLearningHours = 0,
    this.streak = 0,
    this.isPro = false,
    this.passwordHash = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      languageLevel: json['languageLevel'] ?? 'A1',
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
      totalLearningHours: json['totalLearningHours'] ?? 0,
      streak: json['streak'] ?? 0,
      isPro: json['isPro'] ?? false,
      passwordHash: json['passwordHash'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'avatarUrl': avatarUrl,
      'languageLevel': languageLevel,
      'joinDate': joinDate.toIso8601String(),
      'totalLearningHours': totalLearningHours,
      'streak': streak,
      'isPro': isPro,
      'passwordHash': passwordHash,
    };
  }

  UserModel copyWith({
    String? name,
    String? avatarUrl,
    String? languageLevel,
  }) {
    return UserModel(
      id: id,
      phoneNumber: phoneNumber,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      languageLevel: languageLevel ?? this.languageLevel,
      joinDate: joinDate,
      totalLearningHours: totalLearningHours,
      streak: streak,
      isPro: isPro,
      passwordHash: passwordHash,
    );
  }
}
