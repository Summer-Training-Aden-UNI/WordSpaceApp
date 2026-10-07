import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/public_user.dart';
import '../repositories/follow_repository.dart';

class GetFollowers implements UseCase<Paginated<PublicUser>, GetFollowersParams> {
  final FollowRepository repository;
  GetFollowers(this.repository);

  @override
  Future<Either<Failure, Paginated<PublicUser>>> call(GetFollowersParams params) =>
      repository.getFollowers(params.userId, page: params.page);
}

class GetFollowersParams extends Equatable {
  final int userId;
  final int page;
  const GetFollowersParams({required this.userId, this.page = 1});

  @override
  List<Object?> get props => [userId, page];
}
