import 'package:equatable/equatable.dart';

/// The author of a post (the `author` object inside a post).
class Author extends Equatable {
  final int id;
  final String name;
  final String? username;
  final String? avatarUrl;

  /// null when the request was sent without a token.
  final bool? isFollowing;

  const Author({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
    this.isFollowing,
  });

  @override
  List<Object?> get props => [id, name, username, avatarUrl, isFollowing];
}
