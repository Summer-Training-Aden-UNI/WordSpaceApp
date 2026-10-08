import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/post.dart';

/// Contract for post CRUD operations.
abstract interface class PostRepository {
  Future<Either<Failure, Paginated<Post>>> getPosts({
    int page = 1,
    String? search,
  });

  Future<Either<Failure, Post>> getPost(int id);

  Future<Either<Failure, Post>> createPost({
    required String title,
    required String body,
    String? status,
    String? imagePath,
  });

  Future<Either<Failure, Post>> updatePost(
    int id, {
    required String title,
    required String body,
    String? status,
    String? imagePath,
  });

  Future<Either<Failure, Unit>> deletePost(int id);
}