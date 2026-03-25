import 'package:flutter/material.dart';
import '../config/theme/colors.dart';
import 'glass_container.dart';

class LearningPathWidget extends StatelessWidget {
  const LearningPathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(double.infinity, 450),
          painter: DashedPathPainter(),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLearningItem(
                  Icons.menu_book_rounded,
                  'Reading',
                  const Color(0xFF10B981),
                ),
                _buildLearningItem(
                  Icons.import_contacts_rounded,
                  'Materials',
                  const Color(0xFF3B82F6),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLearningItem(
                  Icons.headset_rounded,
                  'Audio',
                  const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                  isLocked: true,
                ),
                _buildLearningItem(
                  Icons.mic_none_rounded,
                  'Speaking',
                  const Color(0xFFEC4899).withValues(alpha: 0.5),
                  isLocked: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLearningItem(IconData icon, String label, Color color, {bool isLocked = false}) {
    return Column(
      children: [
        GlassContainer(
          width: 88,
          height: 88,
          borderRadius: 24,
          padding: const EdgeInsets.all(2),
          opacity: 0.1,
          gradient: isLocked 
            ? null 
            : LinearGradient(
                colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          child: Center(
            child: Icon(
              isLocked ? Icons.lock_outline_rounded : icon,
              color: isLocked ? AppColors.textMuted : color,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            color: isLocked ? AppColors.textMuted : AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class DashedPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryPurple.withValues(alpha: 0.15)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.25, 60);
    path.quadraticBezierTo(size.width * 0.5, 60, size.width * 0.5, 140);
    path.quadraticBezierTo(size.width * 0.5, 220, size.width * 0.75, 220);
    path.quadraticBezierTo(size.width * 0.5, 220, size.width * 0.5, 300);
    path.quadraticBezierTo(size.width * 0.5, 380, size.width * 0.25, 380);

    const dashWidth = 8.0;
    const dashSpace = 8.0;
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
