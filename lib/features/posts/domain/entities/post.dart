import 'package:equatable/equatable.dart';

import 'author.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final String? imageUrl;
  final String? status;
  final Author? author;
  final int commentsCount;
  final int likesCount;

  /// `liked_by_user` from the API. null when no token was sent.
  final bool? isLiked;
  final String? createdAt;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.status,
    this.author,
    required this.commentsCount,
    required this.likesCount,
    this.isLiked,
    this.createdAt,
  });

  int? get authorId => author?.id;
  String get authorName => author?.name ?? '';

  @override
  List<Object?> get props => [
        id, title, body, imageUrl, status, author,
        commentsCount, likesCount, isLiked, createdAt,
      ];
}
