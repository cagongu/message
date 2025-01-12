class ApiResponse<T> {
  int code;
  String? message;
  T? result;

  ApiResponse({
    this.code = 1000,
    this.message,
    this.result,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      result: json['result'] != null ? fromJsonT(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) tojsonT) {
    return {
      'code': code,
      'message': message,
      'result': tojsonT(result as T),
    };
  }
}
