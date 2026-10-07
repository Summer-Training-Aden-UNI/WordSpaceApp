import '../../domain/entities/user_details.dart';
import 'public_user_model.dart';

class UserDetailsModel extends UserDetails {
  const UserDetailsModel({
    required super.user,
    required super.followersCount,
    required super.followingCount,
    required super.postsCount,
    super.isFollowing,
  });

  /// Shape (from ApiUserController@show):
  /// { user: {...}, followers_count, following_count, posts_count, is_following? }
  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      user: PublicUserModel.fromJson(json['user'] as Map<String, dynamic>),
      followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
      followingCount: (json['following_count'] as num?)?.toInt() ?? 0,
      postsCount: (json['posts_count'] as num?)?.toInt() ?? 0,
      isFollowing: json['is_following'] as bool?,
    );
  }
}
