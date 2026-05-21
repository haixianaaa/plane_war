/// 认证服务类。
///
/// 封装用户认证相关的业务逻辑，包括：
/// - 账号密码登录
/// - 苹果账号登录
/// - 谷歌账号登录
/// - 邮箱登录
///
/// UI 层只需调用此服务的方法，不需要直接处理网络请求。
/// 后续接入真实 API 时，只需修改此文件即可。
import 'package:flutter_application_2/network/app_network.dart';

class AuthService {
  /// 使用账号密码登录。
  ///
  /// 调用后端 `/auth/login` 接口进行登录。
  /// 登录成功后，Token 会自动保存到 TokenStore。
  ///
  /// [username] 用户名
  /// [password] 密码
  /// [type] 登录类型，默认为 'password'
  ///
  /// 抛出 [ApiException] 如果登录失败
  Future<void> signInWithPassword({
    required String username,
    required String password,
    String type = 'password',
  }) async {
    /// 调用认证 API 进行登录
    await AppNetwork.auth.loginWithPassword(
      username: username,
      password: password,
      type: type,
    );
  }

  /// 使用苹果账号登录。
  ///
  /// TODO: 接入苹果账号登录 API
  /// 需要实现 Sign in with Apple 功能
  Future<void> signInWithApple() async {
    /// 抛出未实现异常，提示功能尚未开发
    throw UnimplementedError('signInWithApple not implemented');
  }

  /// 使用谷歌账号登录。
  ///
  /// TODO: 接入谷歌账号登录 API
  /// 需要实现 Google Sign-In 功能
  Future<void> signInWithGoogle() async {
    /// 抛出未实现异常，提示功能尚未开发
    throw UnimplementedError('signInWithGoogle not implemented');
  }

  /// 使用邮箱登录。
  ///
  /// TODO: 接入邮箱登录 API
  /// 需要实现邮箱验证码登录功能
  Future<void> signInWithEmail() async {
    /// 抛出未实现异常，提示功能尚未开发
    throw UnimplementedError('signInWithEmail not implemented');
  }
}
