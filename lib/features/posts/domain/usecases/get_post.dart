import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPost implements UseCase<Post, GetPostParams> {
  final PostRepository repository;
  GetPost(this.repository);

  @override
  Future<Either<Failure, Post>> call(GetPostParams params) =>
      repository.getPost(params.id);
}

class GetPostParams extends Equatable {
  final int id;
  const GetPostParams({required this.id});

  @override
  List<Object?> get props => [id];
}
