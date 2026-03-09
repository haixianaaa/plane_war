// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get navHome => '홈';

  @override
  String get navChat => '채팅';

  @override
  String get navList => '발견';

  @override
  String get navMe => '내 정보';

  @override
  String get discoverTitle => 'Find';

  @override
  String get discoverCreate => '만들기';

  @override
  String get discoverSearchHint => '검색';

  @override
  String creatorPrefix(String author) {
    return '제작자 $author';
  }

  @override
  String get language => '언어';

  @override
  String get languageSystem => '시스템';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageChinese => '중국어';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageJapanese => '일본어';

  @override
  String get loginTitle => '로그인';

  @override
  String get loginWithApple => 'Apple로 로그인';

  @override
  String get loginWithGoogle => 'Google로 로그인';

  @override
  String get loginWithEmail => '이메일로 로그인';

  @override
  String get loginAgreePrefix => '계속하면 Aura의 ';

  @override
  String get loginTerms => '서비스 약관';

  @override
  String get loginPrivacy => '개인정보 처리방침';

  @override
  String get logout => '로그아웃';

  @override
  String get logoutConfirmTitle => '로그아웃';

  @override
  String get logoutConfirmMessage => '로그아웃하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get ok => '확인';

  @override
  String get loginNeedAgreeMessage => '로그인하기 전에 서비스 약관 및 개인정보 처리방침에 동의해 주세요.';
}
