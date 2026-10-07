import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../domain/entities/post.dart';
import 'post_author_header.dart';
import 'post_cover_image.dart';
import 'post_engagement_row.dart';

/// One card in the Home feed.
///
/// Stateless and unaware of the Cubit: the parent passes data and callbacks.
/// The featured variant has a green-tinted border, the FEATURED badge, a larger
/// title and a taller cover image.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.isFollowLoading,
    required this.onLikeTap,
    required this.onFollowTap,
    this.onTap,
    this.onCommentTap,
  });

  final Post post;
  final bool isFollowLoading;
  final VoidCallback onLikeTap;
  final VoidCallback onFollowTap;
  final VoidCallback? onTap;
  final VoidCallback? onCommentTap;

  static final _radius = BorderRadius.circular(16);

  @override
  Widget build(BuildContext context) {
    final featured = post.isFeatured;
    final coverUrl = post.coverImageUrl;
    final hasCover = coverUrl != null && coverUrl.trim().isNotEmpty;

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
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: _radius,
          side: featured
              ? BorderSide(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.6),
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: PostAuthorHeader(
                  author: post.author,
                  publishedAt: post.publishedAt,
                  isFeatured: featured,
                  isFollowLoading: isFollowLoading,
                  onFollowTap: onFollowTap,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  post.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: featured
                      ? AppFonts.headlineLg(color: AppColors.slate)
                      : AppFonts.headlineMd(color: AppColors.slate),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  post.excerpt,
                  maxLines: featured ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: featured
                      ? AppFonts.bodyLg(color: AppColors.slateBody)
                      : AppFonts.bodyMd(color: AppColors.slateBody),
                ),
              ),
              const SizedBox(height: 12),
              if (hasCover)
                PostCoverImage(
                  imageUrl: coverUrl,
                  readTimeMinutes: post.readTimeMinutes,
                  isFeatured: featured,
                  tag: post.tag,
                ),
              PostEngagementRow(
                isLiked: post.isLiked,
                likeCount: post.likeCount,
                commentCount: post.commentCount,
                onLikeTap: onLikeTap,
                onCommentTap: onCommentTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}