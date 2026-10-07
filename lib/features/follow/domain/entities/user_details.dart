import 'package:equatable/equatable.dart';

import 'public_user.dart';

/// Response of GET /users/{user}: the user plus counters.
class UserDetails extends Equatable {
  final PublicUser user;
  final int followersCount;
  final int followingCount;
  final int postsCount;

  /// null when the request was made without a token.
  final bool? isFollowing;

  const UserDetails({
    required this.user,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    this.isFollowing,
  });

  @override
  List<Object?> get props =>
      [user, followersCount, followingCount, postsCount, isFollowing];
}
