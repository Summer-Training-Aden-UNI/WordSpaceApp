import '../../../../core/network/api_consumer.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
  });
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer api;
  AuthRemoteDataSourceImpl(this.api);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final res = await api.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(res as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await api.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'username': username,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return AuthResponseModel.fromJson(res as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await api.post(ApiConstants.logout);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final res = await api.get(ApiConstants.user);
    return UserModel.fromJson(res as Map<String, dynamic>);
  }
}
