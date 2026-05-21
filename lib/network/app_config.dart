/// 应用配置类。
///
/// 管理应用的运行时配置，主要是 API 基础 URL。
/// 支持通过编译时参数配置，便于不同环境使用不同的后端地址。
class AppConfig {
  /// 私有构造函数，防止实例化
  AppConfig._();

  /// API 基础 URL。
  ///
  /// 可通过编译时参数配置：
  /// ```bash
  /// flutter run --dart-define=API_BASE_URL=https://example.com
  /// ```
  ///
  /// 默认值：Cloudflare 隧道域名（无尾部斜杠）
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://bicycle-rubber-formerly-hollywood.trycloudflare.com',
  );

  /// 规范化基础 URL。
  ///
  /// 移除 URL 末尾的斜杠，确保 URL 格式统一。
  /// 如果输入为空，返回默认的 [apiBaseUrl]。
  ///
  /// [url] 待规范化的 URL
  /// 返回规范化后的 URL（无尾部斜杠）
  static String normalizeBaseUrl(String url) {
    /// 去除首尾空白
    final trimmed = url.trim();

    /// 如果为空，返回默认 URL
    if (trimmed.isEmpty) return apiBaseUrl;

    /// 移除末尾斜杠
    return trimmed.endsWith('/') ? trimmed.substring(0, trimmed.length - 1) : trimmed;
  }
}
