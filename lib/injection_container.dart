import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'core/storage/token_storage.dart';

// auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/register.dart';

// search
import 'features/search/data/datasources/search_remote_datasource.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/search.dart';

// posts
import 'features/posts/data/datasources/post_remote_datasource.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/domain/usecases/get_posts.dart';
import 'features/posts/domain/usecases/get_post.dart';
import 'features/posts/domain/usecases/create_post.dart';
import 'features/posts/domain/usecases/update_post.dart';
import 'features/posts/domain/usecases/delete_post.dart';

// comments
import 'features/comments/data/datasources/comment_remote_datasource.dart';
import 'features/comments/data/repositories/comment_repository_impl.dart';
import 'features/comments/domain/repositories/comment_repository.dart';
import 'features/comments/domain/usecases/get_comments.dart';
import 'features/comments/domain/usecases/add_comment.dart';
import 'features/comments/domain/usecases/delete_comment.dart';

// likes
import 'features/likes/data/datasources/like_remote_datasource.dart';
import 'features/likes/data/repositories/like_repository_impl.dart';
import 'features/likes/domain/repositories/like_repository.dart';
import 'features/likes/domain/usecases/get_likes.dart';
import 'features/likes/domain/usecases/like_post.dart';
import 'features/likes/domain/usecases/unlike_post.dart';

// follow
import 'features/follow/data/datasources/follow_remote_datasource.dart';
import 'features/follow/data/repositories/follow_repository_impl.dart';
import 'features/follow/domain/repositories/follow_repository.dart';
import 'features/follow/presentation/follow_store.dart';
import 'features/follow/domain/usecases/search_users.dart';
import 'features/follow/domain/usecases/get_user.dart';
import 'features/follow/domain/usecases/get_user_posts.dart';
import 'features/follow/domain/usecases/get_followers.dart';
import 'features/follow/domain/usecases/get_following.dart';
import 'features/follow/domain/usecases/follow_user.dart';
import 'features/follow/domain/usecases/unfollow_user.dart';

// profile
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/update_profile.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ---- core ----
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => TokenStorage(sl()));
  sl.registerLazySingleton(() => DioClient(sl()));

  // ---- auth ----
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), tokenStorage: sl()),
  );
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // ---- search ----
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl()));
  sl.registerLazySingleton(() => Search(sl()));

  // ---- posts ----
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => GetPost(sl()));
  sl.registerLazySingleton(() => CreatePost(sl()));
  sl.registerLazySingleton(() => UpdatePost(sl()));
  sl.registerLazySingleton(() => DeletePost(sl()));

  // ---- comments ----
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetComments(sl()));
  sl.registerLazySingleton(() => AddComment(sl()));
  sl.registerLazySingleton(() => DeleteComment(sl()));

  // ---- likes ----
  sl.registerLazySingleton<LikeRemoteDataSource>(
    () => LikeRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<LikeRepository>(() => LikeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetLikes(sl()));
  sl.registerLazySingleton(() => LikePost(sl()));
  sl.registerLazySingleton(() => UnlikePost(sl()));

  // ---- follow ----
  sl.registerLazySingleton<FollowRemoteDataSource>(
    () => FollowRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<FollowRepository>(() => FollowRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SearchUsers(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => GetUserPosts(sl()));
  sl.registerLazySingleton(() => GetFollowers(sl()));
  sl.registerLazySingleton(() => GetFollowing(sl()));
  sl.registerLazySingleton(() => FollowUser(sl()));
  sl.registerLazySingleton(() => UnfollowUser(sl()));
  sl.registerLazySingleton(
    () => FollowStore(followUser: sl(), unfollowUser: sl()),
  );

  // ---- profile ----
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));

}
