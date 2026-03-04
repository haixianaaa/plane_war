import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/app_button.dart';

enum AppDialogActionType {
  /// 毛玻璃渐变主按钮（用于“取消/确定”等主 CTA，和登录页按钮视觉一致）
  primaryGradient,

  /// 白底紫色描边按钮（截图里的“确认”样式）
  outline,
}

@immutable
class AppDialogAction<T> {
  const AppDialogAction({
    required this.text,
    required this.result,
    this.type = AppDialogActionType.primaryGradient,
  });

  final String text;
  final T result;
  final AppDialogActionType type;
}

class AppDialog<T> extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.message,
    required this.actions,
    this.width = 320,
  });

  final String message;
  final List<AppDialogAction<T>> actions;
  final double width;

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                ..._buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return List<Widget>.generate(actions.length, (index) {
      final action = actions[index];
      final isLast = index == actions.length - 1;
      void onTap() => Navigator.of(context).pop(action.result);

      final Widget button = switch (action.type) {
        AppDialogActionType.primaryGradient => AppButton(
            type: AppButtonType.primary,
            text: action.text,
            onTap: onTap,
            // 弹窗按钮比登录按钮更“稳”，按压缩放稍轻一点
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

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String message,
  required List<AppDialogAction<T>> actions,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (context) => AppDialog<T>(message: message, actions: actions),
  );
}


