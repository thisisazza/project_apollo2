import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import '../models/club.dart';

class AppTheme {
  static ThemeData getThemeForClub(Club? club) {
    // Default to Neon Strikers (Green) if no club selected
    final primaryColor = club?.primaryColor ?? AppColors.neonGreen;
    final secondaryColor = club?.secondaryColor ?? AppColors.electricBlue;

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: AppColors.black,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: AppColors.surface,
        error: AppColors.alertRed,
        onPrimary: AppColors.black,
        onSecondary: AppColors.black,
        onSurface: AppColors.textWhite,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.teko(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
          letterSpacing: 2.0,
        ),
        displayMedium: GoogleFonts.teko(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
        ),
        displaySmall: GoogleFonts.teko(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
        ),
        headlineMedium: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
          letterSpacing: 1.5,
        ),
        titleLarge: GoogleFonts.orbitron(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
        bodyLarge: GoogleFonts.roboto(fontSize: 16, color: AppColors.textWhite),
        bodyMedium: GoogleFonts.roboto(fontSize: 14, color: AppColors.textGrey),
      ),

      // Component Themes
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.teko(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
          letterSpacing: 2.0,
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.black,
          textStyle: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
