import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../error/failures.dart';

/// Runs [action] and converts any thrown error into a [Failure].
/// Repositories wrap every datasource call with this.
Future<Either<Failure, T>> safeCall<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on DioException catch (e) {
    return Left(_mapDioException(e));
  } catch (e) {
    return Left(UnknownFailure(e.toString()));
  }
}

Failure _mapDioException(DioException e) {
  final status = e.response?.statusCode;
  if (status == null) return const NetworkFailure();

  final data = e.response?.data;
  var message = 'Server error ($status)';
  final fieldErrors = <String, List<String>>{};

  if (data is Map) {
    message = data['message']?.toString() ?? message;
    final errors = data['errors'];
    if (errors is Map) {
      errors.forEach((key, value) {
        fieldErrors[key.toString()] = value is List
            ? value.map((x) => x.toString()).toList()
            : [value.toString()];
      });
    }
  }

  if (status == 401) return AuthFailure(message);
  return ServerFailure(message, statusCode: status, fieldErrors: fieldErrors);
}
