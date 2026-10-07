import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    super.username,
    super.email,
    super.bio,
    super.avatarUrl,
  });

  // NOTE: field names are guesses. Check them against the profile Resource.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final j = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json['user'] is Map<String, dynamic>
            ? json['user'] as Map<String, dynamic>
            : json;
    return ProfileModel(
      id: (j['id'] as num).toInt(),
      name: j['name']?.toString() ?? '',
      username: j['username']?.toString(),
      email: j['email']?.toString(),
      bio: j['bio']?.toString(),
      avatarUrl: (j['avatar_url'] ?? j['avatar'] ?? j['image'])?.toString(),
    );
  }
}
