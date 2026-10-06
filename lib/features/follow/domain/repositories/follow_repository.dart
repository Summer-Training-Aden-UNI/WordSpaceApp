import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/public_user.dart';

abstract class FollowRepository {
  Future<Either<Failure, Paginated<PublicUser>>> searchUsers(
    String query, {
    int page = 1,
  });

  // TODO: followUser, unfollowUser, getUser, getUserPosts,
  //       getFollowers, getFollowing
}
