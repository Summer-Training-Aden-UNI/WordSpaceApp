import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

/// One place for toast-style messages.
///   AppSnackBar.show(context, 'Post created');
///   AppSnackBar.error(context, failure.message);
abstract final class AppSnackBar {
   static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: AppFonts.bodyMd(color: Colors.white)),
          backgroundColor: isError ? AppColors.error : AppColors.slate,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: actionLabel == null ? 4 : 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: actionLabel == null
              ? null
              : SnackBarAction(
                  label: actionLabel,
                  textColor: Colors.white,
                  onPressed: onAction ?? () {},
                ),
        ),
      );
  }

  static void error(BuildContext context, String message) =>
      show(context, message, isError: true);
}
