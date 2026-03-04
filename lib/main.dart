import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_2/app/auth_controller.dart';
import 'package:flutter_application_2/app/locale_controller.dart';
import 'package:flutter_application_2/pages/app_entry.dart';
import 'package:flutter_application_2/theme/app_theme.dart';
import 'package:flutter_application_2/widgets/global_tap_haptics.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _localeController = LocaleController();
  static final _authController = AuthController();

  static const _uiStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return LocaleScope(
      controller: _localeController,
      child: AnimatedBuilder(
        animation: _localeController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Find App',
            locale: _localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              if (child == null) return const SizedBox.shrink();
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: _uiStyle,
                child: GlobalTapHaptics(child: child),
              );
            },
            theme: AppTheme.light(),
            home: AuthScope(
              controller: _authController,
              child: AppEntry(authService: authService),
            ),
          );
        },
      ),
    );
  }
}

