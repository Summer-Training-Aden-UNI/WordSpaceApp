import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class GetComments implements UseCase<Paginated<Comment>, GetCommentsParams> {
  final CommentRepository repository;
  GetComments(this.repository);

  @override
  Future<Either<Failure, Paginated<Comment>>> call(GetCommentsParams params) =>
      repository.getComments(params.postId, page: params.page);
}

class GetCommentsParams extends Equatable {
  final int postId;
  final int page;
  const GetCommentsParams({required this.postId, this.page = 1});

  @override
  List<Object?> get props => [postId, page];
}
