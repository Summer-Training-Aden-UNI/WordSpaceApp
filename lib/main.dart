import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as di;
import 'features/posts/presentation/pages/home_page.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(
    BlocProvider<PostsCubit>(
      create: (_) => di.sl<PostsCubit>()..loadPosts(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    ),
  );
}
