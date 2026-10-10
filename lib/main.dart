import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/widgets.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/welcome.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'injection_container.dart' as di;
import 'main_shell.dart';

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
            child: const MainShell(),
          ),
      },
    );
  }
}