import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/json_helpers.dart';
import '../../../../core/utils/paginated.dart';
import '../models/post_model.dart';

// Name of the multipart image field expected by Laravel. Change if different.
const _imageField = 'image';

abstract class PostRemoteDataSource {
  Future<Paginated<PostModel>> getPosts({int page = 1, String? search});
  Future<PostModel> getPost(int id);
  Future<PostModel> createPost({
    required String title,
    required String body,
    String? status,
    String? imagePath,
  });
  Future<PostModel> updatePost(
    int id, {
    required String title,
    required String body,
    String? status,
    String? imagePath,
  });
  Future<void> deletePost(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;
  PostRemoteDataSourceImpl(this.dio);

  @override
  Future<Paginated<PostModel>> getPosts({int page = 1, String? search}) async {
    final res = await dio.get(
      ApiConstants.posts,
      queryParameters: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return Paginated.fromResponse(res.data, PostModel.fromJson);
  }

  @override
  Future<PostModel> getPost(int id) async {
    final res = await dio.get(ApiConstants.post(id));
    return PostModel.fromJson(unwrap(res.data));
  }

  @override
  Future<PostModel> createPost({
    required String title,
    required String body,
    String? status,
    String? imagePath,
  }) async {
    final fields = <String, dynamic>{
      'title': title,
      'content': body,
      'status': ?status,
    };
    final Response res;
    if (imagePath != null) {
      fields[_imageField] = await MultipartFile.fromFile(imagePath);
      res = await dio.post(ApiConstants.posts, data: FormData.fromMap(fields));
    } else {
      res = await dio.post(ApiConstants.posts, data: fields);
    }
    return PostModel.fromJson(unwrap(res.data));
  }

  @override
  Future<PostModel> updatePost(
    int id, {
    required String title,
    required String body,
    String? status,
    String? imagePath,
  }) async {
    final fields = <String, dynamic>{
      'title': title,
      'content': body,
      'status': ?status,
    };
    
    final Response res;
    if (imagePath != null) {
      fields[_imageField] = await MultipartFile.fromFile(imagePath);
      res = await dio.post(ApiConstants.post(id), data: FormData.fromMap(fields));
    } else {
      res = await dio.post(ApiConstants.post(id), data: fields);
    }
    return PostModel.fromJson(unwrap(res.data));
  }

  @override
  Future<void> deletePost(int id) async {
    await dio.delete(ApiConstants.post(id));
  }
}
