import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.body,
    super.authorId,
    required super.authorName,
    super.createdAt,
  });

  // NOTE: field names are guesses. Check them against the comment Resource.
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['author'] ?? json['user'];
    return CommentModel(
      id: (json['id'] as num).toInt(),
      body: (json['body'] ?? json['content'] ?? json['comment'])?.toString() ?? '',
      authorId: user is Map ? (user['id'] as num?)?.toInt() : null,
      authorName: user is Map ? (user['name']?.toString() ?? '') : '',
      createdAt: json['created_at']?.toString(),
    );
  }
}
