import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_navigation.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/widgets.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/welcome.dart';
import 'features/likes/presentation/cubit/favorites_cubit.dart';
import 'features/likes/presentation/pages/favorites_page.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'features/posts/presentation/pages/create_post_page.dart';
import 'features/posts/presentation/pages/home_page.dart';
import 'features/search/presentation/pages/search_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<AuthCubit>()..checkSession(),
      child: MaterialApp(
        title: 'WordSpace',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => switch (state) {
        AuthInitial() => const Scaffold(body: LoadingIndicator()),

        AuthUnauthenticated() => const WelcomePage(),

        AuthAuthenticated() || AuthGuest() => BlocProvider(
            // Rebuild the feed when the user changes from guest to signed in.
            key: ValueKey(state.runtimeType),
            create: (_) => di.sl<PostsCubit>()..loadPosts(),
            child: Builder(
              builder: (homeContext) => HomePage(
                onPostTap: (post) => openPostDetails(homeContext, post),
                onCommentsTap: (post) => openPostDetails(homeContext, post),
                onAvatarTap: () => openMyProfile(homeContext),
                onNavTabSelected: (tab) {
                  switch (tab) {
                    case NavTab.home:
                      break; // Already on HomePage.

                    case NavTab.create:
                      _openCreatePost(homeContext);

                    case NavTab.favorites:
                      _openFavorites(homeContext);

                    case NavTab.search:
                      _openSearch(
                        homeContext,
                        // Search sits directly on top of Home.
                        onHomeTap: (searchContext) =>
                            Navigator.pop(searchContext),
                      );

                    case NavTab.profile:
                      openMyProfile(homeContext);
                  }
                },
              ),
            ),
          ),
      },
    );
  }
}

Future<void> _openCreatePost(BuildContext homeContext) async {
  final created = await Navigator.push<Object?>(
    homeContext,
    MaterialPageRoute(builder: (_) => const CreatePostPage()),
  );

  // The page returns the new post when it was saved.
  if (created != null && homeContext.mounted) {
    homeContext.read<PostsCubit>().refresh();
  }
}

/// Search page. [onHomeTap] decides how "Home" closes the stack, because
/// Search can sit on Home or on top of Favorites.
void _openSearch(
  BuildContext homeContext, {
  required void Function(BuildContext searchContext) onHomeTap,
}) {
  Navigator.push(
    homeContext,
    MaterialPageRoute(
      builder: (searchContext) => SearchPage(
        onPostTap: (post) => openPostDetails(homeContext, post),
        onCommentTap: (post) => openPostDetails(homeContext, post),
        onNavTabSelected: (tab) {
          switch (tab) {
            case NavTab.home:
              onHomeTap(searchContext);

            case NavTab.create:
              _openCreatePost(homeContext);

            case NavTab.search:
            case NavTab.favorites:
              break;

            case NavTab.profile:
              openMyProfile(homeContext);
          }
        },
      ),
    ),
  );
}

void _openFavorites(BuildContext homeContext) {
  final postsCubit = homeContext.read<PostsCubit>();

  Navigator.push(
    homeContext,
    MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<PostsCubit>.value(value: postsCubit),
          BlocProvider<FavoritesCubit>(
            create: (_) => FavoritesCubit(
              postsCubit: postsCubit,
              getLikedPosts: di.sl(),
              likePost: di.sl(),
              unlikePost: di.sl(),
            )..load(),
          ),
        ],
        child: FavoritesPage(
          onSignInTap: () => signInFromGuest(homeContext),
          onPostTap: (post) => openPostDetails(homeContext, post),
          onAvatarTap: () => openMyProfile(homeContext),
          onNavTabSelected: (tab) {
            switch (tab) {
              case NavTab.home:
                Navigator.pop(homeContext);

              case NavTab.create:
                _openCreatePost(homeContext);

              case NavTab.favorites:
                break; // Already on FavoritesPage.

              case NavTab.search:
                _openSearch(
                  homeContext,
                  // Search is on top of Favorites: close both to reach Home.
                  onHomeTap: (searchContext) {
                    Navigator.pop(searchContext);
                    Navigator.pop(homeContext);
                  },
                );

              case NavTab.profile:
                openMyProfile(homeContext);
            }
          },
        ),
      ),
    ),
  );
}