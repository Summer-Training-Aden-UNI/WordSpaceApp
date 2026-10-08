import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post.dart';
import 'feed_end_indicator.dart';
import 'post_card.dart';

class PostsFeedList extends StatefulWidget {
  const PostsFeedList({
    super.key,
    required this.posts,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onLikeTap,
    this.onPostTap,
    this.onCommentTap,
  });

  final List<Post> posts;
  final bool hasMore;
  final bool isLoadingMore;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final ValueChanged<Post> onLikeTap;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onCommentTap;

  @override
  State<PostsFeedList> createState() => _PostsFeedListState();
}

class _PostsFeedListState extends State<PostsFeedList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final p = _controller.position;
    if (p.pixels >= p.maxScrollExtent - 300) widget.onLoadMore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.brandEmerald,
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        itemCount: widget.posts.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.posts.length) {
            if (widget.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.brandEmerald,
                    strokeWidth: 3,
                  ),
                ),
              );
            }
            return widget.hasMore
                ? const SizedBox(height: 24)
                : const FeedEndIndicator();
          }

          final post = widget.posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PostCard(
              post: post,
              onLikeTap: () => widget.onLikeTap(post),
              onTap: widget.onPostTap == null
                  ? null
                  : () => widget.onPostTap!(post),
              onCommentTap: widget.onCommentTap == null
                  ? null
                  : () => widget.onCommentTap!(post),
            ),
          );
        },
      ),
    );
  }
}