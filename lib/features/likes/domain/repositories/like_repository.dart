import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../../../follow/domain/entities/public_user.dart';

abstract class LikeRepository {
  Future<Either<Failure, Paginated<PublicUser>>> getLikes(int postId, {int page = 1});
  Future<Either<Failure, Unit>> likePost(int postId);
  Future<Either<Failure, Unit>> unlikePost(int postId);
}
