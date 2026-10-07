import 'package:equatable/equatable.dart';

/// Response of POST/DELETE /users/{id}/follow.
class FollowResult extends Equatable {
  final bool isFollowing;
  final int followersCount;

  const FollowResult({required this.isFollowing, required this.followersCount});

  @override
  List<Object?> get props => [isFollowing, followersCount];
}
