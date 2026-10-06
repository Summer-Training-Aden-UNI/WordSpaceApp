import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.title,
    required super.excerpt,
    required super.authorName,
    required super.commentsCount,
    required super.likesCount,
  });

  // NOTE: field names are guessed. Adjust to match PostResource.php.
  factory PostModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return PostModel(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      excerpt:
          (json['excerpt'] ?? json['body'] ?? json['content'])?.toString() ?? '',
      authorName: user is Map ? (user['name']?.toString() ?? '') : '',
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
    );
  }
}
