import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/like_repository.dart';

class LikePost implements UseCase<Unit, LikePostParams> {
  final LikeRepository repository;
  LikePost(this.repository);

  @override
  Future<Either<Failure, Unit>> call(LikePostParams params) =>
      repository.likePost(params.postId);
}

class LikePostParams extends Equatable {
  final int postId;
  const LikePostParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}
