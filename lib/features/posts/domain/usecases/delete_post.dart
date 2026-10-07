import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/post_repository.dart';

class DeletePost implements UseCase<Unit, DeletePostParams> {
  final PostRepository repository;
  DeletePost(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeletePostParams params) =>
      repository.deletePost(params.id);
}

class DeletePostParams extends Equatable {
  final int id;
  const DeletePostParams({required this.id});

  @override
  List<Object?> get props => [id];
}
