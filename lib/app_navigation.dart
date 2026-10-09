import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/comments/presentation/widgets/comments_section.dart';
import 'core/widgets/coming_soon_page.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/posts/domain/entities/post.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'features/posts/presentation/pages/post_details_page.dart';

/// The ONLY place that opens Post Details. [context] must be under the
/// PostsCubit provider (use homeContext from main.dart).
Future<void> openPostDetails(BuildContext context, Post post) {
  final postsCubit = context.read<PostsCubit>();
  final auth = context.read<AuthCubit>().state;
  final user = auth is AuthAuthenticated ? auth.user : null;

  return Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider<PostsCubit>.value(
        value: postsCubit,
        child: PostDetailsPage(
          post: post,
          userName: user?.name,
          commentsContent: CommentsSection(
            postId: post.id,
            currentUserId: user?.id,
            currentUserName: user?.name,
            initialCount: post.commentCount,
          ),
        ),
      ),
    ),
  );
}

/// The ONLY place that opens a profile. Placeholder until the page exists.
void openProfile(BuildContext context, int userId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ComingSoonPage(title: 'Profile')),
  );
}

/// Opens the logged-in user's own profile (id 0 for guests for now).
void openMyProfile(BuildContext context) {
  final state = context.read<AuthCubit>().state;
  openProfile(context, state is AuthAuthenticated ? state.user.id : 0);
}

/// A guest wants to sign in: close every pushed screen, then show Welcome.
void signInFromGuest(BuildContext context) {
  final auth = context.read<AuthCubit>();
  Navigator.of(context).popUntil((route) => route.isFirst);
  auth.leaveGuest();
}