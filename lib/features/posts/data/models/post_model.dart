import '../../domain/entities/post.dart';
import 'author_model.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    super.imageUrl,
    super.status,
    super.author,
    required super.commentsCount,
    required super.likesCount,
    super.isLiked,
    super.createdAt,
  });

  // NOTE: title/body/image field names are still guesses (see the guide).
  // `author`, `is_following` and `liked_by_user` come from the backend patch.
  factory PostModel.fromJson(Map<String, dynamic> json) {
    final a = json['author'] ?? json['user'];
    return PostModel(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      body: (json['body'] ?? json['content'] ?? json['excerpt'])?.toString() ?? '',
      imageUrl:
          (json['image_url'] ?? json['image'] ?? json['cover_image'])?.toString(),
      status: json['status']?.toString(),
      author: a is Map<String, dynamic> ? AuthorModel.fromJson(a) : null,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      isLiked: (json['liked_by_user'] ?? json['is_liked']) as bool?,
      createdAt: json['created_at']?.toString(),
    );
  }
}
