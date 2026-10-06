import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultModel> search(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;
  SearchRemoteDataSourceImpl(this.dio);

  @override
  Future<SearchResultModel> search(String query) async {
    final res = await dio.get(
      ApiConstants.search,
      queryParameters: {'q': query},
    );
    return SearchResultModel.fromJson(res.data as Map<String, dynamic>);
  }
}
