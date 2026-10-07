import '../../domain/entities/author.dart';

class AuthorModel extends Author {
  const AuthorModel({
    required super.id,
    required super.name,
    super.headline,
    super.avatarUrl,
    super.isFollowing,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: (json['id']).toString(),
      name: json['name']?.toString() ?? '',
      headline: json['headline']?.toString(),
      avatarUrl: (json['avatar_url'] ?? json['avatar'])?.toString(),
      isFollowing: json['is_following'] as bool? ?? false,
    );
  }
}
