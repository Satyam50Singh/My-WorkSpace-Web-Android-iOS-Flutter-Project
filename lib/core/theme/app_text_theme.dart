import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.roboto(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    headlineMedium: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    titleMedium: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
  );
}