import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
  });
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> getCurrentUser();
}
