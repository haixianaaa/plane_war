import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// 应用级颜色常量定义。
///
/// 集中管理应用中使用的颜色值，便于统一修改和维护。
/// 所有颜色使用 const 定义，确保性能优化。
class AppColors {
  /// 私有构造函数，防止实例化
  AppColors._();

  /// 主页面背景色。
  /// 浅灰白色，用于页面底色
  static const Color pageBackground = Color(0xFFF7F7FA);

  /// 主要文本颜色。
  /// 深紫色，用于标题和主要内容文本
  static const Color textPrimary = Color(0xFF3B0C56);

  /// 页面顶部背景渐变左侧颜色。
  /// 浅蓝色，用于顶部装饰渐变
  static const Color bgTopLeft = Color(0xFFEAF5FF);

  /// 页面顶部背景渐变右侧颜色。
  /// 浅紫色，用于顶部装饰渐变
  static const Color bgTopRight = Color(0xFFF5EDFF);

  /// 聊天详情页底部输入栏背景色。
  /// 浅灰色，用于输入框区域背景
  static const Color chatBottomBarBackground = Color(0xFFF0F0F5);
}

/// 应用品牌主题配置。
///
/// 继承自 ThemeExtension，用于定义应用的品牌色彩和样式。
/// 包含主色调、强调色、按钮渐变等全局样式配置。
///
/// 修改此文件可以全局更改应用的紫色主题和主按钮渐变参数。
@immutable
class AppBrandTheme extends ThemeExtension<AppBrandTheme> {
  /// 创建品牌主题实例。
  ///
  /// [seedColor] 种子颜色，用于生成 Material ColorScheme
  /// [accentColor] 强调色，用于描边按钮和图标
  /// [navUnselectedColor] 导航栏未选中状态颜色
  /// [primaryButtonGradient] 主按钮渐变背景
  /// [primaryButtonShadows] 主按钮阴影列表
  /// [primaryButtonHighlightOverlayGradient] 主按钮高光叠加渐变
  /// [primaryButtonBlurSigma] 主按钮模糊半径
  const AppBrandTheme({
    required this.seedColor,
    required this.accentColor,
    required this.navUnselectedColor,
    required this.primaryButtonGradient,
    required this.primaryButtonShadows,
    required this.primaryButtonHighlightOverlayGradient,
    required this.primaryButtonBlurSigma,
  });

  /// 种子颜色。
  /// 用于生成 Material ColorScheme，以及一些"选中"状态
  final Color seedColor;

  /// 强调色。
  /// 用于描边按钮、强调元素和某些图标
  final Color accentColor;

  /// 导航栏未选中状态颜色。
  /// 用于导航栏未选中的标签和图标
  final Color navUnselectedColor;

  /// 主按钮渐变背景。
  /// 用于毛玻璃渐变药丸按钮的默认渐变
  final LinearGradient primaryButtonGradient;

  /// 主按钮阴影列表。
  /// 用于毛玻璃渐变药丸按钮的默认阴影
  final List<BoxShadow> primaryButtonShadows;

  /// 主按钮高光叠加渐变。
  /// 用于毛玻璃渐变药丸按钮的默认高光叠加
  final LinearGradient primaryButtonHighlightOverlayGradient;

  /// 主按钮模糊半径。
  /// 用于毛玻璃渐变药丸按钮的默认模糊值
  final double primaryButtonBlurSigma;

