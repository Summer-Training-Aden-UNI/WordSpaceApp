import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Laravel returned an error (4xx / 5xx). [fieldErrors] holds 422 validation errors.
class ServerFailure extends Failure {
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  const ServerFailure(
    super.message, {
    this.statusCode,
    this.fieldErrors = const {},
  });

  @override
  List<Object?> get props => [message, statusCode, fieldErrors];
}

/// 401 - missing / expired token.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Unauthenticated']);
}

/// No response from the server (offline, wrong IP, timeout).
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Cannot reach the server']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
