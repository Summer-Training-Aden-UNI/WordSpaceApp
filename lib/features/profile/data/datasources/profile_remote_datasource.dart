import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/profile_model.dart';

// Name of the multipart avatar field expected by the API.
const _avatarField = 'avatar';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String name,
    String? username,
    String? bio,
    String? avatarPath,
    bool removeAvatar = false,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<ProfileModel> getProfile() async {
    final res = await dio.get(ApiConstants.profile);
    return ProfileModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileModel> updateProfile({
    required String name,
    String? username,
    String? bio,
    String? avatarPath,
    bool removeAvatar = false,
  }) async {
    // The API takes multipart/form-data sent with POST and _method=PUT
    // (PHP does not read form-data on a real PUT).
    final fields = <String, dynamic>{
      '_method': 'PUT',
      'name': name,
      'username': ?username,
      'bio': ?bio,
      if (removeAvatar) 'remove_avatar': '1',
    };

    if (avatarPath != null && !removeAvatar) {
      fields[_avatarField] = await MultipartFile.fromFile(avatarPath);
    }

    final res = await dio.post(
      ApiConstants.profile,
      data: FormData.fromMap(fields),
    );
    return ProfileModel.fromJson(res.data as Map<String, dynamic>);
  }
}