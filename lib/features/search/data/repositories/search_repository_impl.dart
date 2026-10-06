import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remote;
  SearchRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, SearchResult>> search(String query) =>
      safeCall(() => remote.search(query));
}
