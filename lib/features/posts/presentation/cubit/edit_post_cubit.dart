import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/update_post.dart';
import 'create_post_cubit.dart' show PublishStatus;

/// What the Edit screen returns when the post was saved.
class EditPostResult extends Equatable {
  const EditPostResult({required this.post, required this.isDraft});

  final Post post;

  /// The author switched it to Draft, so it is no longer public.
  final bool isDraft;

  @override
  List<Object?> get props => [post, isDraft];
}

class EditPostState extends Equatable {
  const EditPostState({
    this.imagePath,
    this.status = PublishStatus.published,
    this.isSubmitting = false,
    this.errorMessage,
    this.result,
  });

  /// A newly picked cover (null = keep the current one).
  final String? imagePath;
  final PublishStatus status;
  final bool isSubmitting;

  /// One-shot message for a snackbar. Not carried over by [copyWith].
  final String? errorMessage;
  final EditPostResult? result;

  EditPostState copyWith({
    String? imagePath,
    PublishStatus? status,
    bool? isSubmitting,
    String? errorMessage,
    EditPostResult? result,
  }) =>
      EditPostState(
        imagePath: imagePath ?? this.imagePath,
        status: status ?? this.status,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: errorMessage,
        result: result ?? this.result,
      );

  @override
  List<Object?> get props =>
      [imagePath, status, isSubmitting, errorMessage, result];
}

/// Drives the Edit Post form. The text fields live in the page controllers.
class EditPostCubit extends Cubit<EditPostState> {
  EditPostCubit({required Post original, required UpdatePost updatePost})
      : _original = original,
        _updatePost = updatePost,
        super(const EditPostState());

  final Post _original;
  final UpdatePost _updatePost;

  void setImage(String path) => emit(state.copyWith(imagePath: path));

  void setStatus(PublishStatus status) =>
      emit(state.copyWith(status: status));

  Future<void> submit({required String title, required String body}) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true));

    final result = await _updatePost(
      UpdatePostParams(
        id: _original.id,
        title: title.trim(),
        body: body.trim(),
        status: state.status.apiValue,
        imagePath: state.imagePath,
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        // Laravel validation errors: show the first one.
        final fields = failure is ServerFailure
            ? failure.fieldErrors
            : const <String, List<String>>{};
        final firstField = fields.values.expand((l) => l).firstOrNull;

        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: firstField ?? failure.message,
        ));
      },
      (post) => emit(state.copyWith(
        isSubmitting: false,
        result: EditPostResult(
          // The update response may not carry the live counters: keep ours.
          post: post.copyWith(
            likeCount: _original.likeCount,
            commentCount: _original.commentCount,
            isLiked: _original.isLiked,
          ),
          isDraft: state.status == PublishStatus.draft,
        ),
      )),
    );
  }
}