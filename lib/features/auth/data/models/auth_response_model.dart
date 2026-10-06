import 'user_model.dart';

/// Response of /login and /register: a Sanctum token + the user.
class AuthResponseModel {
  final String token;
  final UserModel user;

  const AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    final token = root['token'] ?? root['access_token'];
    if (token == null) {
      throw const FormatException('No token found in auth response');
    }
    return AuthResponseModel(
      token: token.toString(),
      user: UserModel.fromJson(root['user'] as Map<String, dynamic>),
    );
  }
}
