import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

enum ProfileActionStyle { primary, neutral }

/// Full-width button from the design: green "Follow", grey "Following" and
/// grey "Edit profile".
class ProfileActionButton extends StatelessWidget {
  const ProfileActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.style = ProfileActionStyle.primary,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final ProfileActionStyle style;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final primary = style == ProfileActionStyle.primary;
    final background = primary ? AppColors.primary : AppColors.surfaceContainer;
    final foreground = primary ? AppColors.onPrimary : AppColors.onSurface;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: foreground,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 19, color: foreground),
                      const SizedBox(width: 8),
                      Text(label, style: AppFonts.labelLg(color: foreground)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}