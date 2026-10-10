import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../injection_container.dart';
import '../../../follow/presentation/follow_store.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/presentation/widgets/post_card.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/profile_header.dart';

/// My profile or someone else's: the cubit (provided above) decides which.
/// Navigation is passed in as callbacks, like the other pages.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.currentUserName,
    this.onAvatarTap,
    this.onEditTap,
    this.onPostTap,
    this.onCommentTap,
  });

  /// Shows my avatar in the top bar (leave null on my own profile).
  final String? currentUserName;
  final VoidCallback? onAvatarTap;

  /// "Edit profile" button (my profile only).
  final VoidCallback? onEditTap;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onCommentTap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => curr.actionError != null,
      listener: (context, state) =>
          AppSnackBar.error(context, state.actionError!),
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppTopBar(
            title: 'Profile',
            showBack: true,
            userName: currentUserName,
            onAvatarTap: onAvatarTap,
          ),
          body: switch (state.status) {
            ProfileStatus.loading => const LoadingIndicator(),
            ProfileStatus.failure => ErrorView(
                message: state.errorMessage ?? 'Could not load this profile.',
                onRetry: cubit.load,
              ),
            ProfileStatus.success => _ProfileBody(
                state: state,
                onEditTap: onEditTap,
                onPostTap: onPostTap,
                onCommentTap: onCommentTap,
              ),
          },
        );
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.state,
    this.onEditTap,
    this.onPostTap,
    this.onCommentTap,
  });

  final ProfileState state;
  final VoidCallback? onEditTap;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onCommentTap;

  Future<void> _toggleFollow(
    BuildContext context,
    FollowStore store,
    String id,
  ) async {
    final failure = await store.toggle(id);
    if (failure != null && context.mounted) {
      AppSnackBar.error(
        context,
        failure is AuthFailure ? 'Sign in to follow people.' : failure.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final info = state.info!;
    final store = sl<FollowStore>();
    final id = info.id.toString();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => cubit.load(silent: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 300) cubit.loadMorePosts();
          return false;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              // Follow state lives in FollowStore: rebuild when it changes.
              child: ListenableBuilder(
                listenable: store,
                builder: (context, _) {
                  final following = store.isFollowing(id);

                  return ProfileHeader(
                    info: info,
                    followersCount: cubit.isMe
                        ? info.followersCount
                        : (store.followersCount(id) ?? info.followersCount),
                    action: cubit.isMe
                        ? ProfileActionButton(
                            label: 'Edit profile',
                            icon: Icons.edit_outlined,
                            style: ProfileActionStyle.neutral,
                            onPressed: onEditTap,
                          )
                        : ProfileActionButton(
                            label: following ? 'Following' : 'Follow',
                            icon: following
                                ? Icons.check
                                : Icons.person_add_alt_1,
                            style: following
                                ? ProfileActionStyle.neutral
                                : ProfileActionStyle.primary,
                            isLoading: store.isLoading(id),
                            onPressed: () => _toggleFollow(context, store, id),
                          ),
                  );
                },
              ),
            ),
            if (state.posts.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: state.postsError != null
                    ? EmptyState(
                        title: 'Could not load posts',
                        message: state.postsError,
                        icon: Icons.cloud_off_outlined,
                        actionLabel: 'Try again',
                        onAction: () => cubit.load(silent: true),
                      )
                    : EmptyState(
                        title: 'No posts yet',
                        message: cubit.isMe
                            ? 'Posts you publish will appear here.'
                            : 'This author has not published anything yet.',
                        icon: Icons.article_outlined,
                      ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.separated(
                  itemCount: state.posts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return PostCard(
                      post: post,
                      showAuthor: false,
                      onLikeTap: () => cubit.toggleLike(post),
                      onTap: onPostTap == null ? null : () => onPostTap!(post),
                      onCommentTap: onCommentTap == null
                          ? null
                          : () => onCommentTap!(post),
                    );
                  },
                ),
              ),
            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}