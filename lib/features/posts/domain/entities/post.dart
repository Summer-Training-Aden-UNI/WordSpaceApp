import 'package:equatable/equatable.dart';

import 'author.dart';

/// A post as shown in the Home feed.
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
    this.coverImageUrl,
    this.tag,
    this.isFeatured = false,
    this.isLiked = false,
  });

  final int id;
  final Author author;
  final String title;
  final String excerpt;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final int likeCount;
  final int commentCount;
  final String? coverImageUrl;

  /// Short category label shown on the cover, e.g. "Deep Technical Dive".
  final String? tag;
  final bool isFeatured;
  final bool isLiked;

  Post copyWith({
    Author? author,
    int? likeCount,
    bool? isLiked,
  }) =>
      Post(
        id: id,
        author: author ?? this.author,
        title: title,
        excerpt: excerpt,
        publishedAt: publishedAt,
        readTimeMinutes: readTimeMinutes,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount,
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