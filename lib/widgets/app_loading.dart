import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

/// 显示全屏加载遮罩。
///
/// 显示一个透明背景的全屏遮罩，中心有一个白色卡片
/// 和紫色点状旋转加载指示器（类似许多 iOS 应用的自定义加载器）。
///
/// [context] 构建上下文
/// [useRootNavigator] 是否使用根导航器
/// [barrierDismissible] 点击遮罩是否可关闭
/// 返回 Future，当加载遮罩被关闭时完成
Future<void> showAppLoading(
  BuildContext context, {
  bool useRootNavigator = true,
  bool barrierDismissible = false,
}) {
  return showDialog<void>(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    /// 透明背景（无暗色遮罩）
    barrierColor: Colors.transparent,
    builder: (context) {
      /// 获取品牌主题
      final brand = AppBrandTheme.of(context);

      return Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            /// 半透明白色背景
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SizedBox(
              height: 38,
              width: 38,
              child: SpinKitFadingCircle(
                /// 使用品牌色作为加载指示器颜色
                color: brand.seedColor,
                size: 38,
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// 隐藏全屏加载遮罩。
///
/// 关闭由 [showAppLoading] 显示的加载遮罩。
///
/// [context] 构建上下文
/// [useRootNavigator] 是否使用根导航器
void hideAppLoading(
  BuildContext context, {
  bool useRootNavigator = true,
}) {
  /// 获取导航器
  final nav = Navigator.of(context, rootNavigator: useRootNavigator);

  /// 如果可以弹出，则关闭加载遮罩
  if (nav.canPop()) nav.pop();
}
