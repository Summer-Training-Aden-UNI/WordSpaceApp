import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../posts/domain/entities/post.dart';

abstract class LikeRepository {
  Future<Either<Failure, List<Post>>> getLikedPosts();
  Future<Either<Failure, Unit>> likePost(int postId);
  Future<Either<Failure, Unit>> unlikePost(int postId);
}