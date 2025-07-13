class ApiError {
  const ApiError({
    required this.msgKey,
    required this.message,
    required this.params,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
    msgKey: json['msgKey'] ?? '',
    message: json['message'] ?? '',
    params: Map<String, dynamic>.from(json['params'] ?? {}),
  );

  final String msgKey;
  final String message;
  final Map<String, dynamic> params;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiError &&
          runtimeType == other.runtimeType &&
          msgKey == other.msgKey &&
          message == other.message;

  @override
  int get hashCode => msgKey.hashCode ^ message.hashCode;
}
