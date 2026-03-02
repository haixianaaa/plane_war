// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get navHome => '主页';

  @override
  String get navList => '列表';

  @override
  String get navMe => '我的';

  @override
  String get discoverTitle => 'Find';

  @override
  String get discoverCreate => '创建';

  @override
  String get discoverSearchHint => '点击搜索';

  @override
  String creatorPrefix(String author) {
    return '创建者 $author';
  }

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageEnglish => '英文';

  @override
  String get languageChinese => '中文';

  @override
  String get languageKorean => '韩文';

  @override
  String get languageJapanese => '日文';

  @override
  String get loginTitle => '登录';

  @override
  String get loginWithApple => '通过苹果账号登录';

  @override
  String get loginWithGoogle => '通过谷歌账号登录';

  @override
  String get loginWithEmail => '使用邮箱登录';

  @override
  String get loginAgreePrefix => '继续使用即表示您同意 ';

  @override
  String get loginTerms => '服务条款';

  @override
  String get loginPrivacy => '隐私政策';
}
