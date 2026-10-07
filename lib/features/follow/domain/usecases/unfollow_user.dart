import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/follow_result.dart';
import '../repositories/follow_repository.dart';

class UnfollowUser implements UseCase<FollowResult, UnfollowUserParams> {
  final FollowRepository repository;
  UnfollowUser(this.repository);

  @override
  Future<Either<Failure, FollowResult>> call(UnfollowUserParams params) =>
      repository.unfollowUser(params.userId);
}

class UnfollowUserParams extends Equatable {
  final int userId;
  const UnfollowUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
