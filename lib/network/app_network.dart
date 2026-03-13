import 'api_client.dart';
import 'app_config.dart';
import 'auth_api.dart';
import 'chat_api.dart';
import 'token_store.dart';

/// App-wide network singletons.
///
/// Base URL is configurable via:
/// - `flutter run --dart-define=API_BASE_URL=https://example.com`
class AppNetwork {
  AppNetwork._();

  static String get baseUrl => AppConfig.normalizeBaseUrl(AppConfig.apiBaseUrl);

  static final TokenStore tokenStore = TokenStore();

  static Future<void> init() async {
    await tokenStore.load();
  }

  static final ApiClient api = ApiClient(
    baseUrl: baseUrl,
    tokenStore: tokenStore,
  );

  static final AuthApi auth = AuthApi(api, tokenStore);

  static final ChatApi chat = ChatApi(api);
}


