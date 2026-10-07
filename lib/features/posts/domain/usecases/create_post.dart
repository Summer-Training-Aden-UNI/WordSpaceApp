import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class CreatePost implements UseCase<Post, CreatePostParams> {
  final PostRepository repository;
  CreatePost(this.repository);

  @override
  Future<Either<Failure, Post>> call(CreatePostParams params) =>
      repository.createPost(title: params.title, body: params.body, status: params.status, imagePath: params.imagePath);
}

class CreatePostParams extends Equatable {
  final String title;
  final String body;
  final String? status;
  final String? imagePath;
  const CreatePostParams({required this.title, required this.body, this.status, this.imagePath});

  @override
  List<Object?> get props => [title, body, status, imagePath];
}
