import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

/// Shown to guests, who have no favorites because they can't like posts.
class FavoritesSignInPrompt extends StatelessWidget {
  final VoidCallback? onSignInTap;

  const FavoritesSignInPrompt({super.key, this.onSignInTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 34,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Sign in to see your favorites',
              textAlign: TextAlign.center,
              style: AppFonts.headlineSm(color: AppColors.slate),
            ),
            const SizedBox(height: 8),
            Text(
              'Like posts to save them here and find them again later.',
              textAlign: TextAlign.center,
              style: AppFonts.bodyMd(color: AppColors.slateBody),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: onSignInTap,
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}