import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// App-wide brand theme values (colors + button gradients) in one place.
///
/// Update this file to change the overall purple theme and the primary button
/// gradient parameters globally.
@immutable
class AppBrandTheme extends ThemeExtension<AppBrandTheme> {
  const AppBrandTheme({
    required this.seedColor,
    required this.accentColor,
    required this.navUnselectedColor,
    required this.primaryButtonGradient,
    required this.primaryButtonShadows,
    required this.primaryButtonHighlightOverlayGradient,
    required this.primaryButtonBlurSigma,
  });

  /// Used to generate Material ColorScheme, and for some "selected" states.
  final Color seedColor;

  /// Used for outline buttons, accents, and some icons.
  final Color accentColor;

  /// Used for nav unselected label/icon default in this app.
  final Color navUnselectedColor;

  /// Default gradient for the primary frosted pill button.
  final LinearGradient primaryButtonGradient;

  /// Default shadows for the primary frosted pill button.
  final List<BoxShadow> primaryButtonShadows;

  /// Default highlight overlay gradient for the primary frosted pill button.
  final LinearGradient primaryButtonHighlightOverlayGradient;

  /// Default blur sigma for the primary frosted pill button.
  final double primaryButtonBlurSigma;

  static const AppBrandTheme light = AppBrandTheme(
    seedColor: Color(0xFF8D5CF6),
    accentColor: Color(0xFF9A62F8),
    navUnselectedColor: Color(0xFF4F4F4F),
    primaryButtonBlurSigma: 10,
    primaryButtonGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xE6DEB2FF), // 左：柔粉紫
        Color(0xE6B794FF), // 中：稍冷静的浅紫
        Color(0xE6DEB2FF), // 右：柔粉紫
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    primaryButtonShadows: [
      // 顶部微白的高光阴影，增强立体发光感
      BoxShadow(
        color: Color(0x66FFFFFF),
        blurRadius: 16,
        offset: Offset(0, -4),
      ),
      // 底部的紫粉色柔光投影
      BoxShadow(
        color: Color(0x4DB794FF), // 与按钮同色系的柔光
        blurRadius: 28,
        spreadRadius: -2, // 负扩散让光晕不至于太散，更显高级
        offset: Offset(0, 12),
      ),
    ],
    primaryButtonHighlightOverlayGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x59FFFFFF), // 顶部高光（0.35）
        Color(0x00FFFFFF), // 中间通透
        Color(0x0DFFFFFF), // 底部微反光（0.05）
      ],
      stops: [0.0, 0.4, 1.0],
    ),
  );

  static AppBrandTheme of(BuildContext context) {
    return Theme.of(context).extension<AppBrandTheme>() ?? AppBrandTheme.light;
  }

  @override
  AppBrandTheme copyWith({
    Color? seedColor,
    Color? accentColor,
    Color? navUnselectedColor,
    LinearGradient? primaryButtonGradient,
    List<BoxShadow>? primaryButtonShadows,
    LinearGradient? primaryButtonHighlightOverlayGradient,
    double? primaryButtonBlurSigma,
  }) {
    return AppBrandTheme(
      seedColor: seedColor ?? this.seedColor,
      accentColor: accentColor ?? this.accentColor,
      navUnselectedColor: navUnselectedColor ?? this.navUnselectedColor,
      primaryButtonGradient: primaryButtonGradient ?? this.primaryButtonGradient,
      primaryButtonShadows: primaryButtonShadows ?? this.primaryButtonShadows,
      primaryButtonHighlightOverlayGradient:
          primaryButtonHighlightOverlayGradient ?? this.primaryButtonHighlightOverlayGradient,
      primaryButtonBlurSigma: primaryButtonBlurSigma ?? this.primaryButtonBlurSigma,
    );
  }

  @override
  AppBrandTheme lerp(ThemeExtension<AppBrandTheme>? other, double t) {
    if (other is! AppBrandTheme) return this;
    return AppBrandTheme(
      seedColor: Color.lerp(seedColor, other.seedColor, t) ?? seedColor,
      accentColor: Color.lerp(accentColor, other.accentColor, t) ?? accentColor,
      navUnselectedColor:
          Color.lerp(navUnselectedColor, other.navUnselectedColor, t) ?? navUnselectedColor,
      primaryButtonGradient: LinearGradient.lerp(primaryButtonGradient, other.primaryButtonGradient, t)
          ?? primaryButtonGradient,
      primaryButtonShadows: t < 0.5 ? primaryButtonShadows : other.primaryButtonShadows,
      primaryButtonHighlightOverlayGradient: LinearGradient.lerp(
            primaryButtonHighlightOverlayGradient,
            other.primaryButtonHighlightOverlayGradient,
            t,
          ) ??
          primaryButtonHighlightOverlayGradient,
      primaryButtonBlurSigma: lerpDouble(primaryButtonBlurSigma, other.primaryButtonBlurSigma, t) ??
          primaryButtonBlurSigma,
    );
  }
}

/// App Theme factory.
@immutable
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final brand = AppBrandTheme.light;
    final scheme = ColorScheme.fromSeed(seedColor: brand.seedColor);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'sans-serif',
      extensions: const [AppBrandTheme.light],
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
              color: selected ? brand.seedColor : brand.navUnselectedColor,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(color: selected ? brand.seedColor : brand.navUnselectedColor);
          },
        ),
      ),
    );
  }
}


