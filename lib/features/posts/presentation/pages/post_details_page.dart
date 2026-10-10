import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/post.dart';
import '../cubit/edit_post_cubit.dart';
import '../cubit/post_details_cubit.dart';
import '../cubit/post_details_state.dart';
import '../widgets/post_author_card.dart';
import '../widgets/post_comments_section.dart';
import '../widgets/post_content.dart';
import '../widgets/post_engagement_bar.dart';
import '../widgets/post_owner_menu.dart';

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({
    super.key,
    required this.post,
    this.userName,
    this.userImageUrl,
    this.currentUserId,
    this.onFollowTap,
    this.onAuthorTap,
    this.onEditTap,
    this.onDeleteTap,
    this.commentsContent,
    this.commentComposer,
  });

  final Post post;
  final String? userName;
  final String? userImageUrl;

  /// The signed-in user. The Edit / Delete menu only shows on their posts.
  final int? currentUserId;
  final VoidCallback? onFollowTap;

  /// Opens the author's profile.
  final VoidCallback? onAuthorTap;

  /// Opens the editor with the post as it is now. Returns the saved result
  /// (null if cancelled), which this page then shows.
  final Future<EditPostResult?> Function(Post current)? onEditTap;
  final VoidCallback? onDeleteTap;
  final Widget? commentsContent;
  final Widget? commentComposer;

  Future<void> _edit(BuildContext context, Post current) async {
    final result = await onEditTap!(current);
    if (result == null || !context.mounted) return;
    context.read<PostDetailsCubit>().updatePost(result.post);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostDetailsCubit(post),
      child: Scaffold(
        appBar: AppTopBar(
          title: 'Post Details',
          showBack: true,
          userName: userName,
          userImageUrl: userImageUrl,
        ),
        body: BlocBuilder<PostDetailsCubit, PostDetailsState>(
          builder: (context, state) {
            if (state is PostDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is! PostDetailsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final currentPost = state.post;
            final isOwner =
                currentUserId != null && currentPost.author.id == currentUserId;

            return SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  if (isOwner && onDeleteTap != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: PostOwnerMenu(
                        onEdit: onEditTap == null
                            ? null
                            : () => _edit(context, currentPost),
                        onDelete: onDeleteTap!,
                      ),
                    )
                  else
                    const SizedBox(height: 8),
                  PostContent(post: currentPost),
                  const SizedBox(height: 18),
                  PostAuthorCard(
                    post: currentPost,
                    onFollowTap: onFollowTap,
                    onAuthorTap: onAuthorTap,
                  ),
                  const SizedBox(height: 24),
                  PostEngagementBar(post: currentPost),
                  const SizedBox(height: 28),
                  PostCommentsSection(
                    post: currentPost,
                    commentsContent: commentsContent,
                    commentComposer: commentComposer,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}