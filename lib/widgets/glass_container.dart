import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme/colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Border? border;
  final double? width;
  final double? height;

  const GlassContainer({
    required this.child,
    this.blur = 15,
    this.opacity = 0.1,
    this.borderRadius = 24,
    this.padding,
    this.gradient,
    this.border,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.glassBackground.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: AppColors.glassBorder.withValues(alpha: opacity * 2),
                  width: 1.5,
                ),
            gradient: gradient,
          ),
          child: child,
        ),
      ),
    );
  }
}
