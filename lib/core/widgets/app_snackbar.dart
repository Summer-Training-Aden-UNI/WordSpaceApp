import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// One place for toast-style messages.
///   AppSnackBar.show(context, 'Post created');
///   AppSnackBar.error(context, failure.message);
abstract final class AppSnackBar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: AppFonts.bodyMd(color: Colors.white)),
          backgroundColor: isError ? AppColors.error : AppColors.slate,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  static void error(BuildContext context, String message) =>
      show(context, message, isError: true);
}
