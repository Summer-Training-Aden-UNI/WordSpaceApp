import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.name,
    required super.email,
    super.avatarUrl,
  });

  /// Handles both `{id, name, ...}` and Laravel Resource `{data: {id, ...}}`.
  /// Only `/user` sends `avatar_url`; login sends the raw `avatar` column,
  /// which is not a URL, so it is ignored.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final j = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return UserModel(
      id: (j['id'] as num).toInt(),
      name: j['name']?.toString() ?? '',
      username: j['username']?.toString() ?? '',
      email: j['email']?.toString() ?? '',
      avatarUrl: j['avatar_url']?.toString(),
    );
  }
}