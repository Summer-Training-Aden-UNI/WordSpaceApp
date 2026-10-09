
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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

  void setImage(String path) {
    emit(state.copyWith(imagePath: path));
  }

  void removeImage() {
    emit(state.copyWith(clearImage: true));
  }

  void setStatus(PublishStatus status) {
    emit(state.copyWith(status: status));
  }

  Future<void> submit({
    required String title,
    required String body,
  }) async {
    if (state.isSubmitting) return;

    // Clear previous errors and results before submitting again.
    emit(
      state.copyWith(
        isSubmitting: true,
        fieldErrors: const {},
        clearError: true,
        clearCreatedPost: true,
      ),
    );

    try {
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
              errorMessage: fields.isNotEmpty
                  ? null
                  : failure is AuthFailure
                      ? 'Sign in to create posts.'
                      : failure.message,
              clearCreatedPost: true,
            ),
          );
        },
        (post) {
          emit(
            state.copyWith(
              isSubmitting: false,
              createdPost: post,
              clearError: true,
              fieldErrors: const {},
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('Create post exception: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (isClosed) return;

      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Could not create the post. Please try again.',
          clearCreatedPost: true,
        ),
      );
    }
  }
}
