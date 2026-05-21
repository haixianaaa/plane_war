/// 统一的 API 异常类型定义。
///
/// 提供统一的异常处理机制，区分业务异常和网络异常。

/// API 通用异常类。
///
/// 封装 API 调用过程中可能发生的各种异常情况。
/// 包含错误消息、错误码、响应数据和原始异常信息。
class ApiException implements Exception {
  /// 创建 API 异常实例。
  ///
  /// [message] 错误消息，描述异常原因
  /// [code] 错误码，来自后端响应或自定义
  /// [data] 响应数据，可能包含详细的错误信息
  /// [cause] 原始异常，用于追踪异常链
  ApiException(this.message, {this.code, this.data, this.cause});

  /// 错误消息，描述异常的具体原因
  final String message;

  /// 错误码，用于区分不同类型的错误
  /// 通常来自后端响应的 code 字段
  final int? code;

  /// 响应数据，可能包含详细的错误信息
  final Object? data;

  /// 原始异常，用于追踪异常链
  final Object? cause;

  /// 返回异常的字符串表示。
  ///
  /// 格式：ApiException(code: {code}, message: {message})
  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}

/// 网络异常类。
///
/// 继承自 ApiException，专门用于表示网络层面的异常。
/// 包括连接超时、请求取消、网络不可用等情况。
class NetworkException extends ApiException {
  /// 创建网络异常实例。
  ///
  /// [message] 错误消息
  /// [cause] 原始异常（通常是 DioException）
  NetworkException(super.message, {super.cause});
}
