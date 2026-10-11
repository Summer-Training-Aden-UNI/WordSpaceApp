import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetMyDrafts implements UseCase<Paginated<Post>, GetMyDraftsParams> {
  final PostRepository repository;
  GetMyDrafts(this.repository);

  @override
  Future<Either<Failure, Paginated<Post>>> call(GetMyDraftsParams params) =>
      repository.getMyDrafts(page: params.page);
}

class GetMyDraftsParams extends Equatable {
  final int page;
  const GetMyDraftsParams({this.page = 1});

  @override
  List<Object?> get props => [page];
}