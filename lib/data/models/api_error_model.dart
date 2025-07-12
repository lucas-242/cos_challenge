class ApiError {
  const ApiError({
    required this.msgKey,
    required this.message,
    required this.params,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      msgKey: json['msgKey'],
      message: json['message'],
      params: Map<String, dynamic>.from(json['params'] ?? {}),
    );
  }

  final String msgKey;
  final String message;
  final Map<String, dynamic> params;
}
