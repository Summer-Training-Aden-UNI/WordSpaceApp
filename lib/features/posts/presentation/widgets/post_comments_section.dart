
import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (commentsContent != null)
          commentsContent!
        else
          const Text(
            'Comments are not available yet.',
          ),
        if (commentComposer != null) ...[
          const SizedBox(height: 12),
          commentComposer!,
        ],
      ],
    );
  }
}
