import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_2/app/auth_controller.dart';
import 'package:flutter_application_2/app/locale_controller.dart';
import 'package:flutter_application_2/pages/app_entry.dart';
import 'package:flutter_application_2/widgets/global_tap_haptics.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/services/auth_service.dart';

const _seedColor = Color(0xFF8D5CF6);
const _navSelectedColor = Color(0xFF8D5CF6); // 更深一点的紫色（选中态）
const _navGrey = Color(0xFF4F4F4F);
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
    final scheme = ColorScheme.fromSeed(seedColor: _seedColor);
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
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: scheme,
              fontFamily: 'sans-serif',
              navigationBarTheme: NavigationBarThemeData(
                height: 64,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                indicatorColor: Colors.transparent, // 选中 icon 不要背景色
                overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  // 去掉按下/聚焦等状态下的灰色叠层（你看到的“闪灰”就是它）
                  if (states.contains(WidgetState.pressed) ||
                      states.contains(WidgetState.focused) ||
                      states.contains(WidgetState.hovered)) {
                    return Colors.transparent;
                  }
                  return null; // 其它状态用默认
                }),
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
                  (states) {
                    final selected = states.contains(WidgetState.selected);
                    return TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                      color: selected
                          ? _navSelectedColor
                          : _navGrey, // 灰黑之间（不发白）
                    );
                  },
                ),
                iconTheme: const WidgetStatePropertyAll<IconThemeData>(
                  IconThemeData(color: _navGrey),
                ),
              ),
            ),
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

