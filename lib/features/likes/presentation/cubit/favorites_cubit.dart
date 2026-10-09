import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/presentation/cubit/posts_cubit.dart';
import '../../domain/usecases/get_liked_posts.dart';
import '../../domain/usecases/like_post.dart';
import '../../domain/usecases/unlike_post.dart';
import 'favorites_state.dart';

/// Favorites = the posts the user liked, loaded from GET /user/liked-posts.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required PostsCubit postsCubit,
    required GetLikedPosts getLikedPosts,
    required LikePost likePost,
    required UnlikePost unlikePost,
  })  : _postsCubit = postsCubit,
        _getLikedPosts = getLikedPosts,
        _likePost = likePost,
        _unlikePost = unlikePost,
        super(FavoritesInitial());

  final PostsCubit _postsCubit;
  final GetLikedPosts _getLikedPosts;
  final LikePost _likePost;
  final UnlikePost _unlikePost;

  /// [silent] refreshes without the spinner and keeps the current list if
  /// the request fails (used when coming back from another screen).
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(FavoritesLoading());

    final result = await _getLikedPosts(const NoParams());
    if (isClosed) return;

    result.fold(
      (failure) {
        if (silent && state is FavoritesLoaded) return;
         emit(
          failure is AuthFailure
              ? FavoritesSignInRequired()
              : FavoritesError(failure.message),
        );
      },
      (posts) => emit(FavoritesLoaded(posts)),
    );
  }

  /// Removes the post right away, then unlikes it on the server.
  /// If the server refuses, the post goes back to its place.
  Future<void> removeFavorite(Post post) async {
    final s = state;
    if (s is! FavoritesLoaded) return;
    final index = s.posts.indexWhere((p) => p.id == post.id);
    if (index == -1) return;

    emit(FavoritesLoaded([...s.posts]..removeAt(index)));
    _syncFeed(post.id,
        isLiked: false, likeCount: math.max(0, post.likeCount - 1));

    final result = await _unlikePost(UnlikePostParams(postId: post.id));
    if (isClosed) return;

    result.fold(
      (failure) {
        _insert(post, index, error: _message(failure));
        _syncFeed(post.id, isLiked: true, likeCount: post.likeCount);
      },
      (_) {},
    );
  }

  /// Undo for [removeFavorite]: puts the post back and likes it again.
  Future<void> restoreFavorite(Post post, int index) async {
    final s = state;
    if (s is! FavoritesLoaded) return;
    if (s.posts.any((p) => p.id == post.id)) return;

    _insert(post, index);
    _syncFeed(post.id, isLiked: true, likeCount: post.likeCount);

    final result = await _likePost(LikePostParams(postId: post.id));
    if (isClosed) return;

    result.fold(
      (failure) {
        _remove(post.id, error: _message(failure));
        _syncFeed(post.id,
            isLiked: false, likeCount: math.max(0, post.likeCount - 1));
      },
      (_) {},
    );
  }

  // ---------------------------------------------------------------------------

  String _message(Failure failure) =>
      failure is AuthFailure ? 'Sign in to manage favorites.' : failure.message;

  void _insert(Post post, int index, {String? error}) {
    final s = state;
    final list = s is FavoritesLoaded ? [...s.posts] : <Post>[];
    list.insert(math.min(math.max(index, 0), list.length), post);
    emit(FavoritesLoaded(list, actionError: error));
  }

  void _remove(int postId, {String? error}) {
    final s = state;
    if (s is! FavoritesLoaded) return;
    emit(FavoritesLoaded(
      [for (final p in s.posts) if (p.id != postId) p],
      actionError: error,
    ));
  }

  /// Keeps the Home feed's heart in step (no API call). Does nothing if the
  /// post is not in the loaded feed.
  void _syncFeed(int postId, {required bool isLiked, required int likeCount}) {
    final s = _postsCubit.state;
    if (s is! PostsLoaded) return;
    final inFeed = s.posts.where((p) => p.id == postId).firstOrNull;
    if (inFeed == null) return;
    _postsCubit.syncPost(
      inFeed.copyWith(isLiked: isLiked, likeCount: likeCount),
    );
  }
}