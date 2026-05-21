import 'api_client.dart';
import 'app_config.dart';
import 'auth_api.dart';
import 'chat_api.dart';
import 'token_store.dart';

/// 应用级网络单例管理类。
///
/// 提供全局统一的网络访问入口，包含：
/// - [api]: 通用 API 客户端
/// - [auth]: 认证相关 API
/// - [chat]: 聊天相关 API
/// - [tokenStore]: Token 存储管理
///
/// 基础 URL 可通过运行时参数配置：
/// ```bash
/// flutter run --dart-define=API_BASE_URL=https://example.com
/// ```
class AppNetwork {
  /// 私有构造函数，防止实例化
  AppNetwork._();

  /// 获取规范化后的 API 基础 URL。
  ///
  /// 自动移除 URL 末尾的斜杠，确保 URL 格式统一
  static String get baseUrl => AppConfig.normalizeBaseUrl(AppConfig.apiBaseUrl);

  /// Token 存储实例，用于管理用户认证令牌
  /// 支持 iOS Keychain 和 Android Keystore 安全存储
  static final TokenStore tokenStore = TokenStore();

  /// 初始化网络模块。
  ///
  /// 在应用启动时调用，加载持久化的 Token。
  /// 必须在 WidgetsFlutterBinding.ensureInitialized() 之后调用
  static Future<void> init() async {
    /// 从安全存储加载 Token
    await tokenStore.load();
  }

  /// 通用 API 客户端实例。
  ///
  /// 用于发送常规 HTTP 请求，自动注入认证头
  static final ApiClient api = ApiClient(
    baseUrl: baseUrl,
    tokenStore: tokenStore,
  );

  /// 认证 API 实例。
  ///
  /// 提供登录、登出等认证相关接口
  static final AuthApi auth = AuthApi(api, tokenStore);

  /// 聊天 API 实例。
  ///
  /// 提供聊天消息发送、流式响应等接口
  static final ChatApi chat = ChatApi(api);
}
