import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../../follow/domain/entities/public_user.dart';
import '../../../follow/presentation/follow_store.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/presentation/widgets/post_card.dart';
import '../state/search_cubit.dart';
import '../state/search_state.dart';
import '../widgets/search_field.dart';
import '../widgets/search_tip_card.dart';
import '../widgets/search_user_tile.dart';

/// Search tab: a search box, then people and posts that match.
///
/// Navigation is passed in as callbacks so this page does not know about
/// the router (same idea as HomePage).
class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
    this.userName,
    this.userImageUrl,
    this.onAvatarTap,
    this.onPostTap,
    this.onCommentTap,
    this.onUserTap,
    this.onNavTabSelected,
  });

  final String? userName;
  final String? userImageUrl;
  final VoidCallback? onAvatarTap;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onCommentTap;
  final ValueChanged<PublicUser>? onUserTap;
  final ValueChanged<NavTab>? onNavTabSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // The one place where the service locator is used.
      create: (_) => SearchCubit(
        search: sl(),
        likePost: sl(),
        unlikePost: sl(),
      ),
      child: _SearchView(
        followStore: sl<FollowStore>(),
        userName: userName,
        userImageUrl: userImageUrl,
        onAvatarTap: onAvatarTap,
        onPostTap: onPostTap,
        onCommentTap: onCommentTap,
        onUserTap: onUserTap,
        onNavTabSelected: onNavTabSelected,
      ),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView({
    required this.followStore,
    this.userName,
    this.userImageUrl,
    this.onAvatarTap,
    this.onPostTap,
    this.onCommentTap,
    this.onUserTap,
    this.onNavTabSelected,
  });

  final FollowStore followStore;
  final String? userName;
  final String? userImageUrl;
  final VoidCallback? onAvatarTap;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onCommentTap;
  final ValueChanged<PublicUser>? onUserTap;
  final ValueChanged<NavTab>? onNavTabSelected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      appBar: AppTopBar(
        title: 'Search',
        userName: userName,
        userImageUrl: userImageUrl,
        onAvatarTap: onAvatarTap,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchField(
              onChanged: cubit.onQueryChanged,
              onSubmitted: cubit.submit,
              onClear: cubit.clear,
            ),
          ),
          Expanded(
            child: BlocConsumer<SearchCubit, SearchState>(
              // One snackbar per failed like / follow.
              listenWhen: (prev, curr) =>
                  curr.actionError != null &&
                  prev.actionError != curr.actionError,
              listener: (context, state) =>
                  AppSnackBar.error(context, state.actionError!),
              builder: (context, state) {
                if (state.status == SearchStatus.initial) {
                  return const _Hint();
                }
                if (state.status == SearchStatus.loading &&
                    !state.hasResults) {
                  return const LoadingIndicator();
                }
                if (state.status == SearchStatus.failure) {
                  return ErrorView(
                    message: state.errorMessage ??
                        'Search failed. Check your connection and try again.',
                    onRetry: cubit.retry,
                  );
                }
                if (state.status == SearchStatus.success &&
                    !state.hasResults) {
                  return _NoResults(query: state.query);
                }
                return _Results(
                  state: state,
                  followStore: followStore,
                  onPostTap: onPostTap,
                  onCommentTap: onCommentTap,
                  onUserTap: onUserTap,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentTab: NavTab.search,
        onTabSelected: onNavTabSelected ?? (_) {},
      ),
    );
  }
}

/// Before the user typed anything useful.
class _Hint extends StatelessWidget {
  const _Hint();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: EmptyState(
            title: 'Search WordSpace',
            message: 'Find posts and people. Type at least 2 characters.',
            icon: Icons.search,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SearchTipCard(),
        ),
      ],
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'No results for “$query”',
      message: 'Check the spelling or try different keywords.',
      icon: Icons.search_off,
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.state,
    required this.followStore,
    this.onPostTap,
    this.onCommentTap,
    this.onUserTap,
  });

  final SearchState state;
  final FollowStore followStore;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onCommentTap;
  final ValueChanged<PublicUser>? onUserTap;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        // New results are loading but the old ones stay visible.
        if (state.status == SearchStatus.loading)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: LinearProgressIndicator(
              minHeight: 2,
              color: AppColors.brandEmerald,
            ),
          ),

        if (state.users.isNotEmpty) ...[
          const _SectionTitle(icon: Icons.group_outlined, title: 'People'),
          const SizedBox(height: 4),
          for (final user in state.users)
            SearchUserTile(
              key: ValueKey('user-${user.id}'),
              user: user,
              onTap: onUserTap == null ? null : () => onUserTap!(user),
            ),
          const SizedBox(height: 16),
        ],

        if (state.posts.isNotEmpty) ...[
          _SectionTitle(
            icon: Icons.article_outlined,
            title: 'Posts',
            trailing:
                '${state.posts.length} results for “${state.query}”',
          ),
          const SizedBox(height: 12),
          for (final post in state.posts)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PostCard(
                key: ValueKey('post-${post.id}'),
                post: post,
                onLikeTap: () => cubit.toggleLike(post.id),
                onTap: onPostTap == null ? null : () => onPostTap!(post),
                onCommentTap: onCommentTap == null
                    ? null
                    : () => onCommentTap!(post),
              ),
            ),
        ],

        const SearchTipCard(),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.brandEmerald),
        const SizedBox(width: 8),
        Text(title, style: AppFonts.labelLg(color: AppColors.slate)),
        if (trailing != null) ...[
          const Spacer(),
          Flexible(
            child: Text(
              trailing!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.labelSm(color: AppColors.slateMuted),
            ),
          ),
        ],
      ],
    );
  }
}
