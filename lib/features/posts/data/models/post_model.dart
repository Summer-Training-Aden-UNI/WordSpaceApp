
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
    super.body,
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

    final publishedAt =
        DateTime.tryParse(publishedAtValue?.toString() ?? '');

    if (publishedAt == null) {
      throw const FormatException(
        'Post response must include a valid publish date.',
      );
    }

    String firstNonEmpty(List<dynamic> values) {
      for (final value in values) {
        final text = value?.toString().trim() ?? '';
        if (text.isNotEmpty) return text;
      }
      return '';
    }

    // Prefer the full body for the details page.
    final body = firstNonEmpty([
      json['body'],
      json['content'],
      json['excerpt'],
    ]);

    // Prefer the excerpt for the Home feed.
    final excerpt = firstNonEmpty([
      json['excerpt'],
      json['body'],
      json['content'],
    ]);

    return PostModel(
      id: (json['id'] as num).toInt(),
      author: AuthorModel.fromJson(authorJson),
      title: json['title']?.toString() ?? '',
      excerpt: excerpt,
      body: body,
      publishedAt: publishedAt,
      readTimeMinutes:
          (json['read_time_minutes'] as num?)?.toInt() ?? 1,
      likeCount:
          (json['like_count'] ?? json['likes_count'] as num?)?.toInt() ?? 0,
      commentCount:
          (json['comment_count'] ?? json['comments_count'] as num?)?.toInt() ??
              0,
      coverImageUrl:
          (json['image_url'] ?? json['image'] ?? json['cover_image'])
              ?.toString(),
      tag: json['tag']?.toString(),
      isFeatured: json['is_featured'] as bool? ?? false,
      isLiked:
          (json['liked_by_user'] ?? json['is_liked']) as bool? ?? false,
    );
  }
}
