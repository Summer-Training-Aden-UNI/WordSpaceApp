import '../../../../core/utils/json_helpers.dart';
import '../../domain/entities/follow_result.dart';

class FollowResultModel extends FollowResult {
  const FollowResultModel({
    required super.isFollowing,
    required super.followersCount,
  });

  factory FollowResultModel.fromJson(Map<String, dynamic> json) {
    return FollowResultModel(
      isFollowing: json['is_following'] as bool? ?? false,
      followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
    );
  }

  factory FollowResultModel.fromBody(dynamic body) =>
      FollowResultModel.fromJson(unwrap(body));
}
