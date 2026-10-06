import 'package:equatable/equatable.dart';

import '../../../follow/domain/entities/public_user.dart';
import '../../../posts/domain/entities/post.dart';

class SearchResult extends Equatable {
  final List<PublicUser> users;
  final List<Post> posts;

  const SearchResult({required this.users, required this.posts});

  const SearchResult.empty()
      : users = const [],
        posts = const [];

  bool get isEmpty => users.isEmpty && posts.isEmpty;

  @override
  List<Object?> get props => [users, posts];
}
