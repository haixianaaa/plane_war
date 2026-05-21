import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

/// 应用按钮类型枚举。
///
/// - [outline] (默认): 白色背景，紫色边框
/// - [primary]: 毛玻璃渐变胶囊按钮
enum AppButtonType {
  /// 描边按钮样式
  outline,

  /// 主色渐变按钮样式
  primary,
}

/// 毛玻璃渐变胶囊按钮样式配置。
///
/// 配置按钮的高度、圆角、模糊度、渐变、阴影等视觉属性。
@immutable
class AppFrostedGradientPillButtonStyle {
  /// 创建样式配置实例。
  ///
  /// [height] 按钮高度
  /// [radius] 圆角半径
  /// [blurSigma] 模糊度
  /// [backgroundGradient] 背景渐变
  /// [shadows] 阴影列表
  /// [enableHighlightOverlay] 是否启用高光覆盖层
  /// [highlightOverlayGradient] 高光覆盖层渐变
  const AppFrostedGradientPillButtonStyle({
    this.height = 50,
    this.radius = 30,
    this.blurSigma = 10,
    this.backgroundGradient = const LinearGradient(
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
    this.shadows = const [
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
    this.enableHighlightOverlay = true,
    this.highlightOverlayGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        /// 顶部高光（0.35）
        Color(0x59FFFFFF),
        /// 中间通透
        Color(0x00FFFFFF),
        /// 底部微反光（0.05）
        Color(0x0DFFFFFF),
      ],
      stops: [0.0, 0.4, 1.0],
    ),
  });

  /// 按钮高度
  final double height;

  /// 圆角半径
  final double radius;

  /// 模糊度
  final double blurSigma;

  /// 背景渐变
  final LinearGradient backgroundGradient;

  /// 阴影列表
  final List<BoxShadow> shadows;

  /// 是否启用高光覆盖层
  final bool enableHighlightOverlay;

  /// 高光覆盖层渐变
  final LinearGradient highlightOverlayGradient;
}

