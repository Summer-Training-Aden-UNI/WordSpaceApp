import '../../../../core/network/api_consumer.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultModel> search(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiConsumer api;
  SearchRemoteDataSourceImpl(this.api);

  @override
  Future<SearchResultModel> search(String query) async {
    final res = await api.get(
      ApiConstants.search,
      queryParameters: {'q': query},
    );
    return SearchResultModel.fromJson(res as Map<String, dynamic>);
  }
}
