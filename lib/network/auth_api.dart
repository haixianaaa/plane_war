import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_error.dart';
import 'token_store.dart';

/// 认证 API 类。
///
/// 提供用户认证相关的 API 接口，包括登录、登出等操作。
/// 登录成功后会自动将 Token 存储到 TokenStore。
class AuthApi {
  /// 创建认证 API 实例。
  ///
  /// [_client] API 客户端实例，用于发送请求
  /// [_tokenStore] Token 存储实例，用于保存登录凭证
  AuthApi(this._client, this._tokenStore);

  /// API 客户端实例
  final ApiClient _client;

  /// Token 存储实例
  final TokenStore _tokenStore;

  /// 使用用户名和密码登录。
  ///
  /// 后端接口：POST `/auth/login`
  /// 请求体：`{ username, password, type }`
  /// 响应：`{ code, msg, data: { token, ... } }`
  ///
  /// [username] 用户名
  /// [password] 密码
  /// [type] 登录类型，默认为 'password'
  ///
  /// 返回登录成功后的 Token
  ///
  /// 抛出 [ApiException] 如果登录失败
  Future<String> loginWithPassword({
    required String username,
    required String password,
    String type = 'password',
  }) async {
    /// 发送登录请求
    final res = await _client.post<Map<String, dynamic>>(
      '/auth/login',
      data: <String, dynamic>{
        'username': username,
        'password': password,
        'type': type,
      },
      /// 登录接口不需要认证头
      options: Options(extra: const {'auth': false}),
      decoder: (raw) => raw is Map<String, dynamic> ? raw : <String, dynamic>{},
    );

    /// 检查响应是否成功
    if (!res.isSuccess) {
      throw ApiException(res.msg, code: res.code, data: res.data);
    }

    /// 提取 Token
    final token = (res.data?['token'] as String?)?.trim();
    if (token == null || token.isEmpty) {
      throw ApiException('Missing token in response', data: res.data);
    }

    /// 保存 Token 到存储
    _tokenStore.setToken(token);

    return token;
  }
}
