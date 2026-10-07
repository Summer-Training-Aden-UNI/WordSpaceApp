import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int id;
  final String body;
  final int? authorId;
  final String authorName;
  final String? createdAt;

  const Comment({
    required this.id,
    required this.body,
    this.authorId,
    required this.authorName,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, body, authorId, authorName, createdAt];
}
