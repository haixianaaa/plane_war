import 'package:flutter/material.dart';
import 'package:flutter_application_2/app/auth_controller.dart';
import 'package:flutter_application_2/pages/login_page.dart';
import 'package:flutter_application_2/pages/root_page.dart';
import 'package:flutter_application_2/services/auth_service.dart';

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
  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
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
        // TODO: 接入真实 API：await widget.authService.signInWithEmail();
        await Future<void>.delayed(const Duration(milliseconds: 450));
        auth.signIn();
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