/// 统一的应用按钮组件。
///
/// 支持两种样式：
/// - [AppButtonType.outline] (默认): 白色背景，紫色边框
/// - [AppButtonType.primary]: 毛玻璃渐变胶囊按钮
///
/// 支持按下缩放动画效果。
@immutable
class AppButton extends StatelessWidget {
  /// 创建按钮实例。
  ///
  /// [text] 按钮文本
  /// [onTap] 点击回调
  /// [type] 按钮类型
  /// [icon] 前置图标
  /// [iconTextSpacing] 图标与文本间距
  /// [width] 宽度
  /// [height] 高度
  /// [radius] 圆角
  /// [fontSize] 字体大小
  /// [fontWeight] 字体粗细
  /// [textColor] 文本颜色
  /// [enableTapScale] 是否启用点击缩放
  /// [pressedScale] 按下时的缩放比例
  /// [scaleDuration] 缩放动画时长
  /// [scaleCurve] 缩放动画曲线
  /// [primaryStyle] 主色按钮样式配置
  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.type = AppButtonType.outline,
    this.icon,
    this.iconTextSpacing = 8,
    this.width,
    this.height,
    this.radius,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.enableTapScale = true,
    this.pressedScale = 0.95,
    this.scaleDuration = const Duration(milliseconds: 90),
    this.scaleCurve = Curves.easeOutCubic,
    this.primaryStyle,
  });

  /// 按钮类型
  final AppButtonType type;

  /// 按钮文本
  final String text;

  /// 点击回调
  final VoidCallback? onTap;

  /// 前置图标组件
  final Widget? icon;

  /// 图标与文本间距
  final double iconTextSpacing;

  /// 按钮宽度
  final double? width;

  /// 按钮高度
  final double? height;

  /// 圆角半径
  final double? radius;

  /// 字体大小
  final double? fontSize;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 文本颜色
  final Color? textColor;

  /// 是否启用点击缩放动画
  final bool enableTapScale;

  /// 按下时的缩放比例
  final double pressedScale;

  /// 缩放动画时长
  final Duration scaleDuration;

  /// 缩放动画曲线
  final Curve scaleCurve;

  /// 主色按钮样式配置
  final AppFrostedGradientPillButtonStyle? primaryStyle;

  /// 主色按钮默认文本样式
  static const TextStyle _defaultPrimaryTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.1,
  );

  /// 解析文本样式。
  ///
  /// [base] 基础样式
  /// 返回合并后的文本样式
  TextStyle _resolveTextStyle(TextStyle base) {
    return base.copyWith(
      fontSize: fontSize ?? base.fontSize,
      fontWeight: fontWeight ?? base.fontWeight,
      color: textColor ?? base.color,
    );
  }

  /// 构建按钮 UI。
  ///
  /// [context] 构建上下文
  /// 返回按钮组件
  @override
  Widget build(BuildContext context) {
    /// 获取品牌主题
    final brand = AppBrandTheme.of(context);

    /// 解析宽度
    final resolvedWidth = width ?? double.infinity;

    return SizedBox(
      width: resolvedWidth,
      child: switch (type) {
        AppButtonType.primary => _buildPrimary(context, brand),
        AppButtonType.outline => _buildOutline(brand),
      },
    );
  }

  /// 构建主色按钮。
  ///
  /// [context] 构建上下文
  /// [brand] 品牌主题
  /// 返回主色按钮组件
  Widget _buildPrimary(BuildContext context, AppBrandTheme brand) {
    /// 获取基础样式
    final baseStyle = primaryStyle ??
        AppFrostedGradientPillButtonStyle(
          blurSigma: brand.primaryButtonBlurSigma,
          backgroundGradient: brand.primaryButtonGradient,
          shadows: brand.primaryButtonShadows,
          highlightOverlayGradient: brand.primaryButtonHighlightOverlayGradient,
        );

    /// 解析样式，如果提供了高度或圆角则覆盖基础样式
    final resolvedStyle = (height != null || radius != null)
        ? AppFrostedGradientPillButtonStyle(
            height: height ?? baseStyle.height,
            radius: radius ?? baseStyle.radius,
            blurSigma: baseStyle.blurSigma,
            backgroundGradient: baseStyle.backgroundGradient,
            shadows: baseStyle.shadows,
            enableHighlightOverlay: baseStyle.enableHighlightOverlay,
            highlightOverlayGradient: baseStyle.highlightOverlayGradient,
          )
        : baseStyle;

    /// 前置组件
    final leading = icon ?? const SizedBox.shrink();

    /// 图标与文本间距
    final spacing = icon == null ? 0.0 : iconTextSpacing;

    return AppFrostedGradientPillButton(
      leading: leading,
      text: text,
      onTap: onTap,
      style: resolvedStyle,
      enableTapScale: enableTapScale,
      pressedScale: pressedScale,
      scaleDuration: scaleDuration,
      scaleCurve: scaleCurve,
      textStyle: _resolveTextStyle(_defaultPrimaryTextStyle),
      iconTextSpacing: spacing,
    );
  }

  /// 构建描边按钮。
  ///
  /// [brand] 品牌主题
  /// 返回描边按钮组件
  Widget _buildOutline(AppBrandTheme brand) {
    /// 解析高度
    final resolvedHeight = height ?? 50;

    /// 解析圆角
    final resolvedRadius = radius ?? 30;

    /// 强调色
    final accent = brand.accentColor;

    /// 描边按钮基础文本样式
    final outlineBaseTextStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w300,
      color: accent,
    );

    return _OutlinePillButton(
      text: text,
      onTap: onTap,
      icon: icon,
      iconTextSpacing: iconTextSpacing,
      height: resolvedHeight,
      radius: resolvedRadius,
      accentColor: accent,
      textStyle: _resolveTextStyle(outlineBaseTextStyle),
      enableTapScale: enableTapScale,
      pressedScale: pressedScale,
      scaleDuration: scaleDuration,
      scaleCurve: scaleCurve,
    );
  }
}

