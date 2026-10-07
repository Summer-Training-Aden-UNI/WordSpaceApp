import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

/// Chat-bubble icon with a comment count.
///
/// Tappable to navigate to comments. Used alongside [LikeButton] in
/// engagement rows on feed cards, post details, and author profile.
///
/// Usage:
/// ```dart
/// CommentButton(
///   count: post.commentCount,
///   onTap: () => navigateToComments(post.id),
/// )
/// ```
class CommentButton extends StatelessWidget {
  const CommentButton({
    super.key,
    required this.count,
    this.onTap,
    this.size = 20,
  });

  final int count;
  final VoidCallback? onTap;

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
          Icon(
            Icons.chat_bubble_outline,
            size: size,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: AppFonts.labelMd(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
