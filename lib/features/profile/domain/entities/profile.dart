import 'package:equatable/equatable.dart';

/// Counters from GET /profile -> "stats".
class ProfileStats extends Equatable {
  final int postsCount;
  final int publishedPosts;
  final int drafts;
  final int commentsCount;
  final int likesCount;
  final int followersCount;

  const ProfileStats({
    this.postsCount = 0,
    this.publishedPosts = 0,
    this.drafts = 0,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.followersCount = 0,
  });

  @override
  List<Object?> get props => [
        postsCount,
        publishedPosts,
        drafts,
        commentsCount,
        likesCount,
        followersCount,
      ];
}

class Profile extends Equatable {
  final int id;
  final String name;
  final String? username;
  final String? email;
  final String? bio;
  final String? avatarUrl;

  /// Only present on GET /profile (not on the edit response).
  final ProfileStats? stats;

  const Profile({
    required this.id,
    required this.name,
    this.username,
    this.email,
    this.bio,
    this.avatarUrl,
    this.stats,
  });

  @override
  List<Object?> get props => [id, name, username, email, bio, avatarUrl, stats];
}