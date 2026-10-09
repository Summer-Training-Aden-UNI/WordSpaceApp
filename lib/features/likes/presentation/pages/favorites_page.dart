
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/presentation/cubit/posts_cubit.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../widgets/favorites_empty_state.dart';
import '../widgets/favorites_post_list.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.onNavTabSelected,
    this.userName,
    this.userImageUrl,
    this.onAvatarTap,
    this.onPostTap,
    this.onFollowTap,
  });

  final ValueChanged<NavTab> onNavTabSelected;

  final String? userName;
  final String? userImageUrl;

  final VoidCallback? onAvatarTap;
  final ValueChanged<Post>? onPostTap;
  final ValueChanged<Post>? onFollowTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // Reuse the same shared app bar as HomePage.
      appBar: AppTopBar(
        title: 'Favorites',
        userName: userName,
        userImageUrl: userImageUrl,
        onAvatarTap: onAvatarTap,
      ),

      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesInitial ||
              state is FavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is FavoritesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        context.read<PostsCubit>().refresh();
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FavoritesLoaded) {
            if (state.posts.isEmpty) {
              return FavoritesEmptyState(
                onExploreTap: () {
                  onNavTabSelected(NavTab.home);
                },
              );
            }

            return FavoritesPostList(
              posts: state.posts,
              onPostTap: onPostTap,
              onFollowTap: onFollowTap,
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