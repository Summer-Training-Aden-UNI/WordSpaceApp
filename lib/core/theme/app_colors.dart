import 'package:flutter/material.dart';

/// WordSpace design-system colors.
///
/// Source: Stitch "WordSpace Clean Modern Mobile".
/// The YAML design tokens are treated as the source of truth where they
/// differ from the descriptive prose below the token list.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------------
  static const surface = Color(0xFFF7F9FB);
  static const surfaceDim = Color(0xFFD8DADC);
  static const surfaceBright = Color(0xFFF7F9FB);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF2F4F6);
  static const surfaceContainer = Color(0xFFECEEF0);
  static const surfaceContainerHigh = Color(0xFFE6E8EA);
  static const surfaceContainerHighest = Color(0xFFE0E3E5);

  // ---------------------------------------------------------------------------
  // Text / content
  // ---------------------------------------------------------------------------
  static const onSurface = Color(0xFF191C1E);
  static const onSurfaceVariant = Color(0xFF3D4A42);
  static const inverseSurface = Color(0xFF2D3133);
  static const inverseOnSurface = Color(0xFFEFF1F3);

  // ---------------------------------------------------------------------------
  // Borders / outlines
  // ---------------------------------------------------------------------------
  static const outline = Color(0xFF6D7A72);
  static const outlineVariant = Color(0xFFBCCAC0);

  // ---------------------------------------------------------------------------
  // Primary
  // ---------------------------------------------------------------------------
  static const primary = Color(0xFF006948);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF00855D);
  static const onPrimaryContainer = Color(0xFFF5FFF7);
  static const inversePrimary = Color(0xFF68DBA9);
  static const primaryFixed = Color(0xFF85F8C4);
  static const primaryFixedDim = Color(0xFF68DBA9);
  static const onPrimaryFixed = Color(0xFF002114);
  static const onPrimaryFixedVariant = Color(0xFF005137);

  // ---------------------------------------------------------------------------
  // Secondary
  // ---------------------------------------------------------------------------
  static const secondary = Color(0xFF565E74);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFDAE2FD);
  static const onSecondaryContainer = Color(0xFF5C647A);
  static const secondaryFixed = Color(0xFFDAE2FD);
  static const secondaryFixedDim = Color(0xFFBEC6E0);
  static const onSecondaryFixed = Color(0xFF131B2E);
  static const onSecondaryFixedVariant = Color(0xFF3F465C);

  // ---------------------------------------------------------------------------
  // Tertiary
  // ---------------------------------------------------------------------------
  static const tertiary = Color(0xFF006947);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF00855B);
  static const onTertiaryContainer = Color(0xFFF5FFF6);
  static const tertiaryFixed = Color(0xFF6FFBBE);
  static const tertiaryFixedDim = Color(0xFF4EDEA3);
  static const onTertiaryFixed = Color(0xFF002113);
  static const onTertiaryFixedVariant = Color(0xFF005236);

  // ---------------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------------
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // ---------------------------------------------------------------------------
  // Extra brand/design colors from Stitch's descriptive section.
  // Keep these available for UI details that explicitly use those values.
  // ---------------------------------------------------------------------------
  static const brandEmerald = Color(0xFF059669);
  static const brandEmeraldDark = Color(0xFF047857);
  static const slate = Color(0xFF0F172A);
  static const slateMuted = Color(0xFF64748B);
  static const slateBody = Color(0xFF475569);
  static const placeholder = Color(0xFF94A3B8);
  static const borderLight = Color(0xFFE2E8F0);
  static const sageTint = Color(0xFFECFDF5);

  // Focus glow: use with BoxShadow, not as a normal fill.
  static const focusGlow = Color(0x1F059669);
}
