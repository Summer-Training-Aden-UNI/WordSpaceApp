import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../follow/presentation/follow_store.dart';
import '../../../likes/domain/usecases/like_post.dart';
import '../../../likes/domain/usecases/unlike_post.dart';
import '../../../posts/domain/entities/post.dart';
import '../../domain/usecases/search.dart';
import 'search_state.dart';

/// Search page logic: debounced search, like and follow on the results.
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required Search search,
    required LikePost likePost,
    required UnlikePost unlikePost,
    required FollowStore followStore,
  })  : _search = search,
        _likePost = likePost,
        _unlikePost = unlikePost,
        _followStore = followStore,
        super(const SearchState());

  final Search _search;
  final LikePost _likePost;
  final UnlikePost _unlikePost;
  final FollowStore _followStore;

  /// The API rejects shorter queries (the Search use case skips them too).
  static const minChars = 2;
  static const _debounceTime = Duration(milliseconds: 400);

  Timer? _debounce;

  /// Number of the latest search request. A slow answer to an OLD query must
  /// not overwrite the answer to a newer one, so we compare ids.
  int _requestId = 0;

  /// Called on every keystroke. Waits until the user stops typing.
  void onQueryChanged(String raw) {
    _debounce?.cancel();
    final query = raw.trim();

    if (query.length < minChars) {
      _requestId++; // ignore any answer that is still on its way
      emit(SearchState(query: query));
      return;
    }
    _debounce = Timer(_debounceTime, () => _runSearch(query));
  }

  /// Keyboard "search" button: search right now, no waiting.
  void submit(String raw) {
    _debounce?.cancel();
    final query = raw.trim();
    if (query.length >= minChars) _runSearch(query);
  }

  /// The X button in the search field.
  void clear() {
    _debounce?.cancel();
    _requestId++;
    emit(const SearchState());
  }

  /// Retry button of the error view.
  void retry() {
    if (state.query.length >= minChars) _runSearch(state.query);
  }

  Future<void> _runSearch(String query) async {
    final id = ++_requestId;
    // Keep the old results on screen while the new ones load.
    emit(state.copyWith(status: SearchStatus.loading, query: query));

    final result = await _search(SearchParams(query));
    if (isClosed || id != _requestId) return;

    result.fold(
      (failure) => emit(
        SearchState(
          status: SearchStatus.failure,
          query: query,
          errorMessage: failure.message,
        ),
      ),
      (found) {
        // Keep the shared follow state in sync with what the server says.
        _followStore.seedAuthors(found.posts.map((p) => p.author));
        emit(
          SearchState(
            status: SearchStatus.success,
            query: query,
            users: found.users,
            posts: found.posts,
          ),
        );
      },
    );
  }

  /// Optimistic like: the heart flips now and rolls back if the request fails.
  Future<void> toggleLike(int postId) async {
    final original = state.posts.where((p) => p.id == postId).firstOrNull;
    if (original == null) return;

    final nextLiked = !original.isLiked;
    emit(
      state.copyWith(
        posts: _mapPost(
          postId,
          (p) => p.copyWith(
            isLiked: nextLiked,
            likeCount: p.likeCount + (nextLiked ? 1 : -1),
          ),
        ),
      ),
    );

    final result = nextLiked
        ? await _likePost(LikePostParams(postId: postId))
        : await _unlikePost(UnlikePostParams(postId: postId));
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          posts: _mapPost(
            postId,
            (p) => p.copyWith(
              isLiked: original.isLiked,
              likeCount: original.likeCount,
            ),
          ),
          actionError: failure.message,
        ),
      ),
      (_) {},
    );
  }

  /// Follow / unfollow goes through the app-wide [FollowStore], so every
  /// screen that shows this author stays in sync.
  Future<void> toggleFollow(int authorId) async {
    final failure = await _followStore.toggle(authorId);
    if (isClosed) return;
    if (failure != null) {
      emit(state.copyWith(actionError: failure.message));
    }
  }

  List<Post> _mapPost(int postId, Post Function(Post) update) =>
      [for (final p in state.posts) p.id == postId ? update(p) : p];

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
