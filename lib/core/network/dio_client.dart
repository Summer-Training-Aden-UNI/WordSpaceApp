import 'package:dio/dio.dart';
import 'auth_interceptor.dart';
import '../constants/api_constants.dart';
import '../storage/token_storage.dart';

class DioClient {
  final Dio dio;

  /// [onUnauthorized] is called after a 401 (token already cleared) so the
  /// app can send the user back to the login screen.
  DioClient(TokenStorage tokenStorage, {void Function()? onUnauthorized})
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Accept': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      AuthInterceptor(tokenStorage, onUnauthorized: onUnauthorized),
    );
  }
}
