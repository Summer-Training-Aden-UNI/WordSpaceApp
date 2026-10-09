import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/comment.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_comment.dart';
import '../../domain/usecases/delete_comment.dart';
import '../../domain/usecases/get_comments.dart';
import 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit({
    required this.postId,
    required GetComments getComments,
    required AddComment addComment,
    required DeleteComment deleteComment,
    int initialCount = 0,
    this.currentUserId,
    this.currentUserName,
  })  : _getComments = getComments,
        _addComment = addComment,
        _deleteComment = deleteComment,
        super(CommentsState(commentsCount: initialCount));

  final int postId;

  /// Used to fill in the author of a comment you just added

  final int? currentUserId;
  final String? currentUserName;

  final GetComments _getComments;
  final AddComment _addComment;
  final DeleteComment _deleteComment;
  /// First page. Also used by the Retry button.
  Future<void> load() async {
    emit(state.copyWith(status: CommentsStatus.loading));

    final result = await _getComments(GetCommentsParams(postId: postId));
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CommentsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: CommentsStatus.success,
          comments: page.items,
          page: page.currentPage,
          hasMore: page.hasMore,
        ),
      ),
    );
  }

  /// "Load more comments" button.
  Future<void> loadMore() async {
    if (state.status != CommentsStatus.success ||
        !state.hasMore ||
        state.isLoadingMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getComments(
      GetCommentsParams(postId: postId, page: state.page + 1),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, actionError: failure.message),
      ),
      (page) {
        // A comment we just added may also come back in the next page,
        // so skip ids we already have.
        final known = state.comments.map((c) => c.id).toSet();
        final fresh = page.items.where((c) => !known.contains(c.id));
        emit(
          state.copyWith(
            isLoadingMore: false,
            comments: [...state.comments, ...fresh],
            page: page.currentPage,
            hasMore: page.hasMore,
          ),
        );
      },
    );
  }

  /// Returns true when the comment was sent, so the input can clear itself.
  Future<bool> addComment(String body) async {
    final text = body.trim();
    if (text.isEmpty || state.isSubmitting) return false;

    emit(state.copyWith(isSubmitting: true));

    final result = await _addComment(
      AddCommentParams(postId: postId, body: text),
    );
    if (isClosed) return false;

    return result.fold<bool>(
      (failure) {
        emit(state.copyWith(isSubmitting: false, actionError: _msg(failure)));
        return false;
      },
      (comment) {
        // The POST response has no author, so use the logged-in user.
        final mine = Comment(
          id: comment.id,
          body: comment.body,
          authorId: comment.authorId ?? currentUserId,
          authorName: comment.authorName.isEmpty
              ? (currentUserName ?? '')
              : comment.authorName,
          createdAt: comment.createdAt,
        );
        // New comment goes on top. If the API returns the oldest first,
        // change this to `[...state.comments, mine]`.
        emit(
          state.copyWith(
            isSubmitting: false,
            comments: [mine, ...state.comments],
            commentsCount: state.commentsCount + 1,
          ),
        );
        return true;
      },
    );
  }

  Future<void> deleteComment(int commentId) async {
    if (state.deletingIds.contains(commentId)) return;
    emit(state.copyWith(deletingIds: {...state.deletingIds, commentId}));

    final result = await _deleteComment(
      DeleteCommentParams(commentId: commentId),
    );
    if (isClosed) return;

    final stillDeleting = {...state.deletingIds}..remove(commentId);
    result.fold(
      (failure) => emit(
        state.copyWith(deletingIds: stillDeleting, actionError: _msg(failure)),
      ),
      (_) => emit(
        state.copyWith(
          deletingIds: stillDeleting,
          comments: [
            for (final c in state.comments)
              if (c.id != commentId) c,
          ],
          commentsCount:
              state.commentsCount > 0 ? state.commentsCount - 1 : 0,
        ),
      ),
    );
  }
  
  /// Guests get a friendly message instead of the raw "Unauthenticated".
  String _msg(Failure failure) =>
      failure is AuthFailure ? 'Sign in to comment.' : failure.message;
}
