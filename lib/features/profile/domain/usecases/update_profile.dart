import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile implements UseCase<Profile, UpdateProfileParams> {
  final ProfileRepository repository;
  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) =>
      repository.updateProfile(name: params.name, username: params.username, bio: params.bio, avatarPath: params.avatarPath);
}

class UpdateProfileParams extends Equatable {
  final String name;
  final String? username;
  final String? bio;
  final String? avatarPath;
  const UpdateProfileParams({required this.name, this.username, this.bio, this.avatarPath});

  @override
  List<Object?> get props => [name, username, bio, avatarPath];
}
