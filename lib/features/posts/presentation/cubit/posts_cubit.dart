import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';

part 'posts_state.dart';

/// Drives the Home feed: loading, pull-to-refresh, like and follow.
class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this._repository) : super(const PostsInitial());

  final PostsRepository _repository;

  static const _loadFailed = 'We couldn\'t load the feed. Check your '
      'connection and try again.';
  static const _refreshFailed = 'Couldn\'t refresh. Showing your last feed.';
  static const _likeFailed = 'Couldn\'t update your like. Try again.';
  static const _followFailed = 'Couldn\'t update follow. Try again.';

  /// First load. Shows the full-screen spinner.
  Future<void> loadPosts() async {
    emit(const PostsLoading());
    try {
      final posts = await _repository.getPosts();
      if (isClosed) return;
      emit(PostsLoaded(posts: posts));
    } catch (_) {
      if (isClosed) return;
      emit(const PostsError(_loadFailed));
    }
  }

  /// Pull-to-refresh. Keeps the current list on screen if it fails.
  Future<void> refresh() async {
    try {
      final posts = await _repository.getPosts();
      if (isClosed) return;
      emit(PostsLoaded(posts: posts));
    } catch (_) {
      if (isClosed) return;
      final current = state;
      if (current is PostsLoaded) {
        emit(current.copyWith(actionError: _refreshFailed));
      } else {
        emit(const PostsError(_loadFailed));
      }
    }
  }

  /// Optimistic like: the heart flips immediately and rolls back on failure.
  Future<void> toggleLike(String postId) async {
    final current = state;
    if (current is! PostsLoaded) return;
    final original = current.posts.where((p) => p.id == postId).firstOrNull;
    if (original == null) return;

    final nextLiked = !original.isLiked;
    _updateLoaded(
      (s) => s.copyWith(
        posts: _mapPost(
          s.posts,
          postId,
          (p) => p.copyWith(
            isLiked: nextLiked,
            likeCount: p.likeCount + (nextLiked ? 1 : -1),
          ),
        ),
      ),
    );

    try {
      await _repository.setLike(postId: postId, liked: nextLiked);
    } catch (_) {
      _updateLoaded(
        (s) => s.copyWith(
          posts: _mapPost(
            s.posts,
            postId,
            (p) => p.copyWith(
              isLiked: original.isLiked,
              likeCount: original.likeCount,
            ),
          ),
          actionError: _likeFailed,
        ),
      );
    }
  }

  /// Not optimistic: the button shows a spinner while the request runs, then
  /// every post by that author is updated.
  Future<void> toggleFollow(String authorId) async {
    final current = state;
    if (current is! PostsLoaded) return;
    if (current.followInProgress.contains(authorId)) return;
    final author = current.posts
        .where((p) => p.author.id == authorId)
        .firstOrNull
        ?.author;
    if (author == null) return;

    final nextFollowing = !author.isFollowing;
    _updateLoaded(
      (s) => s.copyWith(followInProgress: {...s.followInProgress, authorId}),
    );

    try {
      await _repository.setFollow(authorId: authorId, follow: nextFollowing);
      _updateLoaded(
        (s) => s.copyWith(
          posts: [
            for (final p in s.posts)
              p.author.id == authorId
                  ? p.copyWith(
                      author: p.author.copyWith(isFollowing: nextFollowing),
                    )
                  : p,
          ],
          followInProgress: {...s.followInProgress}..remove(authorId),
        ),
      );
    } catch (_) {
      _updateLoaded(
        (s) => s.copyWith(
          followInProgress: {...s.followInProgress}..remove(authorId),
          actionError: _followFailed,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Re-reads the *current* state (so concurrent actions don't overwrite each
  /// other) and emits the updated one. No-op unless the feed is loaded.
  void _updateLoaded(PostsLoaded Function(PostsLoaded s) update) {
    final s = state;
    if (isClosed || s is! PostsLoaded) return;
    emit(update(s));
  }

  List<Post> _mapPost(
    List<Post> posts,
    String postId,
    Post Function(Post) update,
  ) =>
      [for (final p in posts) p.id == postId ? update(p) : p];
}