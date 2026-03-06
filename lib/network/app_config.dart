class AppConfig {
  AppConfig._();

  /// Configure via:
  /// - `flutter run --dart-define=API_BASE_URL=https://example.com`
  ///
  /// Default: Cloudflare tunnel domain (no trailing slash).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://certainly-posing-blackberry-touch.trycloudflare.com',
  );

  static String normalizeBaseUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return apiBaseUrl;
    return trimmed.endsWith('/') ? trimmed.substring(0, trimmed.length - 1) : trimmed;
  }
}


