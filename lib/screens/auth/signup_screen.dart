import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/glass_container.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  int _currentStep = 0;

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _generatedOtp;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
        _showError('Xatolik yuz berdi');
      }
    }
  }

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
        _showError('Xatolik yuz berdi');
      }
    }
  }

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
        _showError('Xatolik yuz berdi');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showOtpNotification(String code) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.all(16),
        elevation: 10,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '📱 SMS xabar (simulyatsiya)',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.primaryPurple),
            ),
            const SizedBox(height: 4),
            Text(
              'Sizning tasdiqlash kodingiz: $code',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        leading: const Icon(Icons.sms_rounded, color: AppColors.primaryPurple, size: 30),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('TUSHUNARLI', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.darkGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildStepIndicator(),
                      const SizedBox(height: 48),
                      Text(
                        _stepTitle,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _stepSubtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildCurrentStepView(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).clearMaterialBanners();
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              } else {
                context.pop();
              }
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  String get _stepTitle {
    switch (_currentStep) {
      case 0: return 'Telefon raqam';
      case 1: return 'Tasdiqlash kodi';
      case 2: return 'Parol yarating';
      default: return '';
    }
  }

  String get _stepSubtitle {
    switch (_currentStep) {
      case 0: return 'Telefon raqamingizni kiriting';
      case 1: return 'SMS orqali yuborilgan kodni kiriting';
      case 2: return 'Hisobingiz uchun kuchli parol yarating';
      default: return '';
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index <= _currentStep;
        final isCurrent = index == _currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 40 : 12,
          height: 12,
          decoration: BoxDecoration(
            gradient: isActive 
                ? const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue])
                : null,
            color: isActive ? null : AppColors.textSecondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            boxShadow: isActive ? [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 0: return _buildPhoneStep();
      case 1: return _buildOtpStep();
      case 2: return _buildPasswordStep();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildPhoneStep() {
    return Column(
      key: const ValueKey('phone'),
      children: [
        _buildInputField(
          controller: _phoneController,
          hint: '+998 90 123 45 67',
          label: 'Telefon raqam',
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 48),
        _buildActionButton('KOD YUBORISH', _requestOtp),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      key: const ValueKey('otp'),
      children: [
        _buildInputField(
          controller: _otpController,
          hint: '1 2 3 4',
          label: 'Tasdiqlash kodi',
          icon: Icons.pin_rounded,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 12,
            color: AppColors.textPrimary,
          ),
        ),
        if (_generatedOtp != null) ...[
          const SizedBox(height: 24),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            opacity: 0.05,
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.orangeAccent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Simulyatsiya: Sizning kodingiz — $_generatedOtp',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 48),
        _buildActionButton('TASDIQLASH', _verifyOtp),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _isLoading ? null : _requestOtp,
          child: const Text(
            'Kodni qayta yuborish',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      key: const ValueKey('password'),
      children: [
        _buildInputField(
          controller: _passwordController,
          hint: 'Parol',
          label: 'Yangi parol',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          obscureText: _obscurePassword,
          onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          controller: _confirmPasswordController,
          hint: 'Parolni tasdiqlang',
          label: 'Parolni tasdiqlang',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          obscureText: _obscureConfirm,
          onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),
        const SizedBox(height: 48),
        _buildActionButton('RO\'YXATDAN O\'TISH', _register),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextAlign textAlign = TextAlign.start,
    TextStyle? style,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          opacity: 0.08,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textAlign: textAlign,
            style: style ?? const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.3)),
              prefixIcon: Icon(icon, color: AppColors.textSecondary.withValues(alpha: 0.6), size: 22),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        size: 22,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: _isLoading ? null : onPressed,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [AppColors.primaryPurple, AppColors.primaryBlue],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
        ),
      ),
    );
  }
}
