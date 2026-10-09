import 'package:equatable/equatable.dart';

import '../../../follow/domain/entities/public_user.dart';
import '../../../posts/domain/entities/post.dart';

enum SearchStatus { initial, loading, success, failure }

/// Everything the Search page needs to draw itself.
class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.users = const [],
    this.posts = const [],
    this.errorMessage,
    this.actionError,
  });

  final SearchStatus status;

  /// The (trimmed) text that was / is being searched.
  final String query;

  final List<PublicUser> users;
  final List<Post> posts;

  /// The search itself failed -> full error view with Retry.
  final String? errorMessage;

  /// One-shot message for a failed like / follow (snackbar).
  final String? actionError;

  bool get hasResults => users.isNotEmpty || posts.isNotEmpty;

  /// [errorMessage] and [actionError] are NOT carried over: every copyWith
  /// clears them unless a new value is passed.
  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<PublicUser>? users,
    List<Post>? posts,
    String? errorMessage,
    String? actionError,
  }) =>
      SearchState(
        status: status ?? this.status,
        query: query ?? this.query,
        users: users ?? this.users,
        posts: posts ?? this.posts,
        errorMessage: errorMessage,
        actionError: actionError,
      );

  @override
  List<Object?> get props =>
      [status, query, users, posts, errorMessage, actionError];
}
