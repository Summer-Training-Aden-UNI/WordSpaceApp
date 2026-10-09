
part of 'create_post_cubit.dart';

/// Matches the publishing options in the Create Post screen.
enum PublishStatus {
  published,
  draft;

  String get apiValue =>
      this == PublishStatus.published ? 'published' : 'draft';
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

  /// Error message for the next UI notification.
  final String? errorMessage;

  /// Validation errors returned by Laravel.
  final Map<String, List<String>> fieldErrors;

  /// Set when a post has been created successfully.
  final Post? createdPost;

  CreatePostState copyWith({
    String? imagePath,
    bool clearImage = false,
    PublishStatus? status,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    Map<String, List<String>>? fieldErrors,
    Post? createdPost,
    bool clearCreatedPost = false,
  }) {
    return CreatePostState(
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      status: status ?? this.status,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      createdPost: clearCreatedPost ? null : createdPost,
    );
  }

  String? fieldError(String key) => fieldErrors[key]?.firstOrNull;

  @override
  List<Object?> get props => [
        imagePath,
        status,
        isSubmitting,
        errorMessage,
        fieldErrors,
        createdPost,
      ];
}