/// 描边胶囊按钮组件。
///
/// 白色背景，带边框的胶囊形状按钮。
/// 支持点击缩放动画。
class _OutlinePillButton extends StatefulWidget {
  /// 创建描边按钮实例。
  ///
  /// [text] 按钮文本
  /// [onTap] 点击回调
  /// [icon] 前置图标
  /// [iconTextSpacing] 图标与文本间距
  /// [height] 按钮高度
  /// [radius] 圆角半径
  /// [accentColor] 强调色
  /// [textStyle] 文本样式
  /// [enableTapScale] 是否启用点击缩放
  /// [pressedScale] 按下时的缩放比例
  /// [scaleDuration] 缩放动画时长
  /// [scaleCurve] 缩放动画曲线
  const _OutlinePillButton({
    required this.text,
    required this.onTap,
    required this.icon,
    required this.iconTextSpacing,
    required this.height,
    required this.radius,
    required this.accentColor,
    required this.textStyle,
    required this.enableTapScale,
    required this.pressedScale,
    required this.scaleDuration,
    required this.scaleCurve,
  });

  /// 按钮文本
  final String text;

  /// 点击回调
  final VoidCallback? onTap;

  /// 前置图标
  final Widget? icon;

  /// 图标与文本间距
  final double iconTextSpacing;

  /// 按钮高度
  final double height;

  /// 圆角半径
  final double radius;

  /// 强调色（边框颜色）
  final Color accentColor;

  /// 文本样式
  final TextStyle textStyle;

  /// 是否启用点击缩放
  final bool enableTapScale;

  /// 按下时的缩放比例
  final double pressedScale;

  /// 缩放动画时长
  final Duration scaleDuration;

  /// 缩放动画曲线
  final Curve scaleCurve;

  @override
  State<_OutlinePillButton> createState() => _OutlinePillButtonState();
}

class _OutlinePillButtonState extends State<_OutlinePillButton> {
  /// 是否处于按下状态
  bool _pressed = false;

