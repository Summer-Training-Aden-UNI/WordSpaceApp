import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../../follow/domain/usecases/follow_user.dart';
import '../../../follow/domain/usecases/unfollow_user.dart';

/// Follow / Following pill for a post author. Keeps its own state and calls
/// the follow use cases directly. Not optimistic: shows a spinner while the
/// request runs, then shows the state the server returned.
class AuthorFollowButton extends StatefulWidget {
  const AuthorFollowButton({
    super.key,
    required this.authorId,
    required this.initialIsFollowing,
  });

  final int authorId;
  final bool initialIsFollowing;

  @override
  State<AuthorFollowButton> createState() => _AuthorFollowButtonState();
}

class _AuthorFollowButtonState extends State<AuthorFollowButton> {
  late bool _following = widget.initialIsFollowing;
  bool _loading = false;

  @override
  void didUpdateWidget(covariant AuthorFollowButton old) {
    super.didUpdateWidget(old);
    // The feed was refreshed: trust the server value again.
    if (old.initialIsFollowing != widget.initialIsFollowing ||
        old.authorId != widget.authorId) {
      _following = widget.initialIsFollowing;
    }
  }

  Future<void> _toggle() async {
    if (_loading) return;
    setState(() => _loading = true);

    final result = _following
        ? await sl<UnfollowUser>()(UnfollowUserParams(userId: widget.authorId))
        : await sl<FollowUser>()(FollowUserParams(userId: widget.authorId));

    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _loading = false);
        AppSnackBar.error(
          context,
          failure is AuthFailure
              ? 'Sign in to follow authors.'
              : failure.message,
        );
      },
      (r) => setState(() {
        _following = r.isFollowing;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FollowButton(
      isFollowing: _following,
      isLoading: _loading,
      onPressed: _toggle,
    );
  }
}