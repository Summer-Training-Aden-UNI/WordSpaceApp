import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class AddComment implements UseCase<Comment, AddCommentParams> {
  final CommentRepository repository;
  AddComment(this.repository);

  @override
  Future<Either<Failure, Comment>> call(AddCommentParams params) =>
      repository.addComment(params.postId, params.body);
}

class AddCommentParams extends Equatable {
  final int postId;
  final String body;
  const AddCommentParams({required this.postId, required this.body});

  @override
  List<Object?> get props => [postId, body];
}
