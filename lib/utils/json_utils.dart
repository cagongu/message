List<T> parseList<T>(dynamic json, T Function(dynamic json) fromJson) {
  if (json is List) {
    return json.map((item) => fromJson(item)).toList();
  }
  throw Exception('Invalid JSON format: Expected a list');
}

T parseObject<T>(dynamic json, T Function(dynamic json) fromJson) {
  if (json is Map<String, dynamic>) {
    return fromJson(json);
  }
  throw Exception('Invalid JSON format: Expected an object');
}
