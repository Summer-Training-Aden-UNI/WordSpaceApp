import 'package:flutter/foundation.dart';

import '../../../core/error/failures.dart';
import '../../posts/domain/entities/author.dart';
import '../domain/entities/user_details.dart';
import '../domain/usecases/follow_user.dart';
import '../domain/usecases/unfollow_user.dart';

/// ONE shared follow state for the whole app, keyed by user id (as String,
/// because Author.id is a String). Following an author on one post updates
/// every other post by that author.
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
  final Set<String> _inFlight = {};

  /// Call after EVERY fetch of posts so the server stays the source of truth.
  void seedAuthors(Iterable<Author> authors) {
    for (final a in authors) {
      _following[a.id] = a.isFollowing;
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
  bool isLoading(String userId) => _inFlight.contains(userId);
  int? followersCount(String userId) => _followers[userId];

  /// Not optimistic: the button shows a spinner while the request runs.
  /// Returns null on success, or the [Failure] (show a snackbar).
  Future<Failure?> toggle(String userId) async {
    if (_inFlight.contains(userId)) return null; // ignore double taps
    final id = int.tryParse(userId);
    if (id == null) return const UnknownFailure('Invalid user id');

    final before = isFollowing(userId);
    _inFlight.add(userId);
    notifyListeners();

    final result = before
        ? await _unfollow(UnfollowUserParams(userId: id))
        : await _follow(FollowUserParams(userId: id));

    Failure? error;
    result.fold((failure) => error = failure, (r) {
      _following[userId] = r.isFollowing;
      _followers[userId] = r.followersCount;
    });
    _inFlight.remove(userId);
    notifyListeners();
    return error;
  }

  /// Call on logout so the next user doesn't see stale state.
  void clear() {
    _following.clear();
    _followers.clear();
    _inFlight.clear();
    notifyListeners();
  }
}
