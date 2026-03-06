import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_error.dart';
import 'api_response.dart';
import 'auth_interceptor.dart';
import 'token_store.dart';

class ApiClient {
  ApiClient({
    required String baseUrl,
    TokenStore? tokenStore,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 20),
    bool enableLog = kDebugMode,
  }) : _dio = Dio(
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
    if (tokenStore != null) {
      _dio.interceptors.add(AuthInterceptor(tokenStore));
    }
    if (enableLog) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final auth = options.headers['Authorization'];
            String authInfo = 'none';
            if (auth is String && auth.startsWith('Bearer ')) {
              final token = auth.substring('Bearer '.length);
              final tail = token.length <= 6 ? token : token.substring(token.length - 6);
              authInfo = 'Bearer ***$tail';
            } else if (auth != null) {
              authInfo = 'custom';
            }
            final injected = options.extra['auth_injected'] == true ? ' (injected)' : '';
            debugPrint('[API] → ${options.method} ${options.uri} [auth: $authInfo$injected]');
            handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('[API] ← ${response.statusCode} ${response.requestOptions.uri}');
            handler.next(response);
          },
          onError: (e, handler) {
            debugPrint('[API] ✕ ${e.type} ${e.requestOptions.uri}');
            handler.next(e);
          },
        ),
      );
    }
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object? raw)? decoder,
    Options? options,
  }) async {
    try {
      final res = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseApiResponse<T>(res.data, decoder: decoder);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? raw)? decoder,
    Options? options,
  }) async {
    try {
      final res = await _dio.post<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseApiResponse<T>(res.data, decoder: decoder);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Raw GET request without parsing `{code,msg,data}`.
  /// Useful for probing connectivity / headers during integration.
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

  ApiResponse<T> _parseApiResponse<T>(
    Object? raw, {
    T Function(Object? raw)? decoder,
  }) {
    if (raw is Map<String, dynamic>) {
      return ApiResponse.fromJson<T>(raw, decoder: decoder);
    }
    throw ApiException('Invalid response format: expected JSON object', data: raw);
  }

  ApiException _mapDioError(DioException e) {
    // network / timeout / cancel
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException('Network timeout', cause: e);
    }
    if (e.type == DioExceptionType.cancel) {
      return NetworkException('Request cancelled', cause: e);
    }

    // If backend returned body, try parse `{code,msg,data}`
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final code = (data['code'] as num?)?.toInt();
      final msg = (data['msg'] as String?) ?? e.message ?? 'Request failed';
      return ApiException(msg, code: code, data: data, cause: e);
    }

    return NetworkException(e.message ?? 'Network error', cause: e);
  }
}


