import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.remote, required this.tokenStorage});

  @override
  Future<Either<Failure, User>> login(String email, String password) =>
      safeCall(() async {
        final result = await remote.login(email, password);
        await tokenStorage.save(result.token);
        return result.user;
      });

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) =>
      safeCall(() async {
        final result = await remote.register(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );
        await tokenStorage.save(result.token);
        return result.user;
      });

  @override
  Future<Either<Failure, Unit>> logout() async {
    final result = await safeCall(() async {
      await remote.logout();
      return unit;
    });
    // Always forget the token locally, even if the server call failed.
    await tokenStorage.clear();
    return result;
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() =>
      safeCall(() => remote.getCurrentUser());
}
