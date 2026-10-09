import 'package:equatable/equatable.dart';

import '../../domain/entities/comment.dart';

enum CommentsStatus { initial, loading, success, failure }

/// Everything the comments section needs to draw itself.
///
/// One class (instead of several sealed states) because the list of comments
/// must stay on screen while we load more, add or delete.
class CommentsState extends Equatable {
  const CommentsState({
    this.status = CommentsStatus.initial,
    this.comments = const [],
    this.page = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.deletingIds = const {},
    this.commentsCount = 0,
    this.errorMessage,
    this.actionError,
  });

  final CommentsStatus status;
  final List<Comment> comments;

  /// Last page we loaded, and whether the server has more.
  final int page;
  final bool hasMore;

  final bool isLoadingMore;

  /// A new comment is being sent (disables the send button).
  final bool isSubmitting;

  /// Ids of comments whose delete request is in flight.
  final Set<int> deletingIds;

  /// Number shown next to the "Comments" title. Starts from the post's count
  /// and is adjusted +1 / -1 locally (the API page has no total).
  final int commentsCount;

  /// First load failed -> full error view with Retry.
  final String? errorMessage;

  /// One-shot message for a failed add / delete / load more (snackbar).
  final String? actionError;

  /// [errorMessage] and [actionError] are NOT carried over: every copyWith
  /// clears them unless a new value is passed.
  CommentsState copyWith({
    CommentsStatus? status,
    List<Comment>? comments,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSubmitting,
    Set<int>? deletingIds,
    int? commentsCount,
    String? errorMessage,
    String? actionError,
  }) =>
      CommentsState(
        status: status ?? this.status,
        comments: comments ?? this.comments,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        deletingIds: deletingIds ?? this.deletingIds,
        commentsCount: commentsCount ?? this.commentsCount,
        errorMessage: errorMessage,
        actionError: actionError,
      );

  @override
  List<Object?> get props => [
        status,
        comments,
        page,
        hasMore,
        isLoadingMore,
        isSubmitting,
        deletingIds,
        commentsCount,
        errorMessage,
        actionError,
      ];
}
