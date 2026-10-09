import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/widgets.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/welcome.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'features/posts/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;
import 'features/posts/presentation/pages/create_post_page.dart';

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
          // The key rebuilds the feed when a guest signs in, so the posts
          // are reloaded with the user's token (liked state, etc.).
          key: ValueKey(state.runtimeType),
          create: (_) => di.sl<PostsCubit>()..loadPosts(),
          child: HomePage(
            onNavTabSelected: (tab) {
              switch (tab) {
                case NavTab.home:
                  break;

                case NavTab.create:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreatePostPage()),
                  );
                  break;
                case NavTab.favorites:
                  // TODO: Navigate to FavoritesPage.
                  break;

                case NavTab.search:
                  // TODO: Navigate to SearchPage.
                  break;

                case NavTab.profile:
                  // TODO: Navigate to ProfilePage.
                  break;
              }
            },
            onAvatarTap: () {
              // TODO: Navigate to the user's profile.
            },
          ),
        ),
      },
    );
  }
}
