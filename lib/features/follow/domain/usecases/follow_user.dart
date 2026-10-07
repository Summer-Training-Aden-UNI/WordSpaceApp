import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/follow_result.dart';
import '../repositories/follow_repository.dart';

class FollowUser implements UseCase<FollowResult, FollowUserParams> {
  final FollowRepository repository;
  FollowUser(this.repository);

  @override
  Future<Either<Failure, FollowResult>> call(FollowUserParams params) =>
      repository.followUser(params.userId);
}

class FollowUserParams extends Equatable {
  final int userId;
  const FollowUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
