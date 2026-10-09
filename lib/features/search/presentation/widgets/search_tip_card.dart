import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

/// The small "tip" card at the bottom of the search screen.
///
/// The default text is generic on purpose. The design says to use "exact
/// quotes", so only use that text if the backend really supports it.
class SearchTipCard extends StatelessWidget {
  const SearchTipCard({
    super.key,
    this.title = 'Search tip',
    this.message =
        'Try a specific topic, a technology or an author\'s name for better results.',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.sageTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.brandEmerald,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppFonts.labelLg(color: AppColors.slate)),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: AppFonts.bodySm(color: AppColors.slateBody),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
