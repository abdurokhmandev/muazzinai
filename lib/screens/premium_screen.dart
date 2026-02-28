import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/text_styles.dart';
import '../../services/payment_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _isLoading = false;
  int _selectedPlan = 0; // 0=Monthly, 1=Yearly

  Future<void> _processPayment() async {
    setState(() => _isLoading = true);

    try {
      // Step 1: Request client secret from backend
      final clientSecret = await _paymentService.fetchMockClientSecret();

      // Step 2: Initialize Payment Sheet
      await _paymentService.initPaymentSheet(clientSecret);

      // Step 3: Present Payment Sheet
      final success = await _paymentService.presentPaymentSheet();

      if (success && mounted) {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Muvaffaqiyatli!'),
            content: const Text('Siz Ibrat Pro obunasini xarid qildingiz.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Xatolik: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ibrat Pro'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              size: 80,
              color: AppColors.yellowGold,
            ),
            const SizedBox(height: 16),
            const Text(
              'Super Arab tili Pro',
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Barcha premium funksiyalarga cheksiz kirish huquqini oling',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildFeatureList(),
            const SizedBox(height: 32),
            _buildPlanCard('Oylik', '\$9.99/oy', 0),
            const SizedBox(height: 16),
            _buildPlanCard('Yillik (20% chegirma)', '\$79.99/yil', 1),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _isLoading ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(56),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text(
                      'To\'lov qilish',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildFeatureItem('Barcha video darslarga cheksiz kirish'),
          _buildFeatureItem('Offline rejimda o\'rganish imkoniyati'),
          _buildFeatureItem('Reklamalarsiz toza interfeys'),
          _buildFeatureItem('Ovozli lug\'at va tahlillar'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.tealCyan,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(String title, String price, int index) {
    final isSelected = _selectedPlan == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.yellowGold.withValues(alpha: 0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.yellowGold
                : Colors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSelected
                        ? AppColors.yellowGold
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.yellowGold,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
