import '../../domain/entities/author.dart';

class AuthorModel extends Author {
  const AuthorModel({
    required super.id,
    required super.name,
    super.username,
    super.avatarUrl,
    super.isFollowing,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString(),
      avatarUrl: (json['avatar_url'] ?? json['avatar'])?.toString(),
      isFollowing: json['is_following'] as bool?,
    );
  }
}
