import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_navigation.dart';
import 'core/widgets/widgets.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/likes/presentation/cubit/favorites_cubit.dart';
import 'features/likes/presentation/pages/favorites_page.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'features/posts/presentation/pages/create_post_page.dart';
import 'features/posts/presentation/pages/home_page.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/profile/presentation/pages/guest_profile_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/search/presentation/pages/search_page.dart';
import 'injection_container.dart' as di;

/// The signed-in app: ONE bottom bar, and one body per tab.
/// Must sit under a PostsCubit provider (AuthGate provides it).
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state;
    final me = auth is AuthAuthenticated ? auth.user : null;

    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesCubit>(
          create: (ctx) => FavoritesCubit(
            postsCubit: ctx.read<PostsCubit>(),
            getLikedPosts: di.sl(),
            likePost: di.sl(),
            unlikePost: di.sl(),
          ),
        ),
        // Guests have no profile to load. Created when first used.
        if (me != null)
          BlocProvider<ProfileCubit>(
            create: (ctx) => createProfileCubit(
              userId: me.id,
              isMe: true,
              postsCubit: ctx.read<PostsCubit>(),
            ),
          ),
      ],
      child: const _ShellView(),
    );
  }
}

class _ShellView extends StatefulWidget {
  const _ShellView();

  @override
  State<_ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<_ShellView> {
  NavTab _tab = NavTab.home;

  /// Tabs are built the first time they are opened.
  final Set<NavTab> _opened = {NavTab.home};

  static const _bodies = [
    NavTab.home,
    NavTab.search,
    NavTab.favorites,
    NavTab.profile,
  ];

  bool get _signedIn => context.read<AuthCubit>().state is AuthAuthenticated;

  void _select(NavTab tab) {
    switch (tab) {
      case NavTab.create:
        _openCreatePost();
        return;
      case NavTab.favorites:
        // First visit shows the spinner; later visits refresh quietly.
        context.read<FavoritesCubit>().load(silent: _opened.contains(tab));
      case NavTab.profile:
        if (_signedIn) {
          context.read<ProfileCubit>().load(silent: _opened.contains(tab));
        }
      case NavTab.home:
      case NavTab.search:
        break;
    }
    setState(() {
      _tab = tab;
      _opened.add(tab);
    });
  }

  Future<void> _openCreatePost() async {
    final result = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostPage()),
    );
    if (!mounted) return;

    if (result is NavTab) {
      // The user left the form through the bottom bar: open that tab.
      _select(result);
    } else if (result != null) {
      // A post was saved (the page returns it): reload the feed.
      context.read<PostsCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Whoever is signed in: shown as the avatar in each top bar.
    final auth = context.watch<AuthCubit>().state;
    final user = auth is AuthAuthenticated ? auth.user : null;

    return PopScope(
      // Back from any other tab goes to Home first, then leaves the app.
      canPop: _tab == NavTab.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _tab = NavTab.home);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _bodies.indexOf(_tab),
          children: [
            HomePage(
              userName: user?.name,
              userImageUrl: user?.avatarUrl,
              onPostTap: (post) => openPostDetails(context, post),
              onCommentsTap: (post) => openPostDetails(context, post),
              onAvatarTap: () => _select(NavTab.profile),
            ),
            _opened.contains(NavTab.search)
                ? SearchPage(
                    userName: user?.name,
                    userImageUrl: user?.avatarUrl,
                    onAvatarTap: () => _select(NavTab.profile),
                    onPostTap: (post) => openPostDetails(context, post),
                    onCommentTap: (post) => openPostDetails(context, post),
                    // Searching for yourself opens the Profile tab.
                    onUserTap: (u) => u.id == user?.id
                        ? _select(NavTab.profile)
                        : openProfile(context, u.id),
                  )
                : const SizedBox.shrink(),
            _opened.contains(NavTab.favorites)
                ? FavoritesPage(
                    userName: user?.name,
                    userImageUrl: user?.avatarUrl,
                    onSignInTap: () => signInFromGuest(context),
                    onPostTap: (post) => openPostDetails(context, post),
                    onAvatarTap: () => _select(NavTab.profile),
                    onExploreTap: () => _select(NavTab.home),
                  )
                : const SizedBox.shrink(),
            _opened.contains(NavTab.profile)
                ? (user == null
                    ? GuestProfilePage(
                        showBack: false,
                        onSignInTap: () => signInFromGuest(context),
                      )
                    : ProfilePage(
                        showBack: false,
                        onEditTap: () => openEditProfile(context),
                        onPostTap: (post) => openPostDetails(
                          context,
                          post,
                          onChanged: () =>
                              context.read<ProfileCubit>().load(silent: true),
                        ),
                        onCommentTap: (post) => openPostDetails(
                          context,
                          post,
                          onChanged: () =>
                              context.read<ProfileCubit>().load(silent: true),
                        ),
                      ))
                : const SizedBox.shrink(),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentTab: _tab,
          onTabSelected: _select,
        ),
      ),
    );
  }
}