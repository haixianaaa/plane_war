import 'dart:ui';

import 'package:flutter/material.dart';

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
      fontSize: 16,
      fontWeight: FontWeight.w500,
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


