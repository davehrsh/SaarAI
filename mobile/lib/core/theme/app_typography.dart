import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle arcade({
    double fontSize = 12,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.pressStart2p(
      fontSize: fontSize,
      color: color,
      height: 1.5,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle body = GoogleFonts.roboto(
    fontSize: 15,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySecondary = GoogleFonts.roboto(
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.5,
  );
}