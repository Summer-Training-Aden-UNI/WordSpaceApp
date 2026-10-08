import '../entities/post.dart';

/// Contract the Home feed Cubit depends on.
/// Implementations should throw on failure; the Cubit turns that into UI state.
abstract interface class PostsRepository {
  Future<List<Post>> getPosts();

  Future<void> setLike({required String postId, required bool liked});

  Future<void> setFollow({required String authorId, required bool follow});
}
