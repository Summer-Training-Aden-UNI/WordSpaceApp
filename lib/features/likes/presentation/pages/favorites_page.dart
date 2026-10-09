import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../posts/domain/entities/post.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../widgets/favorites_empty_state.dart';
import '../widgets/favorites_post_list.dart';
import '../widgets/favorites_sign_in_prompt.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.onNavTabSelected,
    this.userName,
    this.userImageUrl,
    this.onAvatarTap,
    this.onPostTap,
    this.onSignInTap,
  });

  final ValueChanged<NavTab> onNavTabSelected;

  final String? userName;
  final String? userImageUrl;

  final VoidCallback? onAvatarTap;
  final Future<void> Function(Post post)? onPostTap;
  final VoidCallback? onSignInTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppTopBar(
        title: 'Favorites',
        userName: userName,
        userImageUrl: userImageUrl,
        onAvatarTap: onAvatarTap,
      ),
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
        listenWhen: (prev, curr) =>
            curr is FavoritesLoaded && curr.actionError != null,
        listener: (context, state) {
          if (state is FavoritesLoaded && state.actionError != null) {
            AppSnackBar.error(context, state.actionError!);
          }
        },
        builder: (context, state) {
          if (state is FavoritesInitial || state is FavoritesLoading) {
            return const LoadingIndicator();
          }

          if (state is FavoritesSignInRequired) {
            return FavoritesSignInPrompt(onSignInTap: onSignInTap);
          }

          if (state is FavoritesError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<FavoritesCubit>().load(),
            );
          }

          if (state is FavoritesLoaded) {
            if (state.posts.isEmpty) {
              return FavoritesEmptyState(
                onExploreTap: () => onNavTabSelected(NavTab.home),
              );
            }

            return FavoritesPostList(
              posts: state.posts,
              onPostTap: onPostTap == null
                  ? null
                  : (post) async {
                      await onPostTap!(post);
                      // Back from Post Details: the like may have changed.
                      if (context.mounted) {
                        context.read<FavoritesCubit>().load(silent: true);
                      }
                    },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentTab: NavTab.favorites,
        onTabSelected: onNavTabSelected,
      ),
    );
  }
}