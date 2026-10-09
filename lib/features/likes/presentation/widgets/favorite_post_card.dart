import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/presentation/widgets/author_follow_button.dart';

class FavoritePostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLikeTap;
  final VoidCallback? onReadTap;

  const FavoritePostCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    this.onReadTap,
  });

  static final _radius = BorderRadius.circular(16);

  @override
  Widget build(BuildContext context) {
    final author = post.author;
    final imageUrl = post.coverImageUrl;
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: _radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: _radius,
        clipBehavior: Clip.antiAlias,
        // Same as Home: the whole card opens the post. The buttons inside
        // (follow, remove, read) handle their own taps.
        child: InkWell(
          onTap: onReadTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar, author, read time, follow and remove.
                Row(
                  children: [
                    UserAvatar(
                      name: author.name,
                      imageUrl: author.avatarUrl,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.headlineSm(color: AppColors.slate),
                          ),
                          Text(
                            '${post.readTimeMinutes} min read',
                            style: AppFonts.bodySm(
                              color: AppColors.slateMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AuthorFollowButton(
                      authorId: author.id,
                      initialIsFollowing: author.isFollowing,
                    ),
                    const SizedBox(width: 6),
                    Material(
                      color: AppColors.surfaceContainer,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: onLikeTap,
                        tooltip: 'Remove from favorites',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 32,
                          height: 32,
                        ),
                        icon: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.error,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  post.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.headlineMd(color: AppColors.slate),
                ),
                const SizedBox(height: 6),
                Text(
                  post.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.bodyMd(color: AppColors.slateBody),
                ),

                if (hasImage) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 176,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const _ImagePlaceholder(),
                          ),
                          // Dark fade at the bottom, like the design.
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color(0x99000000),
                                  Color(0x00000000),
                                ],
                                stops: [0, 0.6],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Likes, comments and the Read button.
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${post.likeCount}',
                      style: AppFonts.labelMd(color: AppColors.error),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 18,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${post.commentCount}',
                      style: AppFonts.labelMd(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    _ReadButton(onTap: onReadTap),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadButton extends StatelessWidget {
  const _ReadButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Read', style: AppFonts.labelSm(color: AppColors.onSurface)),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: AppColors.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerHigh,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.onSurfaceVariant,
        size: 32,
      ),
    );
  }
}