// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get navHome => 'ホーム';

  @override
  String get navList => '一覧';

  @override
  String get navMe => 'マイ';

  @override
  String get discoverTitle => 'Find';

  @override
  String get discoverCreate => '作成';

  @override
  String get discoverSearchHint => '検索';

  @override
  String creatorPrefix(String author) {
    return '作成者 $author';
  }

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'システム';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageChinese => '中国語';

  @override
  String get languageKorean => '韓国語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get loginWithApple => 'Appleでログイン';

  @override
  String get loginWithGoogle => 'Googleでログイン';

  @override
  String get loginWithEmail => 'メールでログイン';

  @override
  String get loginAgreePrefix => '続行すると、Auraの';

  @override
  String get loginTerms => '利用規約';

  @override
  String get loginPrivacy => 'プライバシーポリシー';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutConfirmTitle => 'ログアウト';

  @override
  String get logoutConfirmMessage => 'ログアウトしますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get ok => 'OK';

  @override
  String get loginNeedAgreeMessage => 'ログインする前に利用規約とプライバシーポリシーに同意してください。';
}
