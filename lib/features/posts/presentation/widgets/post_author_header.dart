import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/author.dart';
import '../utils/time_ago.dart';

/// Top row of a post card:
/// avatar · name + "role · 14d ago" · [FEATURED badge] · Follow button.
class PostAuthorHeader extends StatelessWidget {
  const PostAuthorHeader({
    super.key,
    required this.author,
    required this.publishedAt,
    required this.isFeatured,
    required this.isFollowLoading,
    required this.onFollowTap,
  });

  final Author author;
  final DateTime publishedAt;
  final bool isFeatured;
  final bool isFollowLoading;
  final VoidCallback onFollowTap;

  String get _subtitle {
    final time = timeAgo(publishedAt);
    final headline = author.headline;
    return (headline == null || headline.trim().isEmpty)
        ? time
        : '$headline · $time';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserAvatar(name: author.name, imageUrl: author.avatarUrl, size: 40),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                author.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.headlineSm(color: AppColors.slate),
              ),
              Text(
                _subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.bodySm(color: AppColors.slateMuted),
              ),
            ],
          ),
        ),
        if (isFeatured) ...[
          const SizedBox(width: 8),
          const _FeaturedBadge(),
        ],
        const SizedBox(width: 8),
        FollowButton(
          isFollowing: author.isFollowing,
          isLoading: isFollowLoading,
          onPressed: onFollowTap,
        ),
      ],
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const ShapeDecoration(
        color: AppColors.primary,
        shape: StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 14, color: AppColors.onPrimary),
          const SizedBox(width: 4),
          Text(
            'FEATURED',
            style: AppFonts.labelMd(color: AppColors.onPrimary),
          ),
        ],
      ),
    );
  }
}