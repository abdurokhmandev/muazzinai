import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color accentCyan = Color(0xFF22D3EE);
  static const Color tealCyan = Color(0xFF14B8A6);
  static const Color yellowGold = Color(0xFFFBBF24);
  
  // Background & Surface (Modern Dark Mode / Glassmorphism)
  static const Color background = Color(0xFF0F172A); // Deep Slate Blue
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);
  
  // Glassmorphism Tokens
  static Color glassBackground = Colors.white.withValues(alpha: 0.1);
  static Color glassBorder = Colors.white.withValues(alpha: 0.2);
  
  // Text
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Gradients
  static const List<Color> primaryGradient = [Color(0xFF8B5CF6), Color(0xFF3B82F6)];
  static const List<Color> accentGradient = [Color(0xFF22D3EE), Color(0xFF06B6D4)];
  static const List<Color> darkGradient = [Color(0xFF0F172A), Color(0xFF1E293B)];
}
