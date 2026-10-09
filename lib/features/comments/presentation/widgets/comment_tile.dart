import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../posts/presentation/utils/time_ago.dart';
import '../../domain/entities/comment.dart';

/// One comment row: avatar, name, time, body and (for your own comments)
/// a delete button. It only draws — the parent decides what delete does.
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    this.canDelete = false,
    this.isDeleting = false,
    this.onDelete,
  });

  final Comment comment;
  final bool canDelete;
  final bool isDeleting;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final created = DateTime.tryParse(comment.createdAt ?? '')?.toLocal();

    return Opacity(
      opacity: isDeleting ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(name: comment.authorName, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          comment.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.labelLg(color: AppColors.slate),
                        ),
                      ),
                      if (created != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          timeAgo(created),
                        style: AppFonts.labelSm(color: AppColors.slateMuted),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.body,
                    style: AppFonts.bodyMd(color: AppColors.slateBody),
                  ),
                ],
              ),
            ),
            if (canDelete)
              isDeleting
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: AppColors.error,
                      tooltip: 'Delete comment',
                      visualDensity: VisualDensity.compact,
                    ),
          ],
        ),
      ),
    );
  }
}
