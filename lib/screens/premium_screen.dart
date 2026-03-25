import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../payment/payment_method_screen.dart';
import '../config/theme/colors.dart';
import '../widgets/glass_container.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen>
    with TickerProviderStateMixin {
  int _selectedPlan = 0;
  late AnimationController _floatController;
  late AnimationController _glowController;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.darkGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _build3DCrownSection(),
                      const SizedBox(height: 32),
                      _buildTitleSection(),
                      const SizedBox(height: 48),
                      _buildFeatureCards(),
                      const SizedBox(height: 48),
                      _buildPlanSelector(),
                      const SizedBox(height: 48),
                      _buildPaymentButtons(),
                      const SizedBox(height: 40),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 22),
            onPressed: () => context.pop(),
          ),
          const Text(
            'MUAZZIN PRO',
            style: TextStyle(
              color: AppColors.yellowGold,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _build3DCrownSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _glowAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.yellowGold.withValues(alpha: 0.4 * _glowAnimation.value),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: GlassContainer(
                borderRadius: 90,
                opacity: 0.1,
                child: const Center(
                  child: Text('👑', style: TextStyle(fontSize: 80)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        const Text(
          'Cheksiz Imkoniyatlar',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A’zo bo‘ling va barcha premium\nfunksiyalardan foydalaning',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCards() {
    final features = [
      _FeatureData(Icons.play_circle_filled_rounded, 'Cheksiz Darslar', 'Barcha videolarga kirish', AppColors.primaryPurple),
      _FeatureData(Icons.offline_bolt_rounded, 'Offline Rejim', 'Internet holda o\'rganish', AppColors.tealCyan),
      _FeatureData(Icons.verified_user_rounded, 'Ekspert Qo\'llovi', 'Ustozlar bilan jonli muloqot', AppColors.primaryBlue),
    ];

    return Column(children: features.map((f) => _buildFeatureCard(f)).toList());
  }

  Widget _buildFeatureCard(_FeatureData feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(20),
        opacity: 0.08,
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: feature.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(feature.icon, color: feature.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSelector() {
    return Column(
      children: [
        _buildPlanOption(title: 'Oylik Obuna', price: '\$9.99', period: '/oy', index: 0),
        const SizedBox(height: 16),
        _buildPlanOption(title: 'Yillik Obuna', price: '\$79.99', period: '/yil', index: 1, badge: 'SAVE 30%'),
      ],
    );
  }

  Widget _buildPlanOption({
    required String title,
    required String price,
    required String period,
    required int index,
    String? badge,
  }) {
    final isSelected = _selectedPlan == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(24),
        opacity: isSelected ? 0.2 : 0.05,
        border: Border.all(
          color: isSelected ? AppColors.yellowGold : Colors.white.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
        gradient: isSelected
            ? const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue])
            : null,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badge != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.yellowGold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10),
                      ),
                    ),
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.yellowGold,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white.withValues(alpha: 0.7) : AppColors.textSecondary.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButtons() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentMethodScreen(
              plan: _selectedPlan == 0 ? 'monthly' : 'yearly',
              price: _selectedPlan == 0 ? '\$9.99' : '\$79.99',
            ),
          ),
        );
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(colors: [AppColors.yellowGold, Color(0xFFFFA500)]),
          boxShadow: [
            BoxShadow(
              color: AppColors.yellowGold.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'OBUNA BO‘LISH',
            style: TextStyle(
              color: Colors.black,
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

class _FeatureData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  _FeatureData(this.icon, this.title, this.subtitle, this.color);
}
