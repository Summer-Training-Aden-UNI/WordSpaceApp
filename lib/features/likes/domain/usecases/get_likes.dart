import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/paginated.dart';
import '../../../follow/domain/entities/public_user.dart';
import '../repositories/like_repository.dart';

class GetLikes implements UseCase<Paginated<PublicUser>, GetLikesParams> {
  final LikeRepository repository;
  GetLikes(this.repository);

  @override
  Future<Either<Failure, Paginated<PublicUser>>> call(GetLikesParams params) =>
      repository.getLikes(params.postId, page: params.page);
}

class GetLikesParams extends Equatable {
  final int postId;
  final int page;
  const GetLikesParams({required this.postId, this.page = 1});

  @override
  List<Object?> get props => [postId, page];
}
