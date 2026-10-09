import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../domain/entities/post.dart';
import 'post_cover_image.dart';

class PostContent extends StatelessWidget {
  const PostContent({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (post.tag?.trim().isNotEmpty == true)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      post.tag!,
                      style: AppFonts.labelMd(color: AppColors.primary),
                    ),
                  ),
                ),
              )
            else
              const Spacer(),
            const Icon(
              Icons.schedule_outlined,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 5),
            Text(
              '${post.readTimeMinutes} min read',
              style: AppFonts.labelSm(color: AppColors.slateMuted),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          post.title,
          style: AppFonts.headlineLg(color: AppColors.onSurface),
        ),
        const SizedBox(height: 18),
        if (post.coverImageUrl?.trim().isNotEmpty == true)
          PostCoverImage(
            imageUrl: post.coverImageUrl!,
            readTimeMinutes: post.readTimeMinutes,
            isFeatured: post.isFeatured,
          ),
        const SizedBox(height: 20),
        Text(
          post.body.trim().isNotEmpty ? post.body : post.excerpt,
          style: AppFonts.bodyLg(color: AppColors.onSurface),
        ),
      ],
    );
  }
}
