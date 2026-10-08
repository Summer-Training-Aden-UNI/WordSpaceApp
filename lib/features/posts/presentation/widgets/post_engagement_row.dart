import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Hairline divider + like / comment row at the bottom of a post card.
class PostEngagementRow extends StatelessWidget {
  const PostEngagementRow({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.onLikeTap,
    this.onCommentTap,
  });

  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final VoidCallback onLikeTap;
  final VoidCallback? onCommentTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              LikeButton(
                isLiked: isLiked,
                count: likeCount,
                onTap: onLikeTap,
              ),
              const SizedBox(width: 24),
              CommentButton(count: commentCount, onTap: onCommentTap),
            ],
          ),
        ),
      ],
    );
  }
}