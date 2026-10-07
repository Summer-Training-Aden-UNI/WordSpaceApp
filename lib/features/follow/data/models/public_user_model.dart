import '../../domain/entities/public_user.dart';

class PublicUserModel extends PublicUser {
  const PublicUserModel({
    required super.id,
    required super.name,
    super.username,
  });

  // NOTE: field names are guesses. Check them against PublicUserResource.php.
  factory PublicUserModel.fromJson(Map<String, dynamic> json) {
    // Tolerate { user: {...} } and { data: {...} } wrappers.
    final j = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;
    return PublicUserModel(
      id: (j['id'] as num).toInt(),
      name: j['name']?.toString() ?? '',
      username: j['username']?.toString(),
    );
  }
}
