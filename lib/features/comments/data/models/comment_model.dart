import '../../../../core/utils/json_helpers.dart';
import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.body,
    super.authorId,
    required super.authorName,
    super.createdAt,
  });

 
  /// GET  -> { id, content, user_id, post_id, author: {id, name, ...}, created_at }
  /// POST -> { id, content, user_id, post_id, created_at }  (no author)
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    return CommentModel(
      id: (json['id'] as num).toInt(),
      body: json['content']?.toString() ?? '',
      // Falls back to user_id when the response has no author object.
      authorId: asInt((author is Map ? author['id'] : null) ?? json['user_id']),
      authorName: author is Map ? (author['name']?.toString() ?? '') : '',
      createdAt: json['created_at']?.toString(),
    );
  }
}