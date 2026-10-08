import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum AppButtonVariant { primary, outlined }

/// Shared button. Colors, radius and text style come from [AppTheme]
/// (elevatedButtonTheme / outlinedButtonTheme).
///
/// NOTE: the theme gives buttons `minimumSize: Size(double.infinity, 48)`,
/// so a raw button inside a Row crashes with an unbounded-width error.
/// Use `fullWidth: false` for buttons that sit next to other widgets.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true, required IconData trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;

    final Widget content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isPrimary ? Colors.white : AppColors.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(label, overflow: TextOverflow.ellipsis),
              ),
            ],
          );

    // While loading we ignore taps but keep the enabled look
    // (a disabled button would turn grey behind the spinner).
    final VoidCallback? handler = isLoading ? () {} : onPressed;

    final ButtonStyle? style = fullWidth
        ? null
        : const ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(0, 48)),
          );

    return isPrimary
        ? ElevatedButton(onPressed: handler, style: style, child: content)
        : OutlinedButton(onPressed: handler, style: style, child: content);
  }
}
