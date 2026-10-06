import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String excerpt;
  final String authorName;
  final int commentsCount;
  final int likesCount;

  const Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.authorName,
    required this.commentsCount,
    required this.likesCount,
  });

  @override
  List<Object?> get props =>
      [id, title, excerpt, authorName, commentsCount, likesCount];
}
