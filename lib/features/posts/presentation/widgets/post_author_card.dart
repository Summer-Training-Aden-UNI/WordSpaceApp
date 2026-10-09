import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../domain/entities/post.dart';

class PostAuthorCard extends StatelessWidget {
  const PostAuthorCard({
    super.key,
    required this.post,
    this.onFollowTap,
  });

  final Post post;
  final VoidCallback? onFollowTap;

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.isNegative) return 'Recently published';
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }

    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final author = post.author;
    final hasAvatar = author.avatarUrl?.trim().isNotEmpty == true;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundImage:
                hasAvatar ? NetworkImage(author.avatarUrl!) : null,
            child: hasAvatar
                ? null
                : Text(
                    author.name.isEmpty
                        ? '?'
                        : author.name[0].toUpperCase(),
                    style: AppFonts.headlineSm(
                      color: AppColors.primary,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.headlineSm(
                    color: AppColors.onSurface,
                  ),
                ),
                if (author.headline?.isNotEmpty == true)
                  Text(
                    author.headline!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.bodySm(
                      color: AppColors.slateMuted,
                    ),
                  ),
                Text(
                  _formatDate(post.publishedAt),
                  style: AppFonts.bodySm(
                    color: AppColors.slateMuted,
                  ),
                ),
              ],
            ),
          ),
          if (onFollowTap != null)
            TextButton(
              onPressed: onFollowTap,
              child: const Text('Follow'),
            ),
        ],
      ),
    );
  }
}