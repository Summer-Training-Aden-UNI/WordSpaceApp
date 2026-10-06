import '../../../follow/data/models/public_user_model.dart';
import '../../../posts/data/models/post_model.dart';
import '../../domain/entities/search_result.dart';

class SearchResultModel extends SearchResult {
  const SearchResultModel({required super.users, required super.posts});

  /// Response shape: { "users": [...], "posts": [...] } (max 10 each).
  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      users: (json['users'] as List? ?? [])
          .map((e) => PublicUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      posts: (json['posts'] as List? ?? [])
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
