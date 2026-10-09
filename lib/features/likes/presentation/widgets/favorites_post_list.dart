
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../posts/domain/entities/post.dart';
import '../../../posts/presentation/cubit/posts_cubit.dart';
import 'favorite_post_card.dart';

class FavoritesPostList extends StatelessWidget {
  final List<Post> posts;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onFollowTap;

  const FavoritesPostList({
    super.key,
    required this.posts,
    this.onPostTap,
    this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final post = posts[index];

        return FavoritePostCard(
          post: post,
          onLikeTap: () {
            context.read<PostsCubit>().toggleLike(post.id);
          },
          onReadTap: onPostTap == null
              ? null
              : () => onPostTap!(post),
          onFollowTap: onFollowTap == null
              ? null
              : () => onFollowTap!(post),
        );
      },
    );
  }
}