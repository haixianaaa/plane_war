// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navList => 'List';

  @override
  String get navMe => 'Me';

  @override
  String get discoverTitle => 'Find';

  @override
  String get discoverCreate => 'Create';

  @override
  String get discoverSearchHint => 'Tap to search';

  @override
  String creatorPrefix(String author) {
    return 'Creator $author';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWithApple => 'Sign in with Apple';

  @override
  String get loginWithGoogle => 'Sign in with Google';

  @override
  String get loginWithEmail => 'Sign in with Email';

  @override
  String get loginAgreePrefix => 'By continuing you agree to the ';

  @override
  String get loginTerms => 'Terms of Service';

  @override
  String get loginPrivacy => 'Privacy Policy';
}
