import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  /// Handles both `{id, name, ...}` and Laravel Resource `{data: {id, ...}}`.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final j = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return UserModel(
      id: (j['id'] as num).toInt(),
      name: j['name']?.toString() ?? '',
      email: j['email']?.toString() ?? '',
    );
  }
}
