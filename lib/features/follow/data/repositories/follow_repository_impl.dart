import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/paginated.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/public_user.dart';
import '../../domain/repositories/follow_repository.dart';
import '../datasources/follow_remote_datasource.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FollowRemoteDataSource remote;
  FollowRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Paginated<PublicUser>>> searchUsers(
    String query, {
    int page = 1,
  }) =>
      safeCall(() => remote.searchUsers(query, page: page));
}
