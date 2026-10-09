import '../../domain/entities/post.dart';

sealed class PostDetailsState {
  const PostDetailsState();
}

class PostDetailsInitial extends PostDetailsState {
  const PostDetailsInitial();
}

class PostDetailsLoaded extends PostDetailsState {
  final Post post;

  const PostDetailsLoaded(this.post);
}

class PostDetailsError extends PostDetailsState {
  final String message;

  const PostDetailsError(this.message);
}