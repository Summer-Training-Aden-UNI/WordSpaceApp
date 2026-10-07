import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/comment_repository.dart';

class DeleteComment implements UseCase<Unit, DeleteCommentParams> {
  final CommentRepository repository;
  DeleteComment(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteCommentParams params) =>
      repository.deleteComment(params.commentId);
}

class DeleteCommentParams extends Equatable {
  final int commentId;
  const DeleteCommentParams({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}
