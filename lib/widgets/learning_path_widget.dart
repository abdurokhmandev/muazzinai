import 'package:flutter/material.dart';

class LearningPathWidget extends StatelessWidget {
  const LearningPathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dashed Line Painter (simulated with a simple stack for now)
        CustomPaint(
          size: const Size(double.infinity, 400),
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
                  Colors.teal,
                ),
                _buildLearningItem(
                  Icons.import_contacts_rounded,
                  'Materials',
                  Colors.teal.shade200,
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLearningItem(
                  Icons.headset_rounded,
                  'Audio',
                  Colors.grey.shade300,
                ),
                _buildLearningItem(
                  Icons.mic_none_rounded,
                  'Speaking',
                  Colors.grey.shade200,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLearningItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: color.withValues(alpha: 1), size: 40),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
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
      ..color = Colors.teal.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.25, 40);
    path.quadraticBezierTo(size.width * 0.5, 40, size.width * 0.5, 120);
    path.quadraticBezierTo(size.width * 0.5, 200, size.width * 0.75, 200);

    // Simple dash effect
    const dashWidth = 5.0;
    const dashSpace = 5.0;
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
