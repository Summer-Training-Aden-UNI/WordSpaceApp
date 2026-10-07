import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/paginated.dart';
import '../../../posts/domain/entities/post.dart';
import '../repositories/follow_repository.dart';

class GetUserPosts implements UseCase<Paginated<Post>, GetUserPostsParams> {
  final FollowRepository repository;
  GetUserPosts(this.repository);

  @override
  Future<Either<Failure, Paginated<Post>>> call(GetUserPostsParams params) =>
      repository.getUserPosts(params.userId, page: params.page);
}

class GetUserPostsParams extends Equatable {
  final int userId;
  final int page;
  const GetUserPostsParams({required this.userId, this.page = 1});

  @override
  List<Object?> get props => [userId, page];
}
