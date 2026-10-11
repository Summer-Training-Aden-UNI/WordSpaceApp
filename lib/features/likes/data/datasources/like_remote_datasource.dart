import '../../../../core/network/api_consumer.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/paginated.dart';
import '../../../posts/data/models/post_model.dart';

abstract class LikeRemoteDataSource {
  /// Posts the logged-in user has liked (GET /user/liked-posts).
  Future<List<PostModel>> getLikedPosts();
  Future<void> likePost(int postId);
  Future<void> unlikePost(int postId);
}

class LikeRemoteDataSourceImpl implements LikeRemoteDataSource {
  final ApiConsumer api;
  LikeRemoteDataSourceImpl(this.api);

  @override
  Future<List<PostModel>> getLikedPosts() async {
    final res = await api.get(ApiConstants.likedPosts);
    return Paginated.fromResponse(res, PostModel.fromJson).items;
  }

  @override
  Future<void> likePost(int postId) async {
    await api.post(ApiConstants.postLikes(postId));
  }

  @override
  Future<void> unlikePost(int postId) async {
    await api.delete(ApiConstants.postLikes(postId));
  }
}