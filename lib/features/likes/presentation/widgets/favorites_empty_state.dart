
import 'package:flutter/material.dart';

class FavoritesEmptyState extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const FavoritesEmptyState({
    super.key,
    this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 34,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No saved stories yet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on any post to keep it handy for later.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: onExploreTap,
              child: const Text('Explore Community'),
            ),
          ],
        ),
      ),
    );
  }
}