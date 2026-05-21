import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/app_button.dart';

/// 对话框按钮类型枚举。
enum AppDialogActionType {
  /// 毛玻璃渐变主按钮（用于"取消/确定"等主 CTA，和登录页按钮视觉一致）
  primaryGradient,

  /// 白底紫色描边按钮（截图里的"确认"样式）
  outline,
}

/// 对话框按钮配置。
///
/// 定义对话框中按钮的文本、返回值和样式类型。
@immutable
class AppDialogAction<T> {
  /// 创建对话框按钮配置实例。
  ///
  /// [text] 按钮文本
  /// [result] 点击后返回的结果值
  /// [type] 按钮样式类型
  const AppDialogAction({
    required this.text,
    required this.result,
    this.type = AppDialogActionType.primaryGradient,
  });

  /// 按钮文本
  final String text;

  /// 点击后返回的结果值
  final T result;

  /// 按钮样式类型
  final AppDialogActionType type;
}

/// 应用对话框组件。
///
/// 显示消息和一组操作按钮的模态对话框。
/// 支持多种按钮样式。
class AppDialog<T> extends StatelessWidget {
  /// 创建对话框实例。
  ///
  /// [message] 对话框消息
  /// [actions] 操作按钮列表
  /// [width] 对话框最大宽度
  const AppDialog({
    super.key,
    required this.message,
    required this.actions,
    this.width = 320,
  });

  /// 对话框消息
  final String message;

  /// 操作按钮列表
  final List<AppDialogAction<T>> actions;

  /// 对话框最大宽度
  final double width;

  /// 构建对话框 UI。
  ///
  /// [context] 构建上下文
  /// 返回对话框组件
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            decoration: BoxDecoration(
              /// 白色背景
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 消息文本
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF2B2B2B),
                    height: 2,
                  ),
                ),
                const SizedBox(height: 18),

                /// 操作按钮
                ..._buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建操作按钮列表。
  ///
  /// [context] 构建上下文
  /// 返回按钮组件列表
  List<Widget> _buildActions(BuildContext context) {
    return List<Widget>.generate(actions.length, (index) {
      /// 当前按钮配置
      final action = actions[index];

      /// 是否为最后一个按钮
      final isLast = index == actions.length - 1;

      /// 点击回调：返回按钮对应的结果值
      void onTap() => Navigator.of(context).pop(action.result);

      /// 根据按钮类型创建对应的按钮组件
      final Widget button = switch (action.type) {
        AppDialogActionType.primaryGradient => AppButton(
            type: AppButtonType.primary,
            text: action.text,
            onTap: onTap,
            /// 弹窗按钮比登录按钮更"稳"，按压缩放稍轻一点
            pressedScale: 0.97,
          ),
        AppDialogActionType.outline => AppButton(
            text: action.text,
            onTap: onTap,
          ),
      };

      return Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
        child: SizedBox(height: 50, child: button),
      );
    });
  }
}

/// 显示应用对话框。
///
/// [context] 构建上下文
/// [message] 对话框消息
/// [actions] 操作按钮列表
/// [barrierDismissible] 点击遮罩是否可关闭
/// 返回用户选择的结果值
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String message,
  required List<AppDialogAction<T>> actions,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    /// 半透明黑色遮罩
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (context) => AppDialog<T>(message: message, actions: actions),
  );
}
