part of 'posts_cubit.dart';

/// States of the Home feed.
sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}

final class PostsInitial extends PostsState {
  const PostsInitial();
}

/// First load (full-screen spinner).
final class PostsLoading extends PostsState {
  const PostsLoading();
}

final class PostsLoaded extends PostsState {
  const PostsLoaded({
    required this.posts,
    this.page = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.actionError,
  });

  final List<Post> posts;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  /// One-shot message for a failed like / refresh / load-more. The UI shows
  /// it as a snackbar. It is cleared by the next emit.
  final String? actionError;

  /// [actionError] is intentionally NOT carried over, so every copyWith
  /// produces a state without an error unless one is passed.
  PostsLoaded copyWith({
    List<Post>? posts,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? actionError,
  }) =>
      PostsLoaded(
        posts: posts ?? this.posts,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        actionError: actionError,
      );

  @override
  List<Object?> get props =>
      [posts, page, hasMore, isLoadingMore, actionError];
}

/// First load failed (full-screen error with retry).
final class PostsError extends PostsState {
  const PostsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}