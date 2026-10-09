
import '../../../posts/domain/entities/post.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSignInRequired extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Post> posts;

  /// One-time message for the UI (for example a failed remove).
  final String? actionError;

  FavoritesLoaded(this.posts, {this.actionError});
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}