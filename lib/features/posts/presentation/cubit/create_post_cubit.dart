import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/create_post.dart';

part 'create_post_state.dart';

/// Drives the Create Post form: cover image, publish status and submit.
/// The text fields live in controllers inside the page.
class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit({required CreatePost createPost})
      : _createPost = createPost,
        super(const CreatePostState());

  final CreatePost _createPost;

  void setImage(String path) => emit(state.copyWith(imagePath: path));

  void removeImage() => emit(state.copyWith(clearImage: true));

  void setStatus(PublishStatus status) => emit(state.copyWith(status: status));

  Future<void> submit({required String title, required String body}) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, fieldErrors: const {}));

    final result = await _createPost(
      CreatePostParams(
        title: title.trim(),
        body: body.trim(),
        status: state.status.apiValue,
        imagePath: state.imagePath,
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        final fields = failure is ServerFailure
            ? failure.fieldErrors
            : const <String, List<String>>{};
        emit(
          state.copyWith(
            isSubmitting: false,
            fieldErrors: fields,
            // Field errors are shown under the fields, so no snackbar then.
            errorMessage: fields.isNotEmpty
                ? null
                : failure is AuthFailure
                    ? 'Sign in to create posts.'
                    : failure.message,
          ),
        );
      },
      (post) => emit(state.copyWith(isSubmitting: false, createdPost: post)),
    );
  }
}