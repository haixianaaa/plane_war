import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_error.dart';
import 'token_store.dart';

class AuthApi {
  AuthApi(this._client, this._tokenStore);

  final ApiClient _client;
  final TokenStore _tokenStore;

  /// Login with username/password.
  ///
  /// Backend: POST `/auth/login`
  /// Body: `{ username, password, type }`
  /// Response: `{ code, msg, data: { token, ... } }`
  Future<String> loginWithPassword({
    required String username,
    required String password,
    String type = 'password',
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      '/auth/login',
      data: <String, dynamic>{
        'username': username,
        'password': password,
        'type': type,
      },
      options: Options(extra: const {'auth': false}),
      decoder: (raw) => raw is Map<String, dynamic> ? raw : <String, dynamic>{},
    );

    if (!res.isSuccess) {
      throw ApiException(res.msg, code: res.code, data: res.data);
    }

    final token = (res.data?['token'] as String?)?.trim();
    if (token == null || token.isEmpty) {
      throw ApiException('Missing token in response', data: res.data);
    }

    _tokenStore.setToken(token);
    return token;
  }
}


