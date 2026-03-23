import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';

/// Phone-based authentication service with simulated OTP.
///
/// Uses an in-memory user database. In production, replace with a real backend.
class AuthService {
  // ── In-memory user database (keyed by phone number) ──
  final Map<String, UserModel> _userDatabase = {};

  // ── OTP storage: phone → {code, expiresAt} ──
  final Map<String, _OtpData> _otpStore = {};

  // ── Auth state stream ──
  final _authStateController = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  UserModel? get currentUser => _currentUser;

  Future<UserModel?> getCurrentUserData() async {
    return _currentUser;
  }

  // ─────────────────────────────────────────────
  // Phone Validation
  // ─────────────────────────────────────────────

  /// Validates Uzbek phone format: +998XXXXXXXXX (12 digits total)
  static bool isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^\+998\d{9}$').hasMatch(cleaned);
  }

  // ─────────────────────────────────────────────
  // Password Hashing (SHA-256 simulation)
  // ─────────────────────────────────────────────

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // ─────────────────────────────────────────────
  // LOGIN: Phone + Password
  // ─────────────────────────────────────────────

  Future<UserModel> signInWithPhone(String phone, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!isValidPhone(cleaned)) {
      throw AuthException('Telefon raqam formati noto\'g\'ri. +998XXXXXXXXX formatida kiriting.');
    }

    final user = _userDatabase[cleaned];
    if (user == null) {
      throw AuthException('Bu telefon raqam bilan foydalanuvchi topilmadi.');
    }

    final inputHash = _hashPassword(password);
    if (user.passwordHash != inputHash) {
      throw AuthException('Parol noto\'g\'ri. Qaytadan urinib ko\'ring.');
    }

    _currentUser = user;
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  // ─────────────────────────────────────────────
  // OTP: Request & Verify
  // ─────────────────────────────────────────────

  /// Generates a 4-digit OTP and stores it with a 2-minute expiry.
  /// Returns the OTP code (to be shown in-app as simulated SMS).
  Future<String> requestOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!isValidPhone(cleaned)) {
      throw AuthException('Telefon raqam formati noto\'g\'ri. +998XXXXXXXXX formatida kiriting.');
    }

    // Check for duplicate registration
    if (_userDatabase.containsKey(cleaned)) {
      throw AuthException('Bu telefon raqam allaqachon ro\'yxatdan o\'tgan.');
    }

    // Generate 4-digit OTP
    final code = (1000 + Random().nextInt(9000)).toString();
    _otpStore[cleaned] = _OtpData(
      code: code,
      expiresAt: DateTime.now().add(const Duration(minutes: 2)),
    );

    return code;
  }

  /// Verifies the OTP code for the given phone number.
  Future<bool> verifyOtp(String phone, String code) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final otpData = _otpStore[cleaned];

    if (otpData == null) {
      throw AuthException('OTP kod topilmadi. Avval telefon raqamni kiriting.');
    }

    if (DateTime.now().isAfter(otpData.expiresAt)) {
      _otpStore.remove(cleaned);
      throw AuthException('OTP kod muddati tugagan. Yangi kod so\'rang.');
    }

    if (otpData.code != code) {
      throw AuthException('OTP kod noto\'g\'ri. Qaytadan urinib ko\'ring.');
    }

    return true;
  }

  // ─────────────────────────────────────────────
  // REGISTER: After OTP verification
  // ─────────────────────────────────────────────

  Future<UserModel> registerWithPhone(String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!isValidPhone(cleaned)) {
      throw AuthException('Telefon raqam formati noto\'g\'ri.');
    }

    if (_userDatabase.containsKey(cleaned)) {
      throw AuthException('Bu telefon raqam allaqachon ro\'yxatdan o\'tgan.');
    }

    if (password.length < 6) {
      throw AuthException('Parol kamida 6 ta belgidan iborat bo\'lishi kerak.');
    }

    final hashedPassword = _hashPassword(password);

    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: cleaned,
      name: 'Foydalanuvchi',
      joinDate: DateTime.now(),
      passwordHash: hashedPassword,
    );

    _userDatabase[cleaned] = user;
    _otpStore.remove(cleaned); // Clean up OTP

    _currentUser = user;
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  // ─────────────────────────────────────────────
  // SIGN OUT
  // ─────────────────────────────────────────────

  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}

// ── Helper classes ──

class _OtpData {
  final String code;
  final DateTime expiresAt;

  _OtpData({required this.code, required this.expiresAt});
}

/// Custom auth exception with user-friendly messages.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
