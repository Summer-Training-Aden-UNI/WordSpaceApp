import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/public_user.dart';
import '../repositories/follow_repository.dart';

class GetFollowing implements UseCase<Paginated<PublicUser>, GetFollowingParams> {
  final FollowRepository repository;
  GetFollowing(this.repository);

  @override
  Future<Either<Failure, Paginated<PublicUser>>> call(GetFollowingParams params) =>
      repository.getFollowing(params.userId, page: params.page);
}

class GetFollowingParams extends Equatable {
  final int userId;
  final int page;
  const GetFollowingParams({required this.userId, this.page = 1});

  @override
  List<Object?> get props => [userId, page];
}
