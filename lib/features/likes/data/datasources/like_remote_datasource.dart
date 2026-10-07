import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/paginated.dart';
import '../../../follow/data/models/public_user_model.dart';

abstract class LikeRemoteDataSource {
  /// Users who liked the post.
  Future<Paginated<PublicUserModel>> getLikes(int postId, {int page = 1});
  Future<void> likePost(int postId);
  Future<void> unlikePost(int postId);
}

class LikeRemoteDataSourceImpl implements LikeRemoteDataSource {
  final Dio dio;
  LikeRemoteDataSourceImpl(this.dio);

  @override
  Future<Paginated<PublicUserModel>> getLikes(int postId, {int page = 1}) async {
    final res = await dio.get(
      ApiConstants.postLikes(postId),
      queryParameters: {'page': page},
    );
    return Paginated.fromResponse(res.data, PublicUserModel.fromJson);
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
