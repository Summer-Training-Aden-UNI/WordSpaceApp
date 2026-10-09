
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/post.dart';
import '../cubit/post_details_cubit.dart';
import '../cubit/post_details_state.dart';
import '../widgets/post_author_card.dart';
import '../widgets/post_comments_section.dart';
import '../widgets/post_content.dart';
import '../widgets/post_engagement_bar.dart';

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({
    super.key,
    required this.post,
    this.userName,
    this.userImageUrl,
    this.onFollowTap,
    this.commentsContent,
    this.commentComposer,
  });

  final Post post;
  final String? userName;
  final String? userImageUrl;
  final VoidCallback? onFollowTap;
  final Widget? commentsContent;
  final Widget? commentComposer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostDetailsCubit(post),
      child: Scaffold(
        appBar: AppTopBar(
          title: 'Post Details',
          userName: userName,
          userImageUrl: userImageUrl,
        ),
        body: BlocBuilder<PostDetailsCubit, PostDetailsState>(
          builder: (context, state) {
            if (state is PostDetailsError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is! PostDetailsLoaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final currentPost = state.post;

            return SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  24,
                ),
                children: [
                  PostContent(post: currentPost),
                  const SizedBox(height: 18),
                  PostAuthorCard(
                    post: currentPost,
                    onFollowTap: onFollowTap,
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