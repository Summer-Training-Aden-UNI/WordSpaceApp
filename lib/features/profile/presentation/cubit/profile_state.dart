import 'package:equatable/equatable.dart';

import '../../../posts/domain/entities/post.dart';

enum ProfileStatus { loading, success, failure }

/// What the header needs. It is filled from GET /profile (my profile) or
/// GET /users/{id} (someone else), so the page does not care which one.
class ProfileInfo extends Equatable {
  const ProfileInfo({
    required this.id,
    required this.name,
    this.username,
    this.bio,
    this.avatarUrl,
    this.postsCount = 0,
    this.followersCount = 0,
  });

  final int id;
  final String name;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final int postsCount;
  final int followersCount;

  @override
  List<Object?> get props =>
      [id, name, username, bio, avatarUrl, postsCount, followersCount];
}

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.loading,
    this.info,
    this.posts = const [],
    this.page = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isSaving = false,
    this.errorMessage,
    this.postsError,
    this.actionError,
  });

  final ProfileStatus status;
  final ProfileInfo? info;
  final List<Post> posts;

  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  /// The edit form is being sent.
  final bool isSaving;

  /// The header failed to load -> full error view with Retry.
  final String? errorMessage;

  /// The header loaded but the posts did not.
  final String? postsError;

  /// One-shot message for a failed like / save / load more (snackbar).
  /// Not carried over by [copyWith].
  final String? actionError;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileInfo? info,
    List<Post>? posts,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSaving,
    String? errorMessage,
    String? postsError,
    String? actionError,
  }) =>
      ProfileState(
        status: status ?? this.status,
        info: info ?? this.info,
        posts: posts ?? this.posts,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        isSaving: isSaving ?? this.isSaving,
        errorMessage: errorMessage,
        postsError: postsError ?? this.postsError,
        actionError: actionError,
      );

  @override
  List<Object?> get props => [
        status,
        info,
        posts,
        page,
        hasMore,
        isLoadingMore,
        isSaving,
        errorMessage,
        postsError,
        actionError,
      ];
}