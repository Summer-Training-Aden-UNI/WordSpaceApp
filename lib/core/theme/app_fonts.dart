import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// WordSpace typography system.
///
/// Font: Plus Jakarta Sans
/// Source: Stitch "WordSpace Clean Modern Mobile".
abstract final class AppFonts {
  static const fontFamily = 'Plus Jakarta Sans';

  // ---------------------------------------------------------------------------
  // Raw text styles
  // ---------------------------------------------------------------------------

  static TextStyle headlineXl({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        letterSpacing: -0.02 * 30,
        color: color,
      );

  static TextStyle headlineLg({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: -0.015 * 24,
        color: color,
      );

  static TextStyle headlineMd({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: -0.01 * 20,
        color: color,
      );

  static TextStyle headlineSm({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 24 / 17,
        letterSpacing: -0.005 * 17,
        color: color,
      );

  static TextStyle bodyLg({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: color,
      );

  static TextStyle bodyMd({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 21 / 14,
        color: color,
      );

  static TextStyle bodySm({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 17 / 12,
        letterSpacing: 0.01 * 12,
        color: color,
      );

  static TextStyle labelLg({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.01 * 14,
        color: color,
      );

  static TextStyle labelMd({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.02 * 12,
        color: color,
      );

  static TextStyle labelSm({
    Color? color,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 14 / 10,
        letterSpacing: 0.04 * 10,
        color: color,
      );

  // ---------------------------------------------------------------------------
  // Material TextTheme
  // ---------------------------------------------------------------------------

  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: headlineXl(),
      displayMedium: headlineLg(),
      displaySmall: headlineMd(),
      headlineLarge: headlineLg(),
      headlineMedium: headlineMd(),
      headlineSmall: headlineSm(),
      titleLarge: headlineLg(),
      titleMedium: headlineMd(),
      titleSmall: headlineSm(),
      bodyLarge: bodyLg(),
      bodyMedium: bodyMd(),
      bodySmall: bodySm(),
      labelLarge: labelLg(),
      labelMedium: labelMd(),
      labelSmall: labelSm(),
    );
  }
}
