import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

/// A row / grid of numerical stats (Posts, Followers, Likes, etc.).
///
/// Used on the Profile and Author Profile pages.
///
/// Usage:
/// ```dart
/// StatsRow(
///   stats: [
///     StatItem(value: '24', label: 'Posts'),
///     StatItem(value: '1.2k', label: 'Followers'),
///     StatItem(value: '380', label: 'Likes'),
///   ],
/// )
/// ```
class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.stats,
  });

  final List<StatItem> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: stats.map((stat) {
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat.value,
                  style: AppFonts.headlineLg(color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  style: AppFonts.labelMd(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Single stat entry for [StatsRow].
class StatItem {
  const StatItem({required this.value, required this.label});

  /// Formatted value string (e.g. "24", "1.2k").
  final String value;

  /// Label below the value (e.g. "Posts", "Followers").
  final String label;
}