  /// 浅色主题品牌配置。
  ///
  /// 定义浅色模式下的所有品牌颜色和样式：
  /// - 主色调：紫色 (#8D5CF6)
  /// - 强调色：稍亮的紫色 (#9A62F8)
  /// - 导航栏未选中色：深灰色 (#4F4F4F)
  static const AppBrandTheme light = AppBrandTheme(
    /// 种子颜色：主紫色
    seedColor: Color(0xFF8D5CF6),

    /// 强调色：稍亮的紫色
    accentColor: Color(0xFF9A62F8),

    /// 导航栏未选中颜色
    navUnselectedColor: Color(0xFF4F4F4F),

    /// 主按钮模糊半径
    primaryButtonBlurSigma: 10,

    /// 主按钮渐变背景
    primaryButtonGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        /// 左：柔粉紫
        Color(0xE6DEB2FF),
        /// 中：稍冷静的浅紫
        Color(0xE6B794FF),
        /// 右：柔粉紫
        Color(0xE6DEB2FF),
      ],
      stops: [0.0, 0.5, 1.0],
    ),

    /// 主按钮阴影
    primaryButtonShadows: [
      /// 顶部微白的高光阴影，增强立体发光感
      BoxShadow(
        color: Color(0x66FFFFFF),
        blurRadius: 16,
        offset: Offset(0, -4),
      ),
      /// 底部的紫粉色柔光投影
      BoxShadow(
        /// 与按钮同色系的柔光
        color: Color(0x4DB794FF),
        blurRadius: 28,
        /// 负扩散让光晕不至于太散，更显高级
        spreadRadius: -2,
        offset: Offset(0, 12),
      ),
    ],

    /// 主按钮高光叠加渐变
    primaryButtonHighlightOverlayGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        /// 顶部高光（透明度 0.35）
        Color(0x59FFFFFF),
        /// 中间通透
        Color(0x00FFFFFF),
        /// 底部微反光（透明度 0.05）
        Color(0x0DFFFFFF),
      ],
      stops: [0.0, 0.4, 1.0],
    ),
  );

  /// 从 BuildContext 获取品牌主题。
  ///
  /// 如果主题中未配置品牌扩展，返回默认的浅色主题。
  ///
  /// [context] 构建上下文
  /// 返回当前的品牌主题配置
  static AppBrandTheme of(BuildContext context) {
    return Theme.of(context).extension<AppBrandTheme>() ?? AppBrandTheme.light;
  }

  /// 创建品牌主题副本。
  ///
  /// 用于修改部分属性，返回新的品牌主题实例。
  ///
  /// [seedColor] 新的种子颜色
  /// [accentColor] 新的强调色
  /// [navUnselectedColor] 新的导航栏未选中颜色
  /// [primaryButtonGradient] 新的主按钮渐变
  /// [primaryButtonShadows] 新的主按钮阴影
  /// [primaryButtonHighlightOverlayGradient] 新的主按钮高光渐变
  /// [primaryButtonBlurSigma] 新的主按钮模糊半径
  ///
  /// 返回新的 AppBrandTheme 实例
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

  /// 线性插值两个品牌主题。
  ///
  /// 用于主题切换动画，在两个主题之间平滑过渡。
  ///
  /// [other] 目标主题
  /// [t] 插值因子（0.0 - 1.0）
  ///
  /// 返回插值后的品牌主题
  @override
  AppBrandTheme lerp(ThemeExtension<AppBrandTheme>? other, double t) {
    /// 如果目标不是 AppBrandTheme，返回当前主题
    if (other is! AppBrandTheme) return this;

    return AppBrandTheme(
      /// 颜色插值
      seedColor: Color.lerp(seedColor, other.seedColor, t) ?? seedColor,
      accentColor: Color.lerp(accentColor, other.accentColor, t) ?? accentColor,
      navUnselectedColor:
          Color.lerp(navUnselectedColor, other.navUnselectedColor, t) ?? navUnselectedColor,

      /// 渐变插值
      primaryButtonGradient: LinearGradient.lerp(primaryButtonGradient, other.primaryButtonGradient, t)
          ?? primaryButtonGradient,

      /// 阴影直接切换（不支持插值）
      primaryButtonShadows: t < 0.5 ? primaryButtonShadows : other.primaryButtonShadows,

      /// 高光渐变插值
      primaryButtonHighlightOverlayGradient: LinearGradient.lerp(
            primaryButtonHighlightOverlayGradient,
            other.primaryButtonHighlightOverlayGradient,
            t,
          ) ??
          primaryButtonHighlightOverlayGradient,

      /// 数值插值
      primaryButtonBlurSigma: lerpDouble(primaryButtonBlurSigma, other.primaryButtonBlurSigma, t) ??
          primaryButtonBlurSigma,
    );
  }
}

/// 应用主题工厂类。
///
/// 提供创建应用主题的静态方法。
/// 目前只支持浅色主题。
@immutable
class AppTheme {
  /// 私有构造函数，防止实例化
  const AppTheme._();

  /// 创建浅色主题。
  ///
  /// 返回配置完整的 ThemeData，包含：
  /// - Material 3 设计
  /// - 品牌色彩配置
  /// - 导航栏样式配置
  ///
  /// 返回浅色主题的 ThemeData
  static ThemeData light() {
    /// 获取品牌主题配置
    final brand = AppBrandTheme.light;

    /// 从种子颜色生成 ColorScheme
    final scheme = ColorScheme.fromSeed(seedColor: brand.seedColor);

    return ThemeData(
      /// 启用 Material 3 设计
      useMaterial3: true,

      /// 应用 ColorScheme
      colorScheme: scheme,

      /// 默认字体
      fontFamily: 'sans-serif',

      /// 添加品牌主题扩展
      extensions: const [AppBrandTheme.light],

      /// 导航栏主题配置
      navigationBarTheme: NavigationBarThemeData(
        /// 导航栏高度
        height: 64,

        /// 背景色
        backgroundColor: Colors.white,

        /// 禁用表面着色
        surfaceTintColor: Colors.transparent,

        /// 禁用阴影
        elevation: 0,

        /// 选中图标不要背景色
        indicatorColor: Colors.transparent,

        /// 状态叠加色配置
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          /// 去掉按下/聚焦等状态下的灰色叠层
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.focused) ||
              states.contains(WidgetState.hovered)) {
            return Colors.transparent;
          }
          /// 其它状态用默认
          return null;
        }),

        /// 标签文字样式配置
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

        /// 图标样式配置
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
