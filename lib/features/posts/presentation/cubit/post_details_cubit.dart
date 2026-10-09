import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/post.dart';
import 'post_details_state.dart';

class PostDetailsCubit extends Cubit<PostDetailsState> {
  PostDetailsCubit(Post post)
      : super(PostDetailsLoaded(post));

  void updatePost(Post post) {
    emit(PostDetailsLoaded(post));
  }

  void showError(String message) {
    emit(PostDetailsError(message));
  }
}