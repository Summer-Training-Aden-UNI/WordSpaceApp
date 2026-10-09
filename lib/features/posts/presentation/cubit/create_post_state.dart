part of 'create_post_cubit.dart';

/// Matches the "Publishing Options" radio cards.
/// ASSUMPTION: the Laravel `status` values are 'published' and 'draft'.
/// Change [apiValue] if your API uses different ones.
enum PublishStatus {
  published,
  draft;

  String get apiValue => this == published ? 'published' : 'draft';
}

class CreatePostState extends Equatable {
  const CreatePostState({
    this.imagePath,
    this.status = PublishStatus.published,
    this.isSubmitting = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.createdPost,
  });

  final String? imagePath;
  final PublishStatus status;
  final bool isSubmitting;

  /// One-shot (snackbar). Not carried over by copyWith.
  final String? errorMessage;

  /// Laravel 422 errors, keyed by field name ('title', 'body', 'image').
  final Map<String, List<String>> fieldErrors;

  /// One-shot: set when the post was created. Not carried over.
  final Post? createdPost;

  CreatePostState copyWith({
    String? imagePath,
    bool clearImage = false,
    PublishStatus? status,
    bool? isSubmitting,
    String? errorMessage,
    Map<String, List<String>>? fieldErrors,
    Post? createdPost,
  }) =>
      CreatePostState(
        imagePath: clearImage ? null : (imagePath ?? this.imagePath),
        status: status ?? this.status,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: errorMessage,
        fieldErrors: fieldErrors ?? this.fieldErrors,
        createdPost: createdPost,
      );

  String? fieldError(String key) => fieldErrors[key]?.firstOrNull;

  @override
  List<Object?> get props =>
      [imagePath, status, isSubmitting, errorMessage, fieldErrors, createdPost];
}