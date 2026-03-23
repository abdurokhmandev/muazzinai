import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

/// Multi-step phone registration screen.
///
/// Flow: Enter phone → OTP verification → Set password → Done
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // ── Step tracking: 0 = phone, 1 = OTP, 2 = password ──
  int _currentStep = 0;

  // ── Controllers ──
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _generatedOtp; // Simulated OTP shown in-app

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Step 1: Request OTP ──
  Future<void> _requestOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showError('Telefon raqam kiriting');
      return;
    }
    if (!AuthService.isValidPhone(phone)) {
      _showError('+998XXXXXXXXX formatida kiriting');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final code = await ref.read(userProvider.notifier).requestOtp(phone);
      _generatedOtp = code;

      if (mounted) {
        setState(() {
          _currentStep = 1;
          _isLoading = false;
        });

        // Show simulated SMS notification
        _showOtpNotification(code);
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError(e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Xatolik yuz berdi: $e');
      }
    }
  }

  // ── Step 2: Verify OTP ──
  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.isEmpty) {
      _showError('Tasdiqlash kodini kiriting');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final phone = _phoneController.text.trim();
      await ref.read(userProvider.notifier).verifyOtp(phone, code);

      if (mounted) {
        setState(() {
          _currentStep = 2;
          _isLoading = false;
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError(e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Xatolik yuz berdi: $e');
      }
    }
  }

  // ── Step 3: Set password & register ──
  Future<void> _register() async {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (password.isEmpty) {
      _showError('Parol kiriting');
      return;
    }
    if (password.length < 6) {
      _showError('Parol kamida 6 ta belgidan iborat bo\'lishi kerak');
      return;
    }
    if (password != confirm) {
      _showError('Parollar mos kelmaydi');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final phone = _phoneController.text.trim();
      await ref.read(userProvider.notifier).register(phone, password);

      if (mounted) {
        _showSuccess('Ro\'yxatdan muvaffaqiyatli o\'tdingiz!');
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) context.go('/');
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError(e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Xatolik yuz berdi: $e');
      }
    }
  }

  // ── UI Helpers ──

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Shows the simulated SMS OTP as a MaterialBanner notification.
  void _showOtpNotification(String code) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.all(16),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '📱 SMS xabar (simulyatsiya)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Sizning tasdiqlash kodingiz: $code',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
        leading: const Icon(Icons.sms_rounded, color: AppColors.primaryPurple),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('YOPISH'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            // Hide any banners before navigating back
            ScaffoldMessenger.of(context).clearMaterialBanners();
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Step Indicator ──
              _buildStepIndicator(),
              const SizedBox(height: 32),

              // ── Title ──
              Text(
                _stepTitle,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 8),
              Text(
                _stepSubtitle,
                style: AppTextStyles.body1,
              ),
              const SizedBox(height: 48),

              // ── Step Content ──
              if (_currentStep == 0) _buildPhoneStep(),
              if (_currentStep == 1) _buildOtpStep(),
              if (_currentStep == 2) _buildPasswordStep(),
            ],
          ),
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_currentStep) {
      case 0:
        return 'Telefon raqam';
      case 1:
        return 'Tasdiqlash kodi';
      case 2:
        return 'Parol yarating';
      default:
        return '';
    }
  }

  String get _stepSubtitle {
    switch (_currentStep) {
      case 0:
        return 'Telefon raqamingizni kiriting';
      case 1:
        return 'SMS orqali yuborilgan kodni kiriting';
      case 2:
        return 'Hisobingiz uchun kuchli parol yarating';
      default:
        return '';
    }
  }

  // ── Step Indicator Dots ──
  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index <= _currentStep;
        final isCurrent = index == _currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 32 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryPurple
                : AppColors.primaryPurple.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }

  // ── Step 1: Phone Input ──
  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: '+998 90 123 45 67',
            labelText: 'Telefon raqam',
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\+\s\-]')),
          ],
        ),
        const SizedBox(height: 32),
        _buildActionButton('Kod yuborish', _requestOtp),
      ],
    );
  }

  // ── Step 2: OTP Input ──
  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _otpController,
          decoration: InputDecoration(
            hintText: '1234',
            labelText: 'Tasdiqlash kodi',
            prefixIcon: const Icon(Icons.pin_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 12,
          ),
        ),
        const SizedBox(height: 16),

        // Show the OTP code hint
        if (_generatedOtp != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Simulyatsiya: Sizning kodingiz — $_generatedOtp',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 32),
        _buildActionButton('Tasdiqlash', _verifyOtp),
        const SizedBox(height: 16),

        // Resend OTP
        TextButton(
          onPressed: _isLoading ? null : _requestOtp,
          child: const Text(
            'Kodni qayta yuborish',
            style: TextStyle(
              color: AppColors.primaryPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ── Step 3: Password ──
  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: 'Parol',
            labelText: 'Parol',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          obscureText: _obscurePassword,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            hintText: 'Parolni tasdiqlang',
            labelText: 'Parolni tasdiqlang',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          obscureText: _obscureConfirm,
        ),
        const SizedBox(height: 12),
        Text(
          '• Kamida 6 ta belgidan iborat bo\'lishi kerak',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 32),
        _buildActionButton('Ro\'yxatdan o\'tish', _register),
      ],
    );
  }

  // ── Shared Action Button ──
  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryPurple,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
