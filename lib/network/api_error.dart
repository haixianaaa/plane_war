// Unified API error types.

class ApiException implements Exception {
  ApiException(this.message, {this.code, this.data, this.cause});

  final String message;
  final int? code;
  final Object? data;
  final Object? cause;

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}

class NetworkException extends ApiException {
  NetworkException(super.message, {super.cause});
}


