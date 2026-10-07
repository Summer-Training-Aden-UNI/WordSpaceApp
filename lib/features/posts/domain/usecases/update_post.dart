import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class UpdatePost implements UseCase<Post, UpdatePostParams> {
  final PostRepository repository;
  UpdatePost(this.repository);

  @override
  Future<Either<Failure, Post>> call(UpdatePostParams params) =>
      repository.updatePost(params.id, title: params.title, body: params.body, status: params.status, imagePath: params.imagePath);
}

class UpdatePostParams extends Equatable {
  final int id;
  final String title;
  final String body;
  final String? status;
  final String? imagePath;
  const UpdatePostParams({required this.id, required this.title, required this.body, this.status, this.imagePath});

  @override
  List<Object?> get props => [id, title, body, status, imagePath];
}
