import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_datasource.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remote;
  CommentRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Paginated<Comment>>> getComments(int postId, {int page = 1}) =>
      safeCall(() => remote.getComments(postId, page: page));

  @override
  Future<Either<Failure, Comment>> addComment(int postId, String body) =>
      safeCall(() => remote.addComment(postId, body));

  @override
  Future<Either<Failure, Unit>> deleteComment(int commentId) => safeCall(() async {
        await remote.deleteComment(commentId);
        return unit;
      });
}
