import 'package:dio/dio.dart';

import 'token_store.dart';

/// 认证拦截器。
///
/// 自动为请求注入 `Authorization: Bearer <token>` 头。
/// 当 Token 存在且请求未禁用认证时，自动添加认证头。
///
/// 禁用认证的方式：
/// ```dart
/// Options(extra: {'auth': false})
/// ```
class AuthInterceptor extends Interceptor {
  /// 创建认证拦截器实例。
  ///
  /// [_tokenStore] Token 存储实例，用于获取当前 Token
  AuthInterceptor(this._tokenStore);

  /// Token 存储实例
  final TokenStore _tokenStore;

  /// 标记 Token 已注入的 extra 键名
  static const String _injectedFlagKey = 'auth_injected';

  /// 请求拦截处理。
  ///
  /// 在请求发送前自动注入认证头。
  /// 如果请求的 extra 中 'auth' 不为 false，且存在 Token，
  /// 则自动添加 Authorization 头。
  ///
  /// [options] 请求配置
  /// [handler] 拦截器处理器
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// 检查是否启用认证（默认启用）
    final authEnabled = options.extra['auth'] != false;

    /// 如果启用认证且存在 Token
    if (authEnabled && _tokenStore.hasToken) {
      /// 检查是否已存在 Authorization 头
      final hadAuth = options.headers.containsKey('Authorization');

      /// 如果不存在，添加认证头（不覆盖手动设置的）
      options.headers.putIfAbsent(
        'Authorization',
        () => 'Bearer ${_tokenStore.token}',
      );

      /// 标记 Token 已注入（用于日志和调试）
      if (!hadAuth) {
        options.extra[_injectedFlagKey] = true;
      }
    }

    /// 继续处理请求
    handler.next(options);
  }
}
