import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/comments/presentation/widgets/comments_section.dart';
import 'features/follow/presentation/follow_store.dart';
import 'features/posts/domain/entities/post.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'features/posts/presentation/pages/post_details_page.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/profile/presentation/pages/edit_profile_page.dart';
import 'features/profile/presentation/pages/guest_profile_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'injection_container.dart' as di;

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
            onCountChanged: (count) =>
                postsCubit.setCommentCount(post.id, count),
          ),
        ),
      ),
    ),
  );
}

/// The ONLY place that opens a profile: mine (editable) or someone else's.
/// [context] must be under the PostsCubit provider.
Future<void> openProfile(BuildContext context, int userId) {
  final auth = context.read<AuthCubit>().state;
  final me = auth is AuthAuthenticated ? auth.user : null;
  final isMe = me != null && me.id == userId;
  final postsCubit = context.read<PostsCubit>();

  return Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          // Pages opened from here (post details) read PostsCubit.
          BlocProvider<PostsCubit>.value(value: postsCubit),
          BlocProvider<ProfileCubit>(
            create: (_) => ProfileCubit(
              userId: userId,
              isMe: isMe,
              getProfile: di.sl(),
              getUser: di.sl(),
              getUserPosts: di.sl(),
              updateProfile: di.sl(),
              likePost: di.sl(),
              unlikePost: di.sl(),
              followStore: di.sl(),
              postsCubit: postsCubit,
            )..load(),
          ),
        ],
        child: Builder(
          builder: (profileContext) => ProfilePage(
            // Someone else's profile shows MY avatar in the top bar.
            currentUserName: isMe ? null : me?.name,
            onAvatarTap: () => openMyProfile(profileContext),
            onEditTap: () => openEditProfile(profileContext),
            onPostTap: (post) => openPostDetails(profileContext, post),
            onCommentTap: (post) => openPostDetails(profileContext, post),
          ),
        ),
      ),
    ),
  );
}

/// Opens the logged-in user's own profile. A guest gets a sign-in prompt.
Future<void> openMyProfile(BuildContext context) {
  final state = context.read<AuthCubit>().state;

  if (state is AuthAuthenticated) return openProfile(context, state.user.id);

  return Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (_) =>
          GuestProfilePage(onSignInTap: () => signInFromGuest(context)),
    ),
  );
}

/// Edit Profile. [context] must be under the ProfileCubit provider.
Future<void> openEditProfile(BuildContext context) {
  final cubit = context.read<ProfileCubit>();
  final auth = context.read<AuthCubit>();

  return Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider<ProfileCubit>.value(
        value: cubit,
        child: EditProfilePage(
          onSignOut: () => signOut(context),
          // Keeps the logged-in session in step with the new name.
          onSaved: (name, username) =>
              auth.updateUser(name: name, username: username),
        ),
      ),
    ),
  );
}

/// Sign out: close every pushed screen, then show Welcome.
Future<void> signOut(BuildContext context) async {
  final auth = context.read<AuthCubit>();
  di.sl<FollowStore>().clear();
  Navigator.of(context).popUntil((route) => route.isFirst);
  await auth.logout();
}

/// A guest wants to sign in: close every pushed screen, then show Welcome.
void signInFromGuest(BuildContext context) {
  final auth = context.read<AuthCubit>();
  Navigator.of(context).popUntil((route) => route.isFirst);
  auth.leaveGuest();
}