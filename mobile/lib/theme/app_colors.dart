import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color black = Color(0xFF000000);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceLight = Color(0xFF1E1E1E);
  static const Color surfaceBlack = Color(0xFF121212);

  // Accents
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonBlue = Color(0xFF00FFFF); // Alias for electricBlue or distinct
  static const Color electricBlue = Color(0xFF00FFFF);
  static const Color neonPink = Color(0xFFFF1493);
  static const Color neonPurple = Color(0xFFBC13FE);
  static const Color alertRed = Color(0xFFFF3131);

  // Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFB0B0B0);

  // Gradients
  static const LinearGradient cyberGradient = LinearGradient(
    colors: [neonGreen, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
