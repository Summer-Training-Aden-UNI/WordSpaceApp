import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post.dart';
import 'feed_end_indicator.dart';
import 'post_card.dart';

/// Scrollable, pull-to-refresh list of [PostCard]s with the end-of-feed footer.
/// Pure UI: all actions come in as callbacks.
class PostsFeedList extends StatelessWidget {
  const PostsFeedList({
    super.key,
    required this.posts,
    required this.followInProgress,
    required this.onRefresh,
    required this.onLikeTap,
    required this.onFollowTap,
    this.onPostTap,
    this.onCommentTap,
  });

  final List<Post> posts;

  /// Author ids with a follow request in flight.
  final Set<String> followInProgress;

  final Future<void> Function() onRefresh;
  final ValueChanged<Post> onLikeTap;
  final ValueChanged<Post> onFollowTap;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onCommentTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.brandEmerald,
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == posts.length) return const FeedEndIndicator();

          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PostCard(
              post: post,
              isFollowLoading: followInProgress.contains(post.author.id),
              onLikeTap: () => onLikeTap(post),
              onFollowTap: () => onFollowTap(post),
              onTap: onPostTap == null ? null : () => onPostTap!(post),
              onCommentTap:
                  onCommentTap == null ? null : () => onCommentTap!(post),
            ),
          );
        },
      ),
    );
  }
}