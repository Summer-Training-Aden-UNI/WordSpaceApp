import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

class Search implements UseCase<SearchResult, SearchParams> {
  final SearchRepository repository;
  Search(this.repository);

  @override
  Future<Either<Failure, SearchResult>> call(SearchParams params) async {
    final q = params.query.trim();
    // The API rejects queries shorter than 2 chars with 422, so skip the call.
    if (q.length < 2) return const Right(SearchResult.empty());
    return repository.search(q);
  }
}

class SearchParams extends Equatable {
  final String query;
  const SearchParams(this.query);

  @override
  List<Object?> get props => [query];
}
