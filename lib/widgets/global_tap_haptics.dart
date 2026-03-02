import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 用于全局控制“是否允许触觉反馈”的作用域。
/// - 默认开启（没包裹时返回 true）
/// - 你可以在 `MaterialApp.builder` 顶层包裹，统一控制全局以及组件内部的手动震动调用
class HapticsScope extends InheritedWidget {
  const HapticsScope({
    super.key,
    required this.enabled,
    required super.child,
  });

  final bool enabled;

  static bool isEnabled(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<HapticsScope>();
    return scope?.enabled ?? true;
  }

  @override
  bool updateShouldNotify(HapticsScope oldWidget) =>
      enabled != oldWidget.enabled;
}

/// 全局轻触震动：
/// - 通过监听指针 up/down，识别“轻触点击”（非滚动/拖拽）后触发轻微 haptic
/// - 适合放在 `MaterialApp.builder` 顶层包裹
class GlobalTapHaptics extends StatefulWidget {
  const GlobalTapHaptics({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  State<GlobalTapHaptics> createState() => _GlobalTapHapticsState();
}

class _GlobalTapHapticsState extends State<GlobalTapHaptics> {
  final Map<int, _PointerDownInfo> _downs = <int, _PointerDownInfo>{};

  static const double _maxTapMove = 10; // px
  static const Duration _maxTapDuration = Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    final child = HapticsScope(enabled: widget.enabled, child: widget.child);
    if (!widget.enabled) return child;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _downs[event.pointer] = _PointerDownInfo(
          position: event.position,
          time: DateTime.now(),
        );
      },
      onPointerCancel: (event) {
        _downs.remove(event.pointer);
      },
      onPointerUp: (event) {
        final down = _downs.remove(event.pointer);
        if (down == null) return;

        final dt = DateTime.now().difference(down.time);
        final moved = (event.position - down.position).distance;
        if (dt <= _maxTapDuration && moved <= _maxTapMove) {
          HapticFeedback.selectionClick();
        }
      },
      child: child,
    );
  }
}

class _PointerDownInfo {
  const _PointerDownInfo({required this.position, required this.time});

  final Offset position;
  final DateTime time;
}


