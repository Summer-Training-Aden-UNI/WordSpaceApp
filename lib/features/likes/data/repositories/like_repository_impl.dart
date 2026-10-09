import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../../posts/domain/entities/post.dart';
import '../../domain/repositories/like_repository.dart';
import '../datasources/like_remote_datasource.dart';

class LikeRepositoryImpl implements LikeRepository {
  final LikeRemoteDataSource remote;
  LikeRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Post>>> getLikedPosts() =>
      safeCall<List<Post>>(() => remote.getLikedPosts());

  @override
  Future<Either<Failure, Unit>> likePost(int postId) => safeCall(() async {
        await remote.likePost(postId);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> unlikePost(int postId) => safeCall(() async {
        await remote.unlikePost(postId);
        return unit;
      });
}