import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../posts/domain/entities/post.dart';
import '../repositories/like_repository.dart';

class GetLikedPosts implements UseCase<List<Post>, NoParams> {
  final LikeRepository repository;
  GetLikedPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) =>
      repository.getLikedPosts();
}