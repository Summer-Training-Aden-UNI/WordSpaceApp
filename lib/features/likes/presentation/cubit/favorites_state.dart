
import '../../../posts/domain/entities/post.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Post> posts;

  FavoritesLoaded(this.posts);
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}