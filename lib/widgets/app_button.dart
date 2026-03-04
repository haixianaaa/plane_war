import 'dart:ui';

import 'package:flutter/material.dart';

/// Unified app button variants.
///
/// - [AppButtonType.outline] (default): white background with purple border.
/// - [AppButtonType.primary]: frosted gradient pill button (keeps existing style/behavior).
enum AppButtonType {
  outline,
  primary,
}

@immutable
class AppFrostedGradientPillButtonStyle {
  const AppFrostedGradientPillButtonStyle({
    this.height = 50,
    this.radius = 30,
    this.blurSigma = 10,
    this.backgroundGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xE6DEB2FF), // 左：柔粉紫
        Color(0xE6B794FF), // 中：稍冷静的浅紫
        Color(0xE6DEB2FF), // 右：柔粉紫
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    this.shadows = const [
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
    this.enableHighlightOverlay = true,
    this.highlightOverlayGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x59FFFFFF), // 顶部高光（0.35）
        Color(0x00FFFFFF), // 中间通透
        Color(0x0DFFFFFF), // 底部微反光（0.05）
      ],
      stops: [0.0, 0.4, 1.0],
    ),
  });

  final double height;
  final double radius;
  final double blurSigma;

  final LinearGradient backgroundGradient;
  final List<BoxShadow> shadows;

  final bool enableHighlightOverlay;
  final LinearGradient highlightOverlayGradient;
}

/// A single entry button component for the app.
///
/// - Default `type` is [AppButtonType.outline].
/// - `type: AppButtonType.primary` reuses [AppFrostedGradientPillButton] unchanged.
@immutable
class AppButton extends StatelessWidget {
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

  final AppButtonType type;
  final String text;
  final VoidCallback? onTap;

  /// Optional icon widget shown before [text].
  final Widget? icon;
  final double iconTextSpacing;

  final double? width;
  final double? height;
  final double? radius;

  /// Optional text style overrides.
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;

  /// Tap feedback: scale down a bit while pressed.
  final bool enableTapScale;
  final double pressedScale;
  final Duration scaleDuration;
  final Curve scaleCurve;

  /// Base style for primary gradient button. If [height]/[radius] is provided,
  /// they will override the corresponding fields in this style.
  final AppFrostedGradientPillButtonStyle? primaryStyle;

  static const _defaultOutlineAccent = Color(0xFF9A62F8);

  static const TextStyle _defaultPrimaryTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.1,
  );

  static const TextStyle _defaultOutlineTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: _defaultOutlineAccent,
  );

  TextStyle _resolveTextStyle(TextStyle base) {
    return base.copyWith(
      fontSize: fontSize ?? base.fontSize,
      fontWeight: fontWeight ?? base.fontWeight,
      color: textColor ?? base.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = width ?? double.infinity;

    return SizedBox(
      width: resolvedWidth,
      child: switch (type) {
        AppButtonType.primary => _buildPrimary(),
        AppButtonType.outline => _buildOutline(),
      },
    );
  }

  Widget _buildPrimary() {
    final baseStyle = primaryStyle ?? const AppFrostedGradientPillButtonStyle();
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

    final leading = icon ?? const SizedBox.shrink();
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

  Widget _buildOutline() {
    final resolvedHeight = height ?? 50;
    final resolvedRadius = radius ?? 30;

    return _OutlinePillButton(
      text: text,
      onTap: onTap,
      icon: icon,
      iconTextSpacing: iconTextSpacing,
      height: resolvedHeight,
      radius: resolvedRadius,
      accentColor: _defaultOutlineAccent,
      textStyle: _resolveTextStyle(_defaultOutlineTextStyle),
      enableTapScale: enableTapScale,
      pressedScale: pressedScale,
      scaleDuration: scaleDuration,
      scaleCurve: scaleCurve,
    );
  }
}

class _OutlinePillButton extends StatefulWidget {
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

  final String text;
  final VoidCallback? onTap;

  final Widget? icon;
  final double iconTextSpacing;

  final double height;
  final double radius;
  final Color accentColor;
  final TextStyle textStyle;

  final bool enableTapScale;
  final double pressedScale;
  final Duration scaleDuration;
  final Curve scaleCurve;

  @override
  State<_OutlinePillButton> createState() => _OutlinePillButtonState();
}

class _OutlinePillButtonState extends State<_OutlinePillButton> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onTap == null;
    final opacity = disabled ? 0.55 : 1.0;

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(color: widget.accentColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) widget.icon!,
                if (widget.icon != null) SizedBox(width: spacing),
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

class AppFrostedGradientPillButton extends StatefulWidget {
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

  final Widget leading;
  final String text;
  final VoidCallback? onTap;

  final AppFrostedGradientPillButtonStyle style;

  /// Tap feedback: scale down a bit while pressed.
  final bool enableTapScale;
  final double pressedScale;
  final Duration scaleDuration;
  final Curve scaleCurve;

  final TextStyle textStyle;
  final double iconTextSpacing;

  @override
  State<AppFrostedGradientPillButton> createState() =>
      _AppFrostedGradientPillButtonState();
}

class _AppFrostedGradientPillButtonState extends State<AppFrostedGradientPillButton> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onTap == null;
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
              filter: ImageFilter.blur(
                sigmaX: widget.style.blurSigma,
                sigmaY: widget.style.blurSigma,
              ),
              child: Container(
                height: widget.style.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.style.radius),
                  gradient: widget.style.backgroundGradient,
                  boxShadow: widget.style.shadows,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.style.enableHighlightOverlay)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.style.radius),
                          gradient: widget.style.highlightOverlayGradient,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.leading,
                        SizedBox(width: widget.iconTextSpacing),
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


