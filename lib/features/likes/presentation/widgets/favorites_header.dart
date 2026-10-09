
import 'package:flutter/material.dart';

class FavoritesHeader extends StatelessWidget {
  final VoidCallback? onAvatarTap;

  const FavoritesHeader({
    super.key,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.96),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WordSpace',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  'FAVORITES',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onAvatarTap,
            tooltip: 'Profile',
            icon: Icon(
              Icons.account_circle_outlined,
              color: colors.onSurface,
              size: 29,
            ),
          ),
        ],
      ),
    );
  }
}