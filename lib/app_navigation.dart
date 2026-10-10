import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_colors.dart';
import 'core/widgets/widgets.dart';
import 'features/posts/presentation/cubit/edit_post_cubit.dart';
import 'features/posts/presentation/pages/edit_post_page.dart';
import 'features/posts/domain/usecases/delete_post.dart';
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

// The ONLY place that opens Post Details. [context] must be under the
/// PostsCubit provider. [onChanged] runs after the post is deleted, so the
/// caller can refresh its own list.
Future<void> openPostDetails(
  BuildContext context,
  Post post, {
  VoidCallback? onChanged,
}) {
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
          userImageUrl: user?.avatarUrl,
          currentUserId: user?.id,
          onAuthorTap: () => openProfile(context, post.author.id),
          onEditTap: (current) =>
              _editPost(context, current, postsCubit, onChanged: onChanged),
          onDeleteTap: () =>
              _deletePost(context, post, postsCubit, onChanged: onChanged),
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
/// Confirm -> delete -> remove from the feed -> close Post Details.
Future<void> _deletePost(
  BuildContext context,
  Post post,
  PostsCubit postsCubit, {
  VoidCallback? onChanged,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete this post?'),
      content: const Text('This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text(
            'Delete',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  // Blocks the screen while the request runs (no accidental second tap).
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  final result = await di.sl<DeletePost>()(DeletePostParams(id: post.id));
  if (!context.mounted) return;
  Navigator.pop(context); // closes the spinner

  result.fold(
    (failure) => AppSnackBar.error(context, failure.message),
    (_) {
      postsCubit.removePost(post.id);
      onChanged?.call();
      Navigator.pop(context); // closes Post Details
      AppSnackBar.show(context, 'Post deleted');
    },
  );
}
/// Opens the editor, then updates the feed (or removes the post if it was
/// switched to Draft). Returns the result so Post Details can refresh itself.
Future<EditPostResult?> _editPost(
  BuildContext context,
  Post current,
  PostsCubit postsCubit, {
  VoidCallback? onChanged,
}) async {
  final result = await Navigator.push<EditPostResult>(
    context,
    MaterialPageRoute(builder: (_) => EditPostPage(post: current)),
  );
  if (result == null) return null;

  onChanged?.call();

  if (result.isDraft) {
    // A draft is not public: it leaves the feed and Post Details closes.
    postsCubit.removePost(current.id);
    if (context.mounted) {
      Navigator.pop(context);
      AppSnackBar.show(context, 'Saved as a draft. It is no longer public.');
    }
    return null;
  }

  postsCubit.syncPost(result.post);
  if (context.mounted) AppSnackBar.show(context, 'Post updated');
  return result;
}

/// Builds the cubit behind a profile page (mine or someone else's).
ProfileCubit createProfileCubit({
  required int userId,
  required bool isMe,
  required PostsCubit postsCubit,
}) =>
    ProfileCubit(
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
    );

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
            create: (_) => createProfileCubit(
              userId: userId,
              isMe: isMe,
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
            onPostTap: (post) => openPostDetails(
              profileContext,
              post,
              onChanged: () =>
                  profileContext.read<ProfileCubit>().load(silent: true),
            ),
            onCommentTap: (post) => openPostDetails(
              profileContext,
              post,
              onChanged: () =>
                  profileContext.read<ProfileCubit>().load(silent: true),
            ),
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
           onSaved: (name, username, avatarUrl) => auth.updateUser(
            name: name,
            username: username,
            avatarUrl: avatarUrl,
          ),
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