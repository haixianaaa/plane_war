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
  String get navChat => 'Chat';

  @override
  String get navList => 'Discover';

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
  String get loginTitle => 'Log in';

  @override
  String get loginWithApple => 'Continue with Apple';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get loginWithEmail => 'Continue with Email';

  @override
  String get loginAgreePrefix => 'By continuing, you agree to Aura\'s ';

  @override
  String get loginTerms => 'Terms of Service';

  @override
  String get loginPrivacy => 'Privacy Policy';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirmTitle => 'Log out';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get ok => 'OK';

  @override
  String get loginNeedAgreeMessage =>
      'Please agree to the Terms of Service and Privacy Policy before logging in.';
}
