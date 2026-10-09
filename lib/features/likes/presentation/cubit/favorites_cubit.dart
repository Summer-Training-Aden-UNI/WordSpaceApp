
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../posts/domain/entities/post.dart';
import '../../../posts/presentation/cubit/posts_cubit.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final PostsCubit postsCubit;
  late final StreamSubscription<PostsState> _subscription;

  FavoritesCubit(this.postsCubit) : super(FavoritesInitial()) {
    _subscription = postsCubit.stream.listen(_handlePostsState);
    _handlePostsState(postsCubit.state);
  }

  void _handlePostsState(PostsState state) {
    if (isClosed) return;

    if (state is PostsLoaded) {
      final favorites = state.posts
          .where((post) => post.isLiked)
          .toList();

      emit(FavoritesLoaded(favorites));
    } else if (state is PostsError) {
      emit(FavoritesError('Could not load your favorite posts.'));
    } else {
      emit(FavoritesLoading());
    }
  }

  Future<void> toggleFavorite(Post post) async {
    await postsCubit.toggleLike(post.id);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}