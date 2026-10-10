import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../follow/presentation/follow_store.dart';

/// Follow / Following pill for a post author. It only DRAWS the shared
/// [FollowStore] state, so every card, list and profile agrees.
/// Not optimistic: shows a spinner while the request runs.
class AuthorFollowButton extends StatefulWidget {
  const AuthorFollowButton({
    super.key,
    required this.authorId,
    required this.initialIsFollowing,
  });

  final int authorId;

  /// What the server said when this post was loaded.
  final bool initialIsFollowing;

  @override
  State<AuthorFollowButton> createState() => _AuthorFollowButtonState();
}

class _AuthorFollowButtonState extends State<AuthorFollowButton> {
  final FollowStore _store = sl<FollowStore>();

  String get _id => widget.authorId.toString();

  @override
  void initState() {
    super.initState();
    // First time we see this author: use the server value. If the store
    // already knows (an earlier follow / unfollow), keep that.
    _store.seed(widget.authorId, widget.initialIsFollowing, overwrite: false);
  }

  @override
  void didUpdateWidget(covariant AuthorFollowButton old) {
    super.didUpdateWidget(old);
    // Fresh data from the server (the feed was refreshed): it wins.
    if (old.initialIsFollowing != widget.initialIsFollowing ||
        old.authorId != widget.authorId) {
      _store.seed(widget.authorId, widget.initialIsFollowing);
    }
  }

  Future<void> _toggle() async {
    final failure = await _store.toggle(_id);
    if (failure != null && mounted) {
      AppSnackBar.error(
        context,
        failure is AuthFailure
            ? 'Sign in to follow authors.'
            : failure.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // You cannot follow yourself (the API answers 422), so hide the button
    // on your own posts.
    final auth = context.watch<AuthCubit>().state;
    if (auth is AuthAuthenticated && auth.user.id == widget.authorId) {
      return const SizedBox.shrink();
    }

    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) => FollowButton(
        isFollowing: _store.isFollowing(_id),
        isLoading: _store.isLoading(_id),
        onPressed: _toggle,
      ),
    );
  }
}