  /// 设置按下状态。
  ///
  /// [v] 是否按下
  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  /// 构建描边按钮 UI。
  ///
  /// [context] 构建上下文
  /// 返回描边按钮组件
  @override
  Widget build(BuildContext context) {
    /// 是否禁用
    final disabled = widget.onTap == null;

    /// 禁用时的透明度
    final opacity = disabled ? 0.55 : 1.0;

    /// 图标与文本间距
    final spacing = widget.icon == null ? 0.0 : widget.iconTextSpacing;

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : widget.onTap,
        onTapDown: disabled || !widget.enableTapScale ? null : (_) => _setPressed(true),
        onTapUp: disabled || !widget.enableTapScale ? null : (_) => _setPressed(false),
        onTapCancel: disabled || !widget.enableTapScale ? null : () => _setPressed(false),
        child: AnimatedScale(
          scale: (!widget.enableTapScale || disabled)
              ? 1.0
              : (_pressed ? widget.pressedScale : 1.0),
          duration: widget.scaleDuration,
          curve: widget.scaleCurve,
          child: Container(
            height: widget.height,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              /// 白色背景
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.radius),
              /// 强调色边框
              border: Border.all(color: widget.accentColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 前置图标
                if (widget.icon != null) widget.icon!,
                if (widget.icon != null) SizedBox(width: spacing),

                /// 按钮文本
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: widget.textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 毛玻璃渐变胶囊按钮组件。
///
/// 带有模糊背景、渐变色、阴影效果的胶囊形状按钮。
/// 支持点击缩放动画。
class AppFrostedGradientPillButton extends StatefulWidget {
  /// 创建毛玻璃渐变按钮实例。
  ///
  /// [leading] 前置组件
  /// [text] 按钮文本
  /// [onTap] 点击回调
  /// [style] 按钮样式配置
  /// [enableTapScale] 是否启用点击缩放
  /// [pressedScale] 按下时的缩放比例
  /// [scaleDuration] 缩放动画时长
  /// [scaleCurve] 缩放动画曲线
  /// [textStyle] 文本样式
  /// [iconTextSpacing] 图标与文本间距
  const AppFrostedGradientPillButton({
    super.key,
    required this.leading,
    required this.text,
    required this.onTap,
    this.style = const AppFrostedGradientPillButtonStyle(),
    this.enableTapScale = true,
    this.pressedScale = 0.95,
    this.scaleDuration = const Duration(milliseconds: 90),
    this.scaleCurve = Curves.easeOutCubic,
    this.textStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      height: 1.1,
    ),
    this.iconTextSpacing = 8,
  });

  /// 前置组件
  final Widget leading;

  /// 按钮文本
  final String text;

  /// 点击回调
  final VoidCallback? onTap;

  /// 按钮样式配置
  final AppFrostedGradientPillButtonStyle style;

  /// 是否启用点击缩放动画
  final bool enableTapScale;

  /// 按下时的缩放比例
  final double pressedScale;

  /// 缩放动画时长
  final Duration scaleDuration;

  /// 缩放动画曲线
  final Curve scaleCurve;

  /// 文本样式
  final TextStyle textStyle;

  /// 图标与文本间距
  final double iconTextSpacing;

  @override
  State<AppFrostedGradientPillButton> createState() =>
      _AppFrostedGradientPillButtonState();
}

/// 方形图标按钮组件。
///
/// 用于页面中的方形图标按钮，支持点击缩放动画。
/// 从聊天列表 UI 中提取的通用组件。
@immutable
class AppSquareIconButton extends StatefulWidget {
  /// 创建方形图标按钮实例。
  ///
  /// [icon] 图标数据
  /// [child] 子组件（与 icon 二选一）
  /// [onTap] 点击回调
  /// [onLongPress] 长按回调
  /// [iconSize] 图标大小
  /// [backgroundColor] 背景颜色
  /// [borderRadius] 圆角
  /// [border] 边框
  /// [padding] 内边距
  /// [iconColor] 图标颜色
  /// [width] 宽度
  /// [height] 高度
  /// [alignment] 对齐方式
  /// [hitTestBehavior] 点击测试行为
  /// [enableTapScale] 是否启用点击缩放
  /// [pressedScale] 按下时的缩放比例
  /// [scaleDuration] 缩放动画时长
  /// [scaleCurve] 缩放动画曲线
  /// [minPressedDuration] 最小按下时长
  const AppSquareIconButton({
    super.key,
    this.icon,
    this.child,
    required this.onTap,
    this.onLongPress,
    this.iconSize = 22,
    this.backgroundColor = const Color(0xB8FFFFFF),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.border,
    this.padding = const EdgeInsets.all(12),
    this.iconColor = const Color(0xFF3A3A3A),
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.enableTapScale = true,
    this.pressedScale = 0.96,
    this.scaleDuration = const Duration(milliseconds: 120),
    this.scaleCurve = Curves.easeOut,
    this.minPressedDuration = const Duration(milliseconds: 80),
  });

  /// 图标数据
  final IconData? icon;

  /// 子组件（与 icon 二选一）
  final Widget? child;

  /// 点击回调
  final VoidCallback onTap;

  /// 长按回调
  final VoidCallback? onLongPress;

  /// 图标大小
  final double iconSize;

  /// 背景颜色
  final Color backgroundColor;

  /// 圆角
  final BorderRadiusGeometry borderRadius;

  /// 边框
  final BoxBorder? border;

  /// 内边距
  final EdgeInsets padding;

  /// 图标颜色
  final Color iconColor;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 对齐方式
  final AlignmentGeometry alignment;

  /// 点击测试行为
  final HitTestBehavior hitTestBehavior;

  /// 是否启用点击缩放
  final bool enableTapScale;

  /// 按下时的缩放比例
  final double pressedScale;

  /// 缩放动画时长
  final Duration scaleDuration;

  /// 缩放动画曲线
  final Curve scaleCurve;

  /// 最小按下时长
  final Duration minPressedDuration;

  @override
  State<AppSquareIconButton> createState() => _AppSquareIconButtonState();
}

class _AppSquareIconButtonState extends State<AppSquareIconButton> {
  /// 是否处于按下状态
  bool _pressed = false;

  /// 按下时间
  DateTime? _pressedAt;

  /// 设置按下状态。
  ///
  /// [v] 是否按下
  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  /// 处理按下开始。
  void _handleTapDown() {
    if (!widget.enableTapScale) return;
    _pressedAt = DateTime.now();
    _setPressed(true);
  }

  /// 处理按下结束。
  void _handleTapEnd() {
    if (!widget.enableTapScale) return;

    /// 获取按下时间
    final pressedAt = _pressedAt;
    _pressedAt = null;

    if (pressedAt == null) {
      _setPressed(false);
      return;
    }

    /// 计算已过去的时间
    final elapsed = DateTime.now().difference(pressedAt);

    /// 计算剩余时间
    final remaining = widget.minPressedDuration - elapsed;

    if (remaining <= Duration.zero) {
      _setPressed(false);
      return;
    }

    /// 延迟后取消按下状态
    Future<void>.delayed(remaining, () {
      if (!mounted) return;
      if (_pressedAt != null) return;
      _setPressed(false);
    });
  }

  /// 构建方形图标按钮 UI。
  ///
  /// [context] 构建上下文
  /// 返回方形图标按钮组件
  @override
  Widget build(BuildContext context) {
    /// 确保提供了 icon 或 child
    assert(widget.icon != null || widget.child != null);

    /// 内容组件
    final content = widget.child ??
        Icon(widget.icon, size: widget.iconSize, color: widget.iconColor);

    /// 装饰后的内容
    final decorated = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        border: widget.border,
      ),
      child: Padding(
        padding: widget.padding,
        child: Align(alignment: widget.alignment, child: content),
      ),
    );

    /// 尺寸包装
    final sized = (widget.width != null || widget.height != null)
        ? SizedBox(width: widget.width, height: widget.height, child: decorated)
        : decorated;

    return GestureDetector(
      behavior: widget.hitTestBehavior,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: widget.enableTapScale ? (_) => _handleTapDown() : null,
      onTapUp: widget.enableTapScale ? (_) => _handleTapEnd() : null,
      onTapCancel: widget.enableTapScale ? _handleTapEnd : null,
      child: AnimatedScale(
        scale: widget.enableTapScale
            ? (_pressed ? widget.pressedScale : 1.0)
            : 1.0,
        duration: widget.scaleDuration,
        curve: widget.scaleCurve,
        child: sized,
      ),
    );
  }
}

class _AppFrostedGradientPillButtonState extends State<AppFrostedGradientPillButton> {
  /// 是否处于按下状态
  bool _pressed = false;

