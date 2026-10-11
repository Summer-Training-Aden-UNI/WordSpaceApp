import 'package:equatable/equatable.dart';

import '../../../posts/domain/entities/post.dart';

enum ProfileStatus { loading, success, failure }
enum ProfileTab { published, drafts }

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
    this.draftsCount = 0,
  });

  final int id;
  final String name;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final int postsCount;
  final int followersCount;
  final int draftsCount;

  @override
  List<Object?> get props =>
      [id, name, username, bio, avatarUrl, postsCount, followersCount, draftsCount];
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
    this.tab = ProfileTab.published,
    this.drafts = const [],
    this.draftsPage = 1,
    this.draftsHasMore = false,
    this.isLoadingDrafts = false,
    this.draftsError,
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
  /// Which list is shown on my own profile.
  final ProfileTab tab;
  final List<Post> drafts;
  final int draftsPage;
  final bool draftsHasMore;
  final bool isLoadingDrafts;
  final String? draftsError;

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
    ProfileTab? tab,
    List<Post>? drafts,
    int? draftsPage,
    bool? draftsHasMore,
    bool? isLoadingDrafts,
    String? draftsError,
    bool clearDraftsError = false,
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
        tab: tab ?? this.tab,
        drafts: drafts ?? this.drafts,
        draftsPage: draftsPage ?? this.draftsPage,
        draftsHasMore: draftsHasMore ?? this.draftsHasMore,
        isLoadingDrafts: isLoadingDrafts ?? this.isLoadingDrafts,
        draftsError:
            clearDraftsError ? null : (draftsError ?? this.draftsError),
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
        tab,
        drafts,
        draftsPage,
        draftsHasMore,
        isLoadingDrafts,
        draftsError,
      ];
}