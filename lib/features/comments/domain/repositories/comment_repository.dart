import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, Paginated<Comment>>> getComments(int postId, {int page = 1});
  Future<Either<Failure, Comment>> addComment(int postId, String body);
  Future<Either<Failure, Unit>> deleteComment(int commentId);
}
