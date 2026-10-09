import 'package:dio/dio.dart';

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
  final Dio dio;
  LikeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PostModel>> getLikedPosts() async {
    final res = await dio.get(ApiConstants.likedPosts);
    return Paginated.fromResponse(res.data, PostModel.fromJson).items;
  }

  @override
  Future<void> likePost(int postId) async {
    await dio.post(ApiConstants.postLikes(postId));
  }

  @override
  Future<void> unlikePost(int postId) async {
    await dio.delete(ApiConstants.postLikes(postId));
  }
}