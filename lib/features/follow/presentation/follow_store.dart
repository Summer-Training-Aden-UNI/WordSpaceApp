import 'package:flutter/foundation.dart';

import '../../../core/error/failures.dart';
import '../../posts/domain/entities/author.dart';
import '../domain/entities/user_details.dart';
import '../domain/usecases/follow_user.dart';
import '../domain/usecases/unfollow_user.dart';

/// ONE shared follow state for the whole app, keyed by user id.
/// Following an author on one post updates every other post by that author.
///
/// Get it with `sl<FollowStore>()` and rebuild widgets with
/// `ListenableBuilder(listenable: store, builder: ...)`.
class FollowStore extends ChangeNotifier {
  final FollowUser _follow;
  final UnfollowUser _unfollow;

  FollowStore({
    required FollowUser followUser,
    required UnfollowUser unfollowUser,
  }) : _follow = followUser,
       _unfollow = unfollowUser;

  final Map<String, bool> _following = {};
  final Map<String, int> _followers = {};

  /// Call after EVERY fetch of posts (first load, refresh, next page) so the
  /// server stays the source of truth.
  void seedAuthors(Iterable<Author?> authors) {
    for (final a in authors) {
      if (a?.isFollowing != null) _following[a!.id] = a.isFollowing!;
    }
    notifyListeners();
  }

  /// Call after GetUser (profile page) to seed the state and the counter.
  void seedUser(UserDetails details) {
    final id = details.user.id.toString();
    if (details.isFollowing != null) _following[id] = details.isFollowing!;
    _followers[id] = details.followersCount;
    notifyListeners();
  }

  bool isFollowing(String userId) => _following[userId] ?? false;

  /// Latest followers_count returned by the server for this user, if any.
  int? followersCount(String userId) => _followers[userId];

  /// Optimistic toggle. Returns null on success, or the [Failure] after
  /// reverting (show a snackbar; on AuthFailure go to the login page).
  Future<Failure?> toggle(String userId) async {
    final before = isFollowing(userId);
    _following[userId] = !before;
    notifyListeners();

    final userIdInt = int.parse(userId);
    final result = before
        ? await _unfollow(UnfollowUserParams(userId: userIdInt))
        : await _follow(FollowUserParams(userId: userIdInt));

    Failure? error;
    result.fold(
      (failure) {
        _following[userId] = before; // revert
        error = failure;
      },
      (r) {
        _following[userId] = r.isFollowing;
        _followers[userId] = r.followersCount;
      },
    );
    notifyListeners();
    return error;
  }
}
