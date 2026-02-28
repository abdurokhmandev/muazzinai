import 'dart:async';
import '../models/user_model.dart';

class AuthService {
  // Simple controller to mock auth state changes
  final _authStateController = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  Future<UserModel?> getCurrentUserData() async {
    // Return cached user if any
    return _currentUser;
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful login for any user
      _currentUser = UserModel(
        id: 'mock_user_123',
        email: email,
        name: email.split('@')[0],
        joinDate: DateTime.now(),
      );

      _authStateController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signUp(String email, String password, String name) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = UserModel(
        id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        joinDate: DateTime.now(),
      );

      _authStateController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void dispose() {
    _authStateController.close();
  }
}
