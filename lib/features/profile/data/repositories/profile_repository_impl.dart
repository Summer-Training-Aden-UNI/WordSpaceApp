import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;
  ProfileRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Profile>> getProfile() =>
      safeCall(() => remote.getProfile());

  @override
  Future<Either<Failure, Profile>> updateProfile({
    required String name,
    String? username,
    String? bio,
    String? avatarPath,
    bool removeAvatar = false,
  }) =>
      safeCall(
        () => remote.updateProfile(
          name: name,
          username: username,
          bio: bio,
          avatarPath: avatarPath,
          removeAvatar: removeAvatar,
        ),
      );
}