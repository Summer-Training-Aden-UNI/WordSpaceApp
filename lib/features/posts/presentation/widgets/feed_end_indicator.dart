import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

/// "• YOU ARE UP TO DATE" footer shown after the last post.
class FeedEndIndicator extends StatelessWidget {
  const FeedEndIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'YOU ARE UP TO DATE',
              style: AppFonts.labelMd(color: AppColors.slateMuted)
                  .copyWith(letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}