  /// 设置按下状态。
  ///
  /// [v] 是否按下
  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  /// 构建毛玻璃渐变按钮 UI。
  ///
  /// [context] 构建上下文
  /// 返回毛玻璃渐变按钮组件
  @override
  Widget build(BuildContext context) {
    /// 是否禁用
    final disabled = widget.onTap == null;

    /// 禁用时的透明度
    final opacity = disabled ? 0.55 : 1.0;

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : widget.onTap,
        onTapDown: disabled || !widget.enableTapScale ? null : (_) => _setPressed(true),
        onTapUp: disabled || !widget.enableTapScale ? null : (_) => _setPressed(false),
        onTapCancel: disabled || !widget.enableTapScale ? null : () => _setPressed(false),
        child: AnimatedScale(
          scale: (!widget.enableTapScale || disabled)
              ? 1.0
              : (_pressed ? widget.pressedScale : 1.0),
          duration: widget.scaleDuration,
          curve: widget.scaleCurve,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.style.radius),
            child: BackdropFilter(
              /// 模糊滤镜
              filter: ImageFilter.blur(
                sigmaX: widget.style.blurSigma,
                sigmaY: widget.style.blurSigma,
              ),
              child: Container(
                height: widget.style.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.style.radius),
                  /// 背景渐变
                  gradient: widget.style.backgroundGradient,
                  /// 阴影
                  boxShadow: widget.style.shadows,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// 高光覆盖层
                    if (widget.style.enableHighlightOverlay)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.style.radius),
                          gradient: widget.style.highlightOverlayGradient,
                        ),
                      ),

                    /// 内容行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// 前置组件
                        widget.leading,
                        SizedBox(width: widget.iconTextSpacing),

                        /// 按钮文本
                        Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: widget.textStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
