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
    this.followInProgress = const {},
    this.actionError,
  });

  final List<Post> posts;

  /// Author ids whose follow request is in flight (drives FollowButton spinner).
  final Set<String> followInProgress;

  /// One-shot message for a failed like / follow / refresh. The UI shows it as
  /// a snackbar. It is cleared by the next emit.
  final String? actionError;

  /// NOTE: [actionError] is intentionally NOT carried over, so every
  /// copyWith produces a state without an error unless one is passed.
  PostsLoaded copyWith({
    List<Post>? posts,
    Set<String>? followInProgress,
    String? actionError,
  }) =>
      PostsLoaded(
        posts: posts ?? this.posts,
        followInProgress: followInProgress ?? this.followInProgress,
        actionError: actionError,
      );

  @override
  List<Object?> get props => [posts, followInProgress, actionError];
}

/// First load failed (full-screen error with retry).
final class PostsError extends PostsState {
  const PostsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}