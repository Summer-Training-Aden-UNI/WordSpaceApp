import 'package:dio/dio.dart';

import 'api_consumer.dart';


class DioConsumer implements ApiConsumer {
  final Dio _dio;

  DioConsumer(this._dio);

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final res = await _dio.get(path, queryParameters: queryParameters);
    return res.data;
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    final res = await _dio.post(
      path,
      data: await _body(data, isFormData),
      queryParameters: queryParameters,
    );
    return res.data;
  }

  @override
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    final res = await _dio.patch(
      path,
      data: await _body(data, isFormData),
      queryParameters: queryParameters,
    );
    return res.data;
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final res = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return res.data;
  }

  
  Future<dynamic> _body(dynamic data, bool isFormData) async {
    if (!isFormData) return data;

    final fields = <String, dynamic>{};
    for (final entry in (data as Map<String, dynamic>).entries) {
      final value = entry.value;
      fields[entry.key] = value is ApiFile
          ? await MultipartFile.fromFile(value.path)
          : value;
    }
    return FormData.fromMap(fields);
  }
}