import 'package:flutter/material.dart';
import 'package:flutter_application_2/app/auth_controller.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'dart:async' show unawaited;
import 'package:flutter_application_2/pages/login_page.dart';
import 'package:flutter_application_2/pages/root_page.dart';
import 'package:flutter_application_2/services/auth_service.dart';
import 'package:flutter_application_2/widgets/app_dialog.dart';
import 'package:flutter_application_2/network/app_network.dart';
import 'package:flutter_application_2/widgets/app_loading.dart';

/// 应用入口组件。
///
/// 负责根据认证状态决定显示登录页还是主应用页面。
///
/// 功能：
/// - 检查是否有持久化的 Token，自动恢复登录状态
/// - 未登录时显示登录页
/// - 登录成功后进入主应用（底部导航）
///
/// 当前状态：
/// - 邮箱登录已接入真实 API
/// - 苹果/谷歌登录为模拟实现
class AppEntry extends StatefulWidget {
  /// 创建应用入口实例。
  ///
  /// [authService] 认证服务实例，用于处理登录操作
  const AppEntry({super.key, required this.authService});

  /// 认证服务实例
  final AuthService authService;

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  /// 演示用户名（联调示例）
  /// 可随时改成自己的测试账号
  static const _demoUsername = 'admin';

  /// 演示密码（联调示例）
  static const _demoPassword = 'admin123';

  /// 演示登录类型
  static const _demoType = 'password';

  /// 显示错误对话框。
  ///
  /// [context] 构建上下文
  /// [error] 错误对象
  Future<void> _showError(BuildContext context, Object error) async {
    /// 获取本地化字符串
    final t = AppLocalizations.of(context);

    /// 显示错误对话框
    await showAppDialog<void>(
      context: context,
      barrierDismissible: true,
      message: '登录失败：$error',
      actions: [
        AppDialogAction<void>(
          text: t.ok,
          result: null,
          type: AppDialogActionType.primaryGradient,
        ),
      ],
    );
  }

  /// 构建应用入口 UI。
  ///
  /// [context] 构建上下文
  /// 返回登录页或主应用页面
  @override
  Widget build(BuildContext context) {
    /// 获取认证控制器
    final auth = AuthScope.of(context);

    /// 如果 Token 已持久化（安全存储），应用重启后自动恢复登录状态
    if (!auth.authed && AppNetwork.tokenStore.hasToken) {
      /// 使用 post frame callback 避免在 build 期间调用 notifyListeners
      WidgetsBinding.instance.addPostFrameCallback((_) {
        auth.signIn();
      });
      return const RootPage();
    }

    /// 如果已登录，直接显示主页面
    if (auth.authed) return const RootPage();

    /// 未登录时显示登录页
    return LoginPage(
      /// 苹果账号登录回调
      onAppleSignIn: () async {
        /// TODO: 接入真实 API：await widget.authService.signInWithApple();
        await Future<void>.delayed(const Duration(milliseconds: 450));
        auth.signIn();
      },

      /// 谷歌账号登录回调
      onGoogleSignIn: () async {
        /// TODO: 接入真实 API：await widget.authService.signInWithGoogle();
        await Future<void>.delayed(const Duration(milliseconds: 450));
        auth.signIn();
      },

      /// 邮箱登录回调
      onEmailLogin: () async {
        /// 显示加载指示器
        unawaited(showAppLoading(context));

        try {
          /// 调用认证服务进行登录
          await widget.authService.signInWithPassword(
            username: _demoUsername,
            password: _demoPassword,
            type: _demoType,
          );

          /// 探测：触发一个认证请求，以便在控制台日志中看到
          /// `[auth: Bearer ***xxxxxx (injected)]`
          unawaited(() async {
            try {
              /// 访问一个无害的端点，仅用于输出带有注入认证头的请求日志
              await AppNetwork.api.rawGet('/');
            } catch (_) {
              /// 忽略错误
            }
          }());

          /// 更新认证状态
          auth.signIn();
        } catch (e) {
          /// 检查 context 是否仍然挂载
          if (!context.mounted) return;

          /// 显示错误对话框
          await _showError(context, e);
        } finally {
          /// 隐藏加载指示器
          if (context.mounted) hideAppLoading(context);
        }
      },

      /// 打开服务条款回调
      onOpenTerms: () {
        /// TODO: 打开服务条款 URL
      },

      /// 打开隐私政策回调
      onOpenPrivacy: () {
        /// TODO: 打开隐私政策 URL
      },
    );
  }
}
