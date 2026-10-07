import 'package:equatable/equatable.dart';

/// The person who wrote a post, as shown on feed cards.
class Author extends Equatable {
  const Author({
    required this.id,
    required this.name,
    this.headline,
    this.avatarUrl,
    this.isFollowing = false,
  });

  final String id;
  final String name;

  /// Short role line under the name, e.g. "Lead Architect". Optional.
  final String? headline;
  final String? avatarUrl;
  final bool isFollowing;

  Author copyWith({bool? isFollowing}) => Author(
        id: id,
        name: name,
        headline: headline,
        avatarUrl: avatarUrl,
        isFollowing: isFollowing ?? this.isFollowing,
      );

  @override
  List<Object?> get props => [id, name, headline, avatarUrl, isFollowing];
}