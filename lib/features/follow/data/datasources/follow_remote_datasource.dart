import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/paginated.dart';
import '../../../posts/data/models/post_model.dart';
import '../models/follow_result_model.dart';
import '../models/public_user_model.dart';
import '../models/user_details_model.dart';

abstract class FollowRemoteDataSource {
  /// GET /users?search=... (query must be 2-100 chars, else 422)
  Future<Paginated<PublicUserModel>> searchUsers(String query, {int page = 1});
  Future<UserDetailsModel> getUser(int userId);
  Future<Paginated<PostModel>> getUserPosts(int userId, {int page = 1});
  Future<Paginated<PublicUserModel>> getFollowers(int userId, {int page = 1});
  Future<Paginated<PublicUserModel>> getFollowing(int userId, {int page = 1});
  Future<FollowResultModel> followUser(int userId);
  Future<FollowResultModel> unfollowUser(int userId);
}

class FollowRemoteDataSourceImpl implements FollowRemoteDataSource {
  final Dio dio;
  FollowRemoteDataSourceImpl(this.dio);

  @override
  Future<Paginated<PublicUserModel>> searchUsers(String query, {int page = 1}) async {
    final res = await dio.get(
      ApiConstants.users,
      queryParameters: {'search': query, 'page': page},
    );
    return Paginated.fromResponse(res.data, PublicUserModel.fromJson);
  }

  @override
  Future<UserDetailsModel> getUser(int userId) async {
    final res = await dio.get(ApiConstants.userById(userId));
    return UserDetailsModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<Paginated<PostModel>> getUserPosts(int userId, {int page = 1}) async {
    final res = await dio.get(
      ApiConstants.userPosts(userId),
      queryParameters: {'page': page},
    );
    return Paginated.fromResponse(res.data, PostModel.fromJson);
  }

  @override
  Future<Paginated<PublicUserModel>> getFollowers(int userId, {int page = 1}) async {
    final res = await dio.get(
      ApiConstants.userFollowers(userId),
      queryParameters: {'page': page},
    );
    return Paginated.fromResponse(res.data, PublicUserModel.fromJson);
  }

  @override
  Future<Paginated<PublicUserModel>> getFollowing(int userId, {int page = 1}) async {
    final res = await dio.get(
      ApiConstants.userFollowing(userId),
      queryParameters: {'page': page},
    );
    return Paginated.fromResponse(res.data, PublicUserModel.fromJson);
  }

  @override
  Future<FollowResultModel> followUser(int userId) async {
    final res = await dio.post(ApiConstants.follow(userId));
    return FollowResultModel.fromBody(res.data);
  }

  @override
  Future<FollowResultModel> unfollowUser(int userId) async {
    final res = await dio.delete(ApiConstants.follow(userId));
    return FollowResultModel.fromBody(res.data);
  }
}
