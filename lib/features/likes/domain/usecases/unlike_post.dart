import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/like_repository.dart';

class UnlikePost implements UseCase<Unit, UnlikePostParams> {
  final LikeRepository repository;
  UnlikePost(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UnlikePostParams params) =>
      repository.unlikePost(params.postId);
}

class UnlikePostParams extends Equatable {
  final int postId;
  const UnlikePostParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}
