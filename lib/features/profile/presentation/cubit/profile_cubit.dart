import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../follow/domain/usecases/get_user.dart';
import '../../../follow/domain/usecases/get_user_posts.dart';
import '../../../follow/presentation/follow_store.dart';
import '../../../likes/domain/usecases/like_post.dart';
import '../../../likes/domain/usecases/unlike_post.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/presentation/cubit/posts_cubit.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_state.dart';

/// Drives the Profile page for me ([isMe]) or for another user.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.userId,
    required this.isMe,
    required GetProfile getProfile,
    required GetUser getUser,
    required GetUserPosts getUserPosts,
    required UpdateProfile updateProfile,
    required LikePost likePost,
    required UnlikePost unlikePost,
    required FollowStore followStore,
    PostsCubit? postsCubit,
  })  : _getProfile = getProfile,
        _getUser = getUser,
        _getUserPosts = getUserPosts,
        _updateProfile = updateProfile,
        _likePost = likePost,
        _unlikePost = unlikePost,
        _followStore = followStore,
        _postsCubit = postsCubit,
        super(const ProfileState());

  final int userId;
  final bool isMe;

  final GetProfile _getProfile;
  final GetUser _getUser;
  final GetUserPosts _getUserPosts;
  final UpdateProfile _updateProfile;
  final LikePost _likePost;
  final UnlikePost _unlikePost;
  final FollowStore _followStore;
  final PostsCubit? _postsCubit;

  final Set<int> _liking = {};

  
  // Load
  

  /// [silent] reloads without the full-screen spinner (pull to refresh) and
  /// keeps what is on screen if the request fails.
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const ProfileState());

    // Start both requests, then wait for them (they run in parallel).
    final infoFuture = isMe ? _loadMine() : _loadOther();
    final postsFuture = _getUserPosts(GetUserPostsParams(userId: userId));

    final infoResult = await infoFuture;
    final postsResult = await postsFuture;
    if (isClosed) return;

    infoResult.fold(
      (failure) {
        if (silent && state.info != null) {
          emit(state.copyWith(actionError: failure.message));
          return;
        }
        emit(ProfileState(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (info) {
        final posts = postsResult.fold((_) => null, (p) => p);
        emit(ProfileState(
          status: ProfileStatus.success,
          info: info,
          posts: posts?.items ?? (silent ? state.posts : const []),
          page: posts?.currentPage ?? 1,
          hasMore: posts?.hasMore ?? false,
          postsError: postsResult.fold((f) => f.message, (_) => null),
        ));
      },
    );
  }

  Future<Either<Failure, ProfileInfo>> _loadMine() async {
    final result = await _getProfile(const NoParams());
    return result.map(
      (p) => ProfileInfo(
        id: p.id,
        name: p.name,
        username: p.username,
        bio: p.bio,
        avatarUrl: p.avatarUrl,
        postsCount: p.stats?.publishedPosts ?? 0,
        followersCount: p.stats?.followersCount ?? 0,
      ),
    );
  }

  Future<Either<Failure, ProfileInfo>> _loadOther() async {
    final result = await _getUser(GetUserParams(userId: userId));
    return result.map((d) {
      // Seeds follow state + follower counter for the Follow button.
      _followStore.seedUser(d);
      return ProfileInfo(
        id: d.user.id,
        name: d.user.name,
        username: d.user.username,
        bio: d.user.bio,
        avatarUrl: d.user.avatarUrl,
        postsCount: d.postsCount,
        followersCount: d.followersCount,
      );
    });
  }

  Future<void> loadMorePosts() async {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getUserPosts(
      GetUserPostsParams(userId: userId, page: state.page + 1),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, actionError: failure.message),
      ),
      (next) {
        final known = state.posts.map((p) => p.id).toSet();
        emit(state.copyWith(
          isLoadingMore: false,
          page: next.currentPage,
          hasMore: next.hasMore,
          posts: [
            ...state.posts,
            ...next.items.where((p) => !known.contains(p.id)),
          ],
        ));
      },
    );
  }

  
  // Like (the profile list is not part of the Home feed, so PostsCubit
  // cannot toggle these posts: we call the use cases ourselves)
  

  Future<void> toggleLike(Post post) async {
    final original = state.posts.where((p) => p.id == post.id).firstOrNull;
    if (original == null || _liking.contains(post.id)) return;
    _liking.add(post.id);

    final liked = !original.isLiked;
    final updated = original.copyWith(
      isLiked: liked,
      likeCount: original.likeCount + (liked ? 1 : -1),
    );
    _replace(updated);
    _syncFeed(updated);

    final result = liked
        ? await _likePost(LikePostParams(postId: post.id))
        : await _unlikePost(UnlikePostParams(postId: post.id));
    _liking.remove(post.id);
    if (isClosed) return;

    result.fold(
      (failure) {
        // 409 = already liked, 404 on unlike = no like: the screen already
        // shows what the server has, so keep it.
        final status = failure is ServerFailure ? failure.statusCode : null;
        if ((liked && status == 409) || (!liked && status == 404)) return;

        _replace(original);
        _syncFeed(original);
        emit(state.copyWith(
          actionError: failure is AuthFailure
              ? 'Sign in to like posts.'
              : failure.message,
        ));
      },
      (_) {},
    );
  }

  
  // Edit (my profile only). Returns true when saved.
  

  Future<bool> saveProfile({
    required String name,
    String? username,
    String? bio,
    String? avatarPath,
    bool removeAvatar = false,
  }) async {
    final current = state.info;
    if (!isMe || current == null || state.isSaving) return false;
    emit(state.copyWith(isSaving: true));

    final result = await _updateProfile(UpdateProfileParams(
      name: name,
      username: username,
      bio: bio,
      avatarPath: avatarPath,
      removeAvatar: removeAvatar,
    ));
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, actionError: failure.message));
        return false;
      },
      (p) {
        emit(state.copyWith(
          isSaving: false,
          info: ProfileInfo(
            id: p.id,
            name: p.name,
            username: p.username,
            bio: p.bio,
            avatarUrl: p.avatarUrl,
            postsCount: current.postsCount,
            followersCount: current.followersCount,
          ),
        ));
        return true;
      },
    );
  }

  

  void _replace(Post post) => emit(state.copyWith(
        posts: [for (final p in state.posts) p.id == post.id ? post : p],
      ));

  /// Keeps the Home feed's heart in step (no API call). Does nothing if the
  /// post is not in the loaded feed.
  void _syncFeed(Post post) {
    final feed = _postsCubit?.state;
    if (feed is! PostsLoaded) return;
    final inFeed = feed.posts.where((p) => p.id == post.id).firstOrNull;
    if (inFeed == null) return;
    _postsCubit!.syncPost(
      inFeed.copyWith(isLiked: post.isLiked, likeCount: post.likeCount),
    );
  }
}
