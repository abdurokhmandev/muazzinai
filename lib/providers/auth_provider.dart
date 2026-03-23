import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// ── Service provider (singleton) ──
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// ── Auth state stream ──
final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

// ── Auth state notifier ──
final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
      final authService = ref.read(authServiceProvider);
      return UserNotifier(authService);
    });

/// Manages authentication state for phone-based auth.
class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  UserNotifier(this._authService) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      state = const AsyncValue.loading();
      final user = await _authService.getCurrentUserData();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ── LOGIN with phone + password ──
  Future<void> login(String phone, String password) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authService.signInWithPhone(phone, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // ── OTP: Request verification code ──
  /// Returns the OTP code string (for displaying as simulated SMS).
  Future<String> requestOtp(String phone) async {
    try {
      return await _authService.requestOtp(phone);
    } catch (e) {
      rethrow;
    }
  }

  // ── OTP: Verify code ──
  Future<bool> verifyOtp(String phone, String code) async {
    try {
      return await _authService.verifyOtp(phone, code);
    } catch (e) {
      rethrow;
    }
  }

  // ── REGISTER with phone + password (after OTP verified) ──
  Future<void> register(String phone, String password) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authService.registerWithPhone(phone, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // ── LOGOUT ──
  Future<void> logout() async {
    try {
      state = const AsyncValue.loading();
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
