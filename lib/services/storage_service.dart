import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userBoxName = 'userBox';
  static const String _offlineDataBox = 'offlineDataBox';

  Future<void> initialize() async {
    await Hive.initFlutter();

    // Open boxes
    await Hive.openBox(_userBoxName);
    await Hive.openBox(_offlineDataBox);
  }

  // Example caching method for courses
  Future<void> cacheCourses(List<dynamic> courses) async {
    final box = Hive.box(_offlineDataBox);
    await box.put('courses', courses.map((c) => c.toJson()).toList());
  }

  // User Settings (Theme, Language)
  Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
}
