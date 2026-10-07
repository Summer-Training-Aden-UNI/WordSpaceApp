import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

/// Toggleable heart button with a like count.
///
/// Used on feed cards, post details, and author profile article listings.
/// The parent manages state — pass [isLiked], [count], and [onTap].
///
/// Usage:
/// ```dart
/// LikeButton(
///   isLiked: post.isLiked,
///   count: post.likeCount,
///   onTap: () => store.toggleLike(post.id),
/// )
/// ```
class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.isLiked,
    required this.count,
    required this.onTap,
    this.size = 20,
  });

  final bool isLiked;
  final int count;
  final VoidCallback onTap;

  /// Icon size. Defaults to 20.
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(end: isLiked ? 1.15 : 1.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: child,
            ),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: size,
              color: isLiked ? AppColors.error : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _formatCount(count),
            style: AppFonts.labelMd(
              color: isLiked ? AppColors.error : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) {
      final k = n / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}k';
    }
    return '$n';
  }
}
