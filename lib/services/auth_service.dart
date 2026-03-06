// 预留：后续把这里替换为你的真实登录 API 调用（例如 dio/http + 后端接口）。
//
// 你可以把三方登录、邮箱登录的实现都收敛到这里，UI 只负责调用，不直接写网络逻辑。
import 'package:flutter_application_2/network/app_network.dart';

class AuthService {
  /// 联调示例：账号密码登录（后端给的 `/auth/login`）。
  ///
  /// TODO: 后续你接入真实表单输入后，把 username/password/type 从 UI 传进来。
  Future<void> signInWithPassword({
    required String username,
    required String password,
    String type = 'password',
  }) async {
    await AppNetwork.auth.loginWithPassword(
      username: username,
      password: password,
      type: type,
    );
  }

  Future<void> signInWithApple() async {
    // TODO: 接入苹果账号登录 API
    throw UnimplementedError('signInWithApple not implemented');
  }

  Future<void> signInWithGoogle() async {
    // TODO: 接入谷歌账号登录 API
    throw UnimplementedError('signInWithGoogle not implemented');
  }

  Future<void> signInWithEmail() async {
    // TODO: 接入邮箱登录 API
    throw UnimplementedError('signInWithEmail not implemented');
  }
}
