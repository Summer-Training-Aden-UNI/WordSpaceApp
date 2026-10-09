import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../domain/entities/post.dart';
import '../cubit/posts_cubit.dart';

class PostEngagementBar extends StatelessWidget {
  const PostEngagementBar({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.read<PostsCubit>().toggleLike(post.id);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Icon(
                    post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: post.isLiked
                        ? AppColors.error
                        : AppColors.slateMuted,
                    size: 23,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${post.likeCount}',
                    style: AppFonts.labelMd(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          const Icon(
            Icons.mode_comment_outlined,
            color: AppColors.slateMuted,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            '${post.commentCount}',
            style: AppFonts.labelMd(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}