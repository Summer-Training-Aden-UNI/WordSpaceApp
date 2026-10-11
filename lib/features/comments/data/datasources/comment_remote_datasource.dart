import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/utils/json_helpers.dart';
import '../../../../core/utils/paginated.dart';
import '../models/comment_model.dart';

// Name of the request field Laravel validates for the comment text.
const _bodyField = 'content';

abstract class CommentRemoteDataSource {
  Future<Paginated<CommentModel>> getComments(int postId, {int page = 1});
  Future<CommentModel> addComment(int postId, String body);
  Future<void> deleteComment(int commentId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final ApiConsumer api;
  CommentRemoteDataSourceImpl(this.api);

  @override
  Future<Paginated<CommentModel>> getComments(int postId, {int page = 1}) async {
    final res = await api.get(
      ApiConstants.postComments(postId),
      queryParameters: {'page': page},
    );
    return Paginated.fromResponse(res, CommentModel.fromJson);
  }

  @override
  Future<CommentModel> addComment(int postId, String body) async {
    final res = await api.post(
      ApiConstants.postComments(postId),
      data: {_bodyField: body},
    );
    return CommentModel.fromJson(unwrap(res));
  }

  @override
  Future<void> deleteComment(int commentId) async {
    await api.delete(ApiConstants.comment(commentId));
  }
}