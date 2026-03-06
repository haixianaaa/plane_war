import 'package:dio/dio.dart';

import 'token_store.dart';

/// Automatically injects `Authorization: Bearer <token>` when token exists.
///
/// You can disable auth for a request by setting:
/// `Options(extra: {'auth': false})`
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStore);

  final TokenStore _tokenStore;

  static const String _injectedFlagKey = 'auth_injected';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authEnabled = options.extra['auth'] != false;
    if (authEnabled && _tokenStore.hasToken) {
      final hadAuth = options.headers.containsKey('Authorization');
      // Don't overwrite if caller manually set it.
      options.headers.putIfAbsent(
        'Authorization',
        () => 'Bearer ${_tokenStore.token}',
      );
      // Mark as injected for logging/debugging.
      if (!hadAuth) {
        options.extra[_injectedFlagKey] = true;
      }
    }
    handler.next(options);
  }
}


