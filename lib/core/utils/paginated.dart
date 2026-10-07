import 'package:equatable/equatable.dart';

/// Wraps a Laravel paginated Resource collection: { data: [...], meta: {...} }.
class Paginated<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final int lastPage;

  const Paginated({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });

  factory Paginated.empty() =>
      Paginated<T>(items: <T>[], currentPage: 1, lastPage: 1);

  bool get hasMore => currentPage < lastPage;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    final list = (json['data'] as List? ?? [])
        .map((e) => fromItem(e as Map<String, dynamic>))
        .toList();
    final meta = json['meta'] as Map<String, dynamic>?;
    return Paginated<T>(
      items: list,
      currentPage: (meta?['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta?['last_page'] as num?)?.toInt() ?? 1,
    );
  }

  /// Accepts either a paginated object ({data, meta}) or a plain JSON list.
  factory Paginated.fromResponse(
    dynamic body,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    if (body is List) {
      return Paginated<T>(
        items: body.map((e) => fromItem(e as Map<String, dynamic>)).toList(),
        currentPage: 1,
        lastPage: 1,
      );
    }
    return Paginated.fromJson(body as Map<String, dynamic>, fromItem);
  }

  @override
  List<Object?> get props => [items, currentPage, lastPage];
}
