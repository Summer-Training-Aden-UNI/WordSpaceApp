import '../../domain/entities/public_user.dart';

class PublicUserModel extends PublicUser {
  const PublicUserModel({
    required super.id,
    required super.name,
    super.username,
  });

  // NOTE: field names are guessed. Adjust to match PublicUserResource.php.
  factory PublicUserModel.fromJson(Map<String, dynamic> json) {
    return PublicUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString(),
    );
  }
}
