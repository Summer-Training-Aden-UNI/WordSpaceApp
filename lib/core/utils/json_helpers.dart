/// Laravel Resources wrap a single object as { "data": {...} }. This returns
/// the inner object when wrapped, or the body itself when not.
Map<String, dynamic> unwrap(dynamic body) {
  final map = body as Map<String, dynamic>;
  final inner = map['data'];
  return inner is Map<String, dynamic> ? inner : map;
}

int? asInt(dynamic v) => v is num ? v.toInt() : int.tryParse('$v');
