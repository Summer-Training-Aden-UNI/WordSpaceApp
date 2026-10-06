import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/public_user.dart';
import '../repositories/follow_repository.dart';

class SearchUsers
    implements UseCase<Paginated<PublicUser>, SearchUsersParams> {
  final FollowRepository repository;
  SearchUsers(this.repository);

  @override
  Future<Either<Failure, Paginated<PublicUser>>> call(
      SearchUsersParams params) async {
    final q = params.query.trim();
    // The API rejects queries shorter than 2 chars with 422, so skip the call.
    if (q.length < 2) return Right(Paginated<PublicUser>.empty());
    return repository.searchUsers(q, page: params.page);
  }
}

class SearchUsersParams extends Equatable {
  final String query;
  final int page;
  const SearchUsersParams({required this.query, this.page = 1});

  @override
  List<Object?> get props => [query, page];
}
