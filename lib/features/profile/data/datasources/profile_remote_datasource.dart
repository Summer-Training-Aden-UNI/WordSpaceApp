import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/profile_model.dart';

// Name of the multipart avatar field expected by Laravel. Change if different.
const _avatarField = 'avatar';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String name,
    String? username,
    String? bio,
    String? avatarPath,
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
  }) async {
    final fields = <String, dynamic>{
      'name': name,
      if (username != null) 'username': username,
      if (bio != null) 'bio': bio,
    };
    final Response res;
    if (avatarPath != null) {
      // Laravel does not read multipart data on a real PUT: use POST + _method.
      fields['_method'] = 'PUT';
      fields[_avatarField] = await MultipartFile.fromFile(avatarPath);
      res = await dio.post(ApiConstants.profile, data: FormData.fromMap(fields));
    } else {
      res = await dio.put(ApiConstants.profile, data: fields);
    }
    return ProfileModel.fromJson(res.data as Map<String, dynamic>);
  }
}
