import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/paginated.dart';
import '../models/public_user_model.dart';

abstract class FollowRemoteDataSource {
  /// GET /users?search=...&page=...  (query must be 2-100 chars, else 422)
  Future<Paginated<PublicUserModel>> searchUsers(String query, {int page = 1});

  // TODO: followUser, unfollowUser, getUser, getUserPosts,
  //       getFollowers, getFollowing
}

class FollowRemoteDataSourceImpl implements FollowRemoteDataSource {
  final Dio dio;
  FollowRemoteDataSourceImpl(this.dio);

  @override
  Future<Paginated<PublicUserModel>> searchUsers(
    String query, {
    int page = 1,
  }) async {
    final res = await dio.get(
      ApiConstants.users,
      queryParameters: {'search': query, 'page': page},
    );
    return Paginated.fromJson(
      res.data as Map<String, dynamic>,
      PublicUserModel.fromJson,
    );
  }
}
