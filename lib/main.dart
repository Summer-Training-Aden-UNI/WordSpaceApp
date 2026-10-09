
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_navigation.dart';
import 'core/widgets/coming_soon_page.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/widgets.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/welcome.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'features/posts/presentation/pages/home_page.dart';
import 'features/posts/presentation/pages/create_post_page.dart';
import 'features/likes/presentation/cubit/favorites_cubit.dart';
import 'features/likes/presentation/pages/favorites_page.dart';
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
        AuthInitial() => const Scaffold(
            body: LoadingIndicator(),
          ),

        AuthUnauthenticated() => const WelcomePage(),

        AuthAuthenticated() || AuthGuest() => BlocProvider(
            // Rebuild the feed when the user changes from guest to signed in.
            key: ValueKey(state.runtimeType),
            create: (_) => di.sl<PostsCubit>()..loadPosts(),
            child: Builder(
              builder: (homeContext) {
                return HomePage(
                   onPostTap: (post) => openPostDetails(homeContext, post),
                        onCommentsTap: (post) => openPostDetails(homeContext, post),
                  onNavTabSelected: (tab) {
                    switch (tab) {
                      case NavTab.home:
                        // Already on HomePage.
                        break;

                      case NavTab.create:
                        Navigator.push(
                          homeContext,
                          MaterialPageRoute(
                            builder: (_) => const CreatePostPage(),
                          ),
                        );
                        break;

                      case NavTab.favorites:
                        final postsCubit =
                            homeContext.read<PostsCubit>();

                        Navigator.push(
                          homeContext,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider<PostsCubit>.value(
                                  value: postsCubit,
                                ),
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
                                onNavTabSelected: (favoritesTab) {
                                  switch (favoritesTab) {
                                    case NavTab.home:
                                      Navigator.pop(homeContext);
                                      break;

                                    case NavTab.create:
                                      Navigator.push(
                                        homeContext,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const CreatePostPage(),
                                        ),
                                      );
                                      break;

                                    case NavTab.favorites:
                                      // Already on FavoritesPage.
                                      break;

                                    case NavTab.search:
                                      Navigator.push(
                                        homeContext,
                                        MaterialPageRoute(
                                          builder: (searchContext) =>
                                              SearchPage(
                                                onPostTap: (post) =>
                                                openPostDetails(
                                                  homeContext,
                                                  post,
                                                ),
                                            onCommentTap: (post) =>
                                                openPostDetails(
                                                  homeContext,
                                                  post,
                                                ),
                                            onNavTabSelected: (searchTab) {
                                              switch (searchTab) {
                                                case NavTab.home:
                                                  Navigator.pop(
                                                    searchContext,
                                                  );
                                                  Navigator.pop(
                                                    homeContext,
                                                  );
                                                  break;

                                                case NavTab.create:
                                                  Navigator.push(
                                                    searchContext,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const CreatePostPage(),
                                                    ),
                                                  );
                                                  break;

                                                case NavTab.search:
                                                case NavTab.favorites:
                                                  break;

                                                case NavTab.profile:
                                                  openMyProfile(homeContext);
                                                  break;
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                      break;

                                    case NavTab.profile:
                                       openMyProfile(homeContext);
                                  }
                                },
                                 onAvatarTap: () => openMyProfile(homeContext),
                              ),
                            ),
                          ),
                        );
                        break;

                      case NavTab.search:
                        Navigator.push(
                          homeContext,
                          MaterialPageRoute(
                            builder: (searchContext) => SearchPage(
                              onPostTap: (post) =>
                                  openPostDetails(homeContext, post),
                              onCommentTap: (post) =>
                                  openPostDetails(homeContext, post),
                              onNavTabSelected: (searchTab) {
                                switch (searchTab) {
                                  case NavTab.home:
                                    Navigator.pop(searchContext);
                                    break;

                                  case NavTab.create:
                                    Navigator.push(
                                      searchContext,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CreatePostPage(),
                                      ),
                                    );
                                    break;

                                  case NavTab.search:
                                  case NavTab.favorites:
                                    break;

                                  case NavTab.profile:
                                    openMyProfile(homeContext);
                                    break;
                                }
                              },
                            ),
                          ),
                        );
                        break;

                      case NavTab.profile:
                          openMyProfile(homeContext);
                        break;
                    }
                  },
                  onAvatarTap: () => openMyProfile(homeContext),
                );
              },
            ),
          ),
      },
    );
  }
}