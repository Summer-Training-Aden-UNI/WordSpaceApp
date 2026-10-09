
import 'package:flutter/material.dart';

import '../../../posts/domain/entities/post.dart';

class FavoritePostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLikeTap;
  final VoidCallback? onReadTap;
  final VoidCallback? onFollowTap;

  const FavoritePostCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    this.onReadTap,
    this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final author = post.author;
    final imageUrl = post.coverImageUrl;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author, reading time, follow, and favorite actions.
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${post.readTimeMinutes} min read',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                TextButton.icon(
                  onPressed: onFollowTap,
                  style: TextButton.styleFrom(
                    backgroundColor: author.isFollowing
                        ? colors.surfaceContainerHigh
                        : colors.primaryFixed,
                    foregroundColor: author.isFollowing
                        ? colors.onSurfaceVariant
                        : colors.onPrimaryFixed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    author.isFollowing
                        ? Icons.check_rounded
                        : Icons.add_rounded,
                    size: 16,
                  ),
                  label: Text(
                    author.isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Material(
                  color: colors.errorContainer.withValues(alpha: 0.65),
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: onLikeTap,
                    tooltip: 'Remove from favorites',
                    constraints: const BoxConstraints.tightFor(
                      width: 36,
                      height: 36,
                    ),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: colors.error,
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Post title.
            Text(
              post.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    letterSpacing: -0.3,
                  ),
            ),

            const SizedBox(height: 7),

            // Post excerpt.
            Text(
              post.excerpt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),

            // Cover image from the API.
            if (imageUrl != null && imageUrl.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 176,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder(colors),
                ),
              ),
            ],

            const SizedBox(height: 14),

            // Likes, comments, and Read action.
            Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 18,
                  color: colors.error,
                ),
                const SizedBox(width: 5),
                Text(
                  '${post.likeCount}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.error,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 18),
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 5),
                Text(
                  '${post.commentCount}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onReadTap,
                  style: TextButton.styleFrom(
                    backgroundColor: colors.surfaceContainerHigh,
                    foregroundColor: colors.onSurface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  label: const Text('Read'),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme colors) {
    return Container(
      width: double.infinity,
      height: 176,
      color: colors.surfaceContainerHigh,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colors.onSurfaceVariant,
        size: 32,
      ),
    );
  }
}