import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

// This interceptor adds the saved token to every request. On a 401 it clears the token
// and tells the app the session is over.
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final void Function()? _onUnauthorized;

  AuthInterceptor(this._tokenStorage, {void Function()? onUnauthorized})
      : _onUnauthorized = onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.read();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _tokenStorage.clear();
      _onUnauthorized?.call();
    }
    handler.next(err);
  }
}