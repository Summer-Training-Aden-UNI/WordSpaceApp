import '../../../../core/network/api_consumer.dart';

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
  final ApiConsumer api;
  ProfileRemoteDataSourceImpl(this.api);

  @override
  Future<ProfileModel> getProfile() async {
    final res = await api.get(ApiConstants.profile);
    return ProfileModel.fromJson(res as Map<String, dynamic>);
  }

 @override
  Future<ProfileModel> updateProfile({
    required String name,
    String? username,
    String? bio,
    String? avatarPath,
    bool removeAvatar = false,
  }) async {
    // The route only accepts POST (a spoofed _method=PUT gets a 405),
    // sent as multipart/form-data so the avatar file can be attached.
    final fields = <String, dynamic>{
      'name': name,
      'username': ?username,
      'bio': ?bio,
      if (removeAvatar) 'remove_avatar': '1',
    };

    if (avatarPath != null && !removeAvatar) {
      fields[_avatarField] = ApiFile(avatarPath);
    }

    final res = await api.post(
      ApiConstants.profile,
      data: fields,
      isFormData: true,
    );
    return ProfileModel.fromJson(res as Map<String, dynamic>);
  }
}