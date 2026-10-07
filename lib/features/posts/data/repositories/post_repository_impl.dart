import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;
  PostRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Paginated<Post>>> getPosts({int page = 1, String? search}) =>
      safeCall(() => remote.getPosts(page: page, search: search));

  @override
  Future<Either<Failure, Post>> getPost(int id) =>
      safeCall(() => remote.getPost(id));

  @override
  Future<Either<Failure, Post>> createPost({
    required String title,
    required String body,
    String? status,
    String? imagePath,
  }) =>
      safeCall(() => remote.createPost(
          title: title, body: body, status: status, imagePath: imagePath));

  @override
  Future<Either<Failure, Post>> updatePost(
    int id, {
    required String title,
    required String body,
    String? status,
    String? imagePath,
  }) =>
      safeCall(() => remote.updatePost(id,
          title: title, body: body, status: status, imagePath: imagePath));

  @override
  Future<Either<Failure, Unit>> deletePost(int id) => safeCall(() async {
        await remote.deletePost(id);
        return unit;
      });
}
