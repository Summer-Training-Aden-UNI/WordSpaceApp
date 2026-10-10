import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    super.username,
    super.email,
    super.bio,
    super.avatarUrl,
    super.stats,
  });

  /// GET  /profile -> { user: {...}, stats: {...} }
  /// POST /profile -> { message, user: {...} }
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final j = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;

    final s = json['stats'];

    return ProfileModel(
      id: (j['id'] as num).toInt(),
      name: j['name']?.toString() ?? '',
      username: j['username']?.toString(),
      email: j['email']?.toString(),
      bio: j['bio']?.toString(),
      avatarUrl: (j['avatar_url'] ?? j['avatar'])?.toString(),
      stats: s is Map<String, dynamic>
          ? ProfileStats(
              postsCount: _int(s['posts_count']),
              publishedPosts: _int(s['published_posts']),
              drafts: _int(s['drafts']),
              commentsCount: _int(s['comments_count']),
              likesCount: _int(s['likes_count']),
              followersCount: _int(s['followers_count']),
            )
          : null,
    );
  }

  static int _int(dynamic v) =>
      v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;
}