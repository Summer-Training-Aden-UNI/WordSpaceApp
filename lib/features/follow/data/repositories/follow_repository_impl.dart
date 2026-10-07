import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../../../../core/utils/safe_call.dart';
import '../../../posts/domain/entities/post.dart';
import '../../domain/entities/follow_result.dart';
import '../../domain/entities/public_user.dart';
import '../../domain/entities/user_details.dart';
import '../../domain/repositories/follow_repository.dart';
import '../datasources/follow_remote_datasource.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FollowRemoteDataSource remote;
  FollowRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Paginated<PublicUser>>> searchUsers(String query, {int page = 1}) =>
      safeCall(() => remote.searchUsers(query, page: page));

  @override
  Future<Either<Failure, UserDetails>> getUser(int userId) =>
      safeCall(() => remote.getUser(userId));

  @override
  Future<Either<Failure, Paginated<Post>>> getUserPosts(int userId, {int page = 1}) =>
      safeCall(() => remote.getUserPosts(userId, page: page));

  @override
  Future<Either<Failure, Paginated<PublicUser>>> getFollowers(int userId, {int page = 1}) =>
      safeCall(() => remote.getFollowers(userId, page: page));

  @override
  Future<Either<Failure, Paginated<PublicUser>>> getFollowing(int userId, {int page = 1}) =>
      safeCall(() => remote.getFollowing(userId, page: page));

  @override
  Future<Either<Failure, FollowResult>> followUser(int userId) =>
      safeCall(() => remote.followUser(userId));

  @override
  Future<Either<Failure, FollowResult>> unfollowUser(int userId) =>
      safeCall(() => remote.unfollowUser(userId));
}
