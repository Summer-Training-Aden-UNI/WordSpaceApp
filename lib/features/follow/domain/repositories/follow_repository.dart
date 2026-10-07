import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../../../posts/domain/entities/post.dart';
import '../entities/follow_result.dart';
import '../entities/public_user.dart';
import '../entities/user_details.dart';

abstract class FollowRepository {
  Future<Either<Failure, Paginated<PublicUser>>> searchUsers(String query, {int page = 1});
  Future<Either<Failure, UserDetails>> getUser(int userId);
  Future<Either<Failure, Paginated<Post>>> getUserPosts(int userId, {int page = 1});
  Future<Either<Failure, Paginated<PublicUser>>> getFollowers(int userId, {int page = 1});
  Future<Either<Failure, Paginated<PublicUser>>> getFollowing(int userId, {int page = 1});
  Future<Either<Failure, FollowResult>> followUser(int userId);
  Future<Either<Failure, FollowResult>> unfollowUser(int userId);
}
