import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_details.dart';
import '../repositories/follow_repository.dart';

class GetUser implements UseCase<UserDetails, GetUserParams> {
  final FollowRepository repository;
  GetUser(this.repository);

  @override
  Future<Either<Failure, UserDetails>> call(GetUserParams params) =>
      repository.getUser(params.userId);
}

class GetUserParams extends Equatable {
  final int userId;
  const GetUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
