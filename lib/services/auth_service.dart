/// 预留：后续把这里替换为你的真实登录 API 调用（例如 dio/http + 后端接口）。
///
/// 你可以把三方登录、邮箱登录的实现都收敛到这里，UI 只负责调用，不直接写网络逻辑。
class AuthService {
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
