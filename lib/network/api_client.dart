import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_error.dart';
import 'api_response.dart';
import 'auth_interceptor.dart';
import 'token_store.dart';

/// API 客户端类。
///
/// 封装 Dio HTTP 客户端，提供统一的 API 请求接口。
/// 支持：
/// - 自动注入认证头
/// - 统一的响应解析
/// - 错误处理和转换
/// - 调试模式日志
///
/// 使用示例：
/// ```dart
/// final client = ApiClient(baseUrl: 'https://api.example.com');
/// final response = await client.get('/users');
/// ```
class ApiClient {
  /// 创建 API 客户端实例。
  ///
  /// [baseUrl] API 基础 URL
  /// [tokenStore] 可选的 Token 存储实例，用于自动注入认证头
  /// [connectTimeout] 连接超时时间，默认 10 秒
  /// [receiveTimeout] 接收超时时间，默认 20 秒
  /// [enableLog] 是否启用调试日志，默认在调试模式下启用
  ApiClient({
    required String baseUrl,
    TokenStore? tokenStore,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 20),
    bool enableLog = kDebugMode,
  }) : _dio = Dio(
          /// Dio 基础配置
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            responseType: ResponseType.json,
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    /// 如果提供了 Token 存储，添加认证拦截器
    if (tokenStore != null) {
      _dio.interceptors.add(AuthInterceptor(tokenStore));
    }

    /// 如果启用日志，添加日志拦截器
    if (enableLog) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          /// 请求日志
          onRequest: (options, handler) {
            /// 获取认证头信息
            final auth = options.headers['Authorization'];
            String authInfo = 'none';

            /// 解析认证头，只显示 Token 后 6 位
            if (auth is String && auth.startsWith('Bearer ')) {
              final token = auth.substring('Bearer '.length);
              final tail = token.length <= 6 ? token : token.substring(token.length - 6);
              authInfo = 'Bearer ***$tail';
            } else if (auth != null) {
              authInfo = 'custom';
            }

            /// 检查是否为自动注入的认证头
            final injected = options.extra['auth_injected'] == true ? ' (injected)' : '';

            /// 打印请求日志
            debugPrint('[API] → ${options.method} ${options.uri} [auth: $authInfo$injected]');
            handler.next(options);
          },

          /// 响应日志
          onResponse: (response, handler) {
            debugPrint('[API] ← ${response.statusCode} ${response.requestOptions.uri}');
            handler.next(response);
          },

          /// 错误日志
          onError: (e, handler) {
            debugPrint('[API] ✕ ${e.type} ${e.requestOptions.uri}');
            handler.next(e);
          },
        ),
      );
    }
  }

  /// Dio 实例
  final Dio _dio;

  /// 获取原始 Dio 实例。
  ///
  /// 用于需要直接使用 Dio 功能的场景
  Dio get dio => _dio;

  /// 发送 GET 请求。
  ///
  /// [path] 请求路径
  /// [queryParameters] 查询参数
  /// [decoder] 响应数据解码器
  /// [options] 请求选项
  ///
  /// 返回解析后的 API 响应
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object? raw)? decoder,
    Options? options,
  }) async {
    try {
      /// 发送 GET 请求
      final res = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      /// 解析响应
      return _parseApiResponse<T>(res.data, decoder: decoder);
    } on DioException catch (e) {
      /// 转换 Dio 异常为 API 异常
      throw _mapDioError(e);
    }
  }

  /// 发送 POST 请求。
  ///
  /// [path] 请求路径
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [decoder] 响应数据解码器
  /// [options] 请求选项
  ///
  /// 返回解析后的 API 响应
  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? raw)? decoder,
    Options? options,
  }) async {
    try {
      /// 发送 POST 请求
      final res = await _dio.post<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      /// 解析响应
      return _parseApiResponse<T>(res.data, decoder: decoder);
    } on DioException catch (e) {
      /// 转换 Dio 异常为 API 异常
      throw _mapDioError(e);
    }
  }

  /// 发送原始 GET 请求（不解析 `{code,msg,data}` 格式）。
  ///
  /// 用于探测连接性或检查响应头等场景。
  ///
  /// [path] 请求路径
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  ///
  /// 返回原始响应对象
  Future<Response<Object?>> rawGet(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<Object?>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// 解析 API 响应。
  ///
  /// 将原始响应数据解析为 ApiResponse 对象。
  ///
  /// [raw] 原始响应数据
  /// [decoder] 可选的数据解码器
  ///
  /// 返回解析后的 API 响应
  ApiResponse<T> _parseApiResponse<T>(
    Object? raw, {
    T Function(Object? raw)? decoder,
  }) {
    /// 检查响应是否为 JSON 对象
    if (raw is Map<String, dynamic>) {
      return ApiResponse.fromJson<T>(raw, decoder: decoder);
    }

    /// 响应格式不正确
    throw ApiException('Invalid response format: expected JSON object', data: raw);
  }

  /// 将 Dio 异常转换为 API 异常。
  ///
  /// [e] Dio 异常对象
  /// 返回对应的 API 异常
  ApiException _mapDioError(DioException e) {
    /// 处理超时和取消异常
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException('Network timeout', cause: e);
    }
    if (e.type == DioExceptionType.cancel) {
      return NetworkException('Request cancelled', cause: e);
    }

    /// 尝试解析后端返回的错误响应
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final code = (data['code'] as num?)?.toInt();
      final msg = (data['msg'] as String?) ?? e.message ?? 'Request failed';
      return ApiException(msg, code: code, data: data, cause: e);
    }

    /// 其他网络错误
    return NetworkException(e.message ?? 'Network error', cause: e);
  }
}
