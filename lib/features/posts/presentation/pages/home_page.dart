import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/post.dart';
import '../cubit/posts_cubit.dart';
import '../widgets/posts_feed_list.dart';

/// Home / Posts feed.
///
/// Expects a [PostsCubit] to be provided above it (see the BlocProvider
/// example in the hand-off notes). It only wires Cubit <-> widgets; navigation
/// is delegated through callbacks so this page doesn't depend on the router.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.userName,
    this.userImageUrl,
    this.onAvatarTap,
    this.onPostTap,
    this.onCommentsTap,
    this.onNavTabSelected,
  });

  /// Current user, for the avatar in the top bar (no name = no avatar).
  final String? userName;
  final String? userImageUrl;

  final VoidCallback? onAvatarTap;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onCommentsTap;
  final ValueChanged<NavTab>? onNavTabSelected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostsCubit>();

    return Scaffold(
      appBar: AppTopBar(
        title: 'Home',
        userName: userName,
        userImageUrl: userImageUrl,
        onAvatarTap: onAvatarTap,
      ),
      body: BlocConsumer<PostsCubit, PostsState>(
        // Show a snackbar once per failed like / follow / refresh.
        listenWhen: (prev, curr) =>
            curr is PostsLoaded &&
            curr.actionError != null &&
            (prev is! PostsLoaded || prev.actionError != curr.actionError),
        listener: (context, state) {
          if (state is PostsLoaded && state.actionError != null) {
            AppSnackBar.error(context, state.actionError!);
          }
        },
        builder: (context, state) => switch (state) {
          PostsInitial() || PostsLoading() => const LoadingIndicator(),
          PostsError(:final message) => ErrorView(
              message: message,
              onRetry: cubit.loadPosts,
            ),
          PostsLoaded(:final posts, :final followInProgress) => posts.isEmpty
              ? EmptyState(
                  title: 'No posts yet',
                  message: 'New posts will show up here.',
                  icon: Icons.article_outlined,
                  actionLabel: 'Refresh',
                  onAction: cubit.loadPosts,
                )
              : PostsFeedList(
                  posts: posts,
                  followInProgress: followInProgress,
                  onRefresh: cubit.refresh,
                  onLikeTap: (post) => cubit.toggleLike(post.id),
                  onFollowTap: (post) => cubit.toggleFollow(post.author.id),
                  onPostTap: onPostTap,
                  onCommentTap: onCommentsTap,
                ),
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentTab: NavTab.home,
        onTabSelected: onNavTabSelected ?? (_) {},
      ),
    );
  }
}