
import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

class PostCommentsSection extends StatelessWidget {
  const PostCommentsSection({
    super.key,
    required this.post,
    this.commentsContent,
    this.commentComposer,
  });

  final Post post;
  final Widget? commentsContent;
  final Widget? commentComposer;

  @override
  Widget build(BuildContext context) {
    // When real comments are plugged in, they draw their own header
    // (with a live count), so we only show ours for the placeholder.
    if (commentsContent != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commentsContent!,
          if (commentComposer != null) ...[
            const SizedBox(height: 12),
            commentComposer!,
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Comments',
              style: AppFonts.headlineMd(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${post.commentCount}',
              style: AppFonts.labelMd(
                color: AppColors.slateMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (commentsContent != null)
          commentsContent!
        else
          Text(
            'Comments are not available yet.',
            style: AppFonts.bodyMd(
              color: AppColors.slateMuted,
            ),
          ),
        if (commentComposer != null) ...[
          const SizedBox(height: 12),
          commentComposer!,
        ],
      ],
    );
  }
}
