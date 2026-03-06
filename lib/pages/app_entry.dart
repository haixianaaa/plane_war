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

/// App 入口：先展示登录页，登录成功后进入主应用（底部导航）。
///
/// - 当前先做静态效果：点击登录按钮后“假成功”进入 RootPage
/// - 真实项目中：把 `_fakeSuccess` 替换为 `AuthService` 的真实调用
class AppEntry extends StatefulWidget {
  const AppEntry({super.key, required this.authService});

  final AuthService authService;

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  // 联调示例：先用固定账号密码跑通后端登录（你可以随时改成自己的测试账号）。
  static const _demoUsername = 'admin';
  static const _demoPassword = 'admin123';
  static const _demoType = 'password';

  Future<void> _showError(BuildContext context, Object error) async {
    final t = AppLocalizations.of(context);
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

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    // If token is persisted (secure storage), auto restore login state after app restart.
    if (!auth.authed && AppNetwork.tokenStore.hasToken) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Avoid calling notifyListeners during build.
        auth.signIn();
      });
      return const RootPage();
    }
    if (auth.authed) return const RootPage();

    return LoginPage(
      onAppleSignIn: () async {
        // TODO: 接入真实 API：await widget.authService.signInWithApple();
        await Future<void>.delayed(const Duration(milliseconds: 450));
        auth.signIn();
      },
      onGoogleSignIn: () async {
        // TODO: 接入真实 API：await widget.authService.signInWithGoogle();
        await Future<void>.delayed(const Duration(milliseconds: 450));
        auth.signIn();
      },
      onEmailLogin: () async {
        unawaited(showAppLoading(context));
        try {
          await widget.authService.signInWithPassword(
            username: _demoUsername,
            password: _demoPassword,
            type: _demoType,
          );

          // Probe: trigger one authenticated request so you can see
          // `[auth: Bearer ***xxxxxx (injected)]` in console logs.
          unawaited(() async {
            try {
              // Hit a harmless endpoint just to emit request log with injected auth header.
              await AppNetwork.api.rawGet('/');
            } catch (_) {
              // ignore
            }
          }());

          auth.signIn();
        } catch (e) {
          if (!context.mounted) return;
          await _showError(context, e);
        } finally {
          if (context.mounted) hideAppLoading(context);
        }
      },
      onOpenTerms: () {
        // TODO: 打开服务条款 URL
      },
      onOpenPrivacy: () {
        // TODO: 打开隐私政策 URL
      },
    );
  }
}


