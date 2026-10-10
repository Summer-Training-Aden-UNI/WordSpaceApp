
import 'package:equatable/equatable.dart';

import 'author.dart';

/// A post as shown in the Home feed and Post Details page.
class Post extends Equatable {
  const Post({
    required this.id,
    required this.author,
    required this.title,
    required this.excerpt,
    required this.publishedAt,
    required this.readTimeMinutes,
    required this.likeCount,
    required this.commentCount,
    this.body = '',
    this.coverImageUrl,
    this.tag,
    this.isFeatured = false,
    this.isLiked = false,
  });

  final int id;
  final Author author;
  final String title;

  /// Short text displayed in the Home feed.
  final String excerpt;

  /// Full post text displayed on the Post Details page.
  final String body;

  final DateTime publishedAt;
  final int readTimeMinutes;
  final int likeCount;
  final int commentCount;
  final String? coverImageUrl;
  final String? tag;
  final bool isFeatured;
  final bool isLiked;

  Post copyWith({
    Author? author,
    String? body,
    int? likeCount,
    bool? isLiked,
    int? commentCount,
  }) =>
      Post(
        id: id,
        author: author ?? this.author,
        title: title,
        excerpt: excerpt,
        body: body ?? this.body,
        publishedAt: publishedAt,
        readTimeMinutes: readTimeMinutes,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
        coverImageUrl: coverImageUrl,
        tag: tag,
        isFeatured: isFeatured,
        isLiked: isLiked ?? this.isLiked,
      );

  @override
  List<Object?> get props => [
        id,
        author,
        title,
        excerpt,
        body,
        publishedAt,
        readTimeMinutes,
        likeCount,
        commentCount,
        coverImageUrl,
        tag,
        isFeatured,
        isLiked,
      ];
}
