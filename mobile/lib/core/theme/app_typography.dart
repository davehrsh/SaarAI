import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Pixel / arcade typography.
  //
  // Use this for:
  // - titles
  // - section labels
  // - scores
  // - buttons
  // - status indicators

  static TextStyle arcade({
    double fontSize = 12,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.pressStart2p(
      fontSize: fontSize,
      color: color,
      height: 1.6,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.3,
    );
  }

  // Large display text.
  static TextStyle display({
    double fontSize = 22,
    Color color = AppColors.neonGreen,
  }) {
    return GoogleFonts.pressStart2p(
      fontSize: fontSize,
      color: color,
      height: 1.5,
      fontWeight: FontWeight.normal,
    );
  }

  // Normal readable application text.
  static TextStyle body = GoogleFonts.roboto(
    fontSize: 15,
    color: AppColors.textPrimary,
    height: 1.55,
  );

  static TextStyle bodySecondary = GoogleFonts.roboto(
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodyMuted = GoogleFonts.roboto(
    fontSize: 12,
    color: AppColors.textMuted,
    height: 1.5,
  );
}