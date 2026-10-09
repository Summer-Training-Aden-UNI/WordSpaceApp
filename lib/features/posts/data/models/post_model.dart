import '../../domain/entities/post.dart';
import 'author_model.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.author,
    required super.title,
    required super.excerpt,
    required super.publishedAt,
    required super.readTimeMinutes,
    required super.likeCount,
    required super.commentCount,
    super.coverImageUrl,
    super.tag,
    super.isFeatured,
    super.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'] ?? json['user'];
    if (authorJson is! Map<String, dynamic>) {
      throw const FormatException(
        'Post response must include an author object.',
      );
    }

    final publishedAtValue =
        json['published_at'] ?? json['created_at'] ?? json['publishedAt'];
    final publishedAt = DateTime.tryParse(publishedAtValue?.toString() ?? '');
    if (publishedAt == null) {
      throw const FormatException(
        'Post response must include a valid publish date.',
      );
    }

    final excerpt =
        (json['excerpt'] ?? json['body'] ?? json['content'])?.toString() ?? '';
    return PostModel(
      id: json['id'] as int,
      author: AuthorModel.fromJson(authorJson),
      title: json['title']?.toString() ?? '',
      excerpt: excerpt,
      publishedAt: publishedAt,
       readTimeMinutes: (json['read_time_minutes'] as num?)?.toInt() ??
          _estimateReadTime(excerpt),
      likeCount:
          (json['like_count'] ?? json['likes_count'] as num?)?.toInt() ?? 0,
      commentCount:
          (json['comment_count'] ?? json['comments_count'] as num?)?.toInt() ??
          0,
      coverImageUrl: (json['image_url'] ?? json['image'] ?? json['cover_image'])
          ?.toString(),
      tag: json['tag']?.toString(),
      isFeatured: json['is_featured'] as bool? ?? false,
      isLiked: (json['liked_by_user'] ?? json['is_liked']) as bool? ?? false,
    );
  }
  /// The API has no read time, so estimate it: about 200 words per minute.
  static int _estimateReadTime(String text) {
    final trimmed = text.trim();
    final words = trimmed.isEmpty ? 0 : trimmed.split(RegExp(r'\s+')).length;
    final minutes = (words / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }
}
