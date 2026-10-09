import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../likes/domain/usecases/like_post.dart';
import '../../../likes/domain/usecases/unlike_post.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts.dart';

part 'posts_state.dart';

/// Drives the Home feed: loading, refresh, pagination and like.
class PostsCubit extends Cubit<PostsState> {
  PostsCubit({
    required GetPosts getPosts,
    required LikePost likePost,
    required UnlikePost unlikePost,
  })  : _getPosts = getPosts,
        _likePost = likePost,
        _unlikePost = unlikePost,
        super(const PostsInitial());

  final GetPosts _getPosts;
  final LikePost _likePost;
  final UnlikePost _unlikePost;

  /// First load. Shows the full-screen spinner.
  Future<void> loadPosts() async {
    emit(const PostsLoading());
    final result = await _getPosts(const GetPostsParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(PostsError(failure.message)),
      (p) {
        // TODO(follow): followStore.seedAuthors(p.items.map((e) => e.author));
        emit(PostsLoaded(
          posts: p.items,
          page: p.currentPage,
          hasMore: p.hasMore,
        ));
      },
    );
  }

  /// Pull-to-refresh. Keeps the current list on screen if it fails.
  Future<void> refresh() async {
    final result = await _getPosts(const GetPostsParams());
    if (isClosed) return;
    result.fold(
      (failure) {
        if (state is PostsLoaded) {
          _updateLoaded((s) => s.copyWith(actionError: failure.message));
        } else {
          emit(PostsError(failure.message));
        }
      },
      (p) => emit(PostsLoaded(
        posts: p.items,
        page: p.currentPage,
        hasMore: p.hasMore,
      )),
    );
  }

  /// Infinite scroll: loads the next page and appends it.
  Future<void> loadMore() async {
    final s = state;
    if (s is! PostsLoaded || !s.hasMore || s.isLoadingMore) return;

    emit(s.copyWith(isLoadingMore: true));
    final result = await _getPosts(GetPostsParams(page: s.page + 1));
    if (isClosed) return;

    result.fold(
      (failure) => _updateLoaded(
        (s) => s.copyWith(isLoadingMore: false, actionError: failure.message),
      ),
      (p) => _updateLoaded(
        (s) => s.copyWith(
          posts: [...s.posts, ...p.items],
          page: p.currentPage,
          hasMore: p.hasMore,
          isLoadingMore: false,
        ),
      ),
    );
  }

  /// Optimistic like: the heart flips immediately, the request is sent,
  /// and the change is rolled back if it fails.
  Future<void> toggleLike(int postId) async {
    final s = state;
    if (s is! PostsLoaded) return;
    final original = s.posts.where((p) => p.id == postId).firstOrNull;
    if (original == null) return;

    final liked = !original.isLiked;
    _replace(original.copyWith(
      isLiked: liked,
      likeCount: original.likeCount + (liked ? 1 : -1),
    ));

    final result = liked
        ? await _likePost(LikePostParams(postId: postId))
        : await _unlikePost(UnlikePostParams(postId: postId));
    if (isClosed) return;

    result.fold(
      (failure) {
        _replace(original); // roll back
        _updateLoaded(
          (s) => s.copyWith(
            actionError:
                failure is AuthFailure ? 'Sign in to like posts.' : failure.message,
          ),
        );
      },
      (_) {},
    );
  }

  /// Called when the detail page returns an updated post.
  void syncPost(Post post) => _replace(post);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _replace(Post post) => _updateLoaded(
        (s) => s.copyWith(
          posts: [for (final p in s.posts) p.id == post.id ? post : p],
        ),
      );

  /// Re-reads the *current* state (so concurrent actions don't overwrite each
  /// other) and emits the updated one. No-op unless the feed is loaded.
  void _updateLoaded(PostsLoaded Function(PostsLoaded s) update) {
    final s = state;
    if (isClosed || s is! PostsLoaded) return;
    emit(update(s));
  }
}