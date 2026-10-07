import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/paginated.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts implements UseCase<Paginated<Post>, GetPostsParams> {
  final PostRepository repository;
  GetPosts(this.repository);

  @override
  Future<Either<Failure, Paginated<Post>>> call(GetPostsParams params) =>
      repository.getPosts(page: params.page, search: params.search);
}

class GetPostsParams extends Equatable {
  final int page;
  final String? search;
  const GetPostsParams({this.page = 1, this.search});

  @override
  List<Object?> get props => [page, search];
}
