class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.data,
    this.rawResponse,
  });

  final String message;
  final int? statusCode;
  final int? code;
  final dynamic data;
  final dynamic rawResponse;

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, code: $code, message: $message)';
  }
}
