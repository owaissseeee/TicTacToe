import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Toy-Pop Minimal Theme Definition
/// Based on the design tokens and specs from stitch_juicy_tictactoe_party_ui
class ToyPopTheme {
  // --- Brand & Player Colors ---
  // Player 1 (Candy Strawberry Red - 'X')
  static const Color primary = Color(0xFFFF3B69);
  static const Color primaryDark = Color(0xFF820C29);
  static const Color primaryContainer = Color(0xFFFFE6EB);
  static const Color primaryShadow = Color(0xFFFFB4C4);
  static const Color primaryBlush = Color(0xFFFF7597);

  // Player 2 (Pool Cyan - 'O')
  static const Color secondary = Color(0xFF00B8F0);
  static const Color secondaryDark = Color(0xFF005B77);
  static const Color secondaryContainer = Color(0xFFE0F7FE);
  static const Color secondaryShadow = Color(0xFFA8ECFF);

  // Accent / Tertiary (Sunny Yolk Yellow)
  static const Color accent = Color(0xFFFFC700);
  static const Color accentLight = Color(0xFFFFE47A);
  static const Color accentDark = Color(0xFF876500);
  static const Color accentDeepShadow = Color(0xFFB38A00);
  static const Color accentText = Color(0xFF4A3800);
  static const Color accentTextDark = Color(0xFF332600);

  // Mint (Active Party Dot)
  static const Color mint = Color(0xFF00D287);
  static const Color mintDark = Color(0xFF00A86B);

  // Neutral Background & Surfaces
  static const Color background = Color(0xFFFDF9F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF4EFE6);
  static const Color surfaceLow = Color(0xFFF7F3EA);
  static const Color surfaceContainerHigh = Color(0xFFECE8DF);
  static const Color border = Color(0xFFE7DECE);
  static const Color borderSubtle = Color(0xFFDDD4C5);
  static const Color neutralShadow = Color(0xFFD5CBC8);

  // Typography Colors (Deep Grape Jelly / Plum & Muted)
  static const Color onSurface = Color(0xFF2D2638);
  static const Color onSurfaceMuted = Color(0xFF8A8197);
  static const Color backdropScrim = Color(0x66231E17); // 40% #231e17

  // --- Common Dimensions & Radii ---
  static const double radiusSm = 12.0;
  static const double radiusMd = 20.0;
  static const double radiusLg = 28.0;
  static const double radiusPill = 999.0;

  // --- Typography Helpers ---
  // Rubik (Headlines, badges, button labels)
  static TextStyle rubik({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w800,
    Color color = onSurface,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.rubik(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Quicksand (Body, descriptions, subtitles)
  static TextStyle quicksand({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    Color color = onSurfaceMuted,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.quicksand(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // --- Tactile Toy Shadows ---
  static List<BoxShadow> toyShadow({
    required Color color,
    double offset = 4.0,
  }) {
    return [BoxShadow(color: color, offset: Offset(0, offset), blurRadius: 0)];
  }
}
