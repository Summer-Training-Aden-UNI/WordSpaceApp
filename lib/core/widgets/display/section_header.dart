import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

/// Title row with an optional leading icon and trailing action widget.
///
/// Used for section titles on Search ("Popular on WordSpace"),
/// Profile ("Account & Security"), Favorites, etc.
///
/// Usage:
/// ```dart
/// SectionHeader(
///   title: 'Popular on WordSpace',
///   icon: Icons.verified,
///   trailing: Text('3 Results'),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
  });

  final String title;

  /// Optional leading icon shown before the title.
  final IconData? icon;

  /// Optional widget on the right (e.g. a count label, "See all" button).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            title,
            style: AppFonts.labelLg(color: AppColors.onSurface),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
