import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_2/app/platform_info.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/widgets/app_dialog.dart';
import 'package:flutter_application_2/widgets/app_button.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

typedef LoginAction = Future<void> Function();

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.onAppleSignIn,
    this.onGoogleSignIn,
    this.onEmailLogin,
    this.onOpenTerms,
    this.onOpenPrivacy,
  });

  /// 预留：接入“苹果账号登录”API
  final LoginAction? onAppleSignIn;

  /// 预留：接入“谷歌登录”API
  final LoginAction? onGoogleSignIn;

  /// 预留：接入“邮箱登录”API
  final LoginAction? onEmailLogin;

  /// 预留：打开服务条款
  final VoidCallback? onOpenTerms;

  /// 预留：打开隐私政策
  final VoidCallback? onOpenPrivacy;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _agreed = true;
  bool _running = false;

  static const _systemUiStyle = SystemUiOverlayStyle(
    // Android 系统底部导航栏：无法显示渐变，只能给一个更接近底部渐变的纯色
    systemNavigationBarColor: Color(0xFFF5EDFF),
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  Future<void> _run(LoginAction? action) async {
    if (_running) return;
    if (!_agreed) {
      await showAppDialog<void>(
        context: context,
        barrierDismissible: true,
        message: AppLocalizations.of(context).loginNeedAgreeMessage,
        actions: [
          AppDialogAction<void>(
            text: AppLocalizations.of(context).ok,
            result: null,
            type: AppDialogActionType.primaryGradient,
          ),
        ],
      );
      return;
    }
    if (action == null) {
      // TODO: 在这里接入真实 API（例如调用你的 AuthService）
      return;
    }
    _running = true;
    try {
      await action();
    } finally {
      _running = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isIOS = PlatformInfo.isIOS;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEAF5FF),
                Color(0xFFF5EDFF),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    t.loginTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF2B2B2B),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -0.38),
                      child: _BunnyPlaceholder(
                        size: 150,
                        tint: const Color(0xFFB38CFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      type: AppButtonType.primary,
                      icon: isIOS
                          ? const Icon(Icons.apple, color: Colors.white, size: 22)
                          : const _GoogleIconSvg(),
                      text: isIOS ? t.loginWithApple : t.loginWithGoogle,
                      onTap: () => _run(
                        isIOS ? widget.onAppleSignIn : widget.onGoogleSignIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      type: AppButtonType.primary,
                      icon: const Icon(Icons.mail, color: Colors.white, size: 24),
                      text: t.loginWithEmail,
                      onTap: () => _run(widget.onEmailLogin),
                    ),
                  ),
                  const Spacer(),
                  _AgreementRow(
                    agreed: _agreed,
                    textPrefix: t.loginAgreePrefix,
                    termsText: t.loginTerms,
                    privacyText: t.loginPrivacy,
                    onChanged: (v) => setState(() => _agreed = v),
                    onOpenTerms: widget.onOpenTerms,
                    onOpenPrivacy: widget.onOpenPrivacy,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.agreed,
    required this.textPrefix,
    required this.termsText,
    required this.privacyText,
    required this.onChanged,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
  });

  final bool agreed;
  final String textPrefix;
  final String termsText;
  final String privacyText;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onOpenTerms;
  final VoidCallback? onOpenPrivacy;

  @override
  Widget build(BuildContext context) {
    final brand = AppBrandTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onChanged(!agreed),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                color: agreed ? brand.seedColor : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: agreed
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A)),
              children: [
                TextSpan(text: textPrefix),
                TextSpan(
                  text: termsText,
                  style: TextStyle(fontSize: 10, color: brand.seedColor),
                  recognizer: TapGestureRecognizer()..onTap = onOpenTerms,
                ),
                const TextSpan(text: ' 和 '),
                TextSpan(
                  text: privacyText,
                  style: TextStyle(fontSize: 10, color: brand.seedColor),
                  recognizer: TapGestureRecognizer()..onTap = onOpenPrivacy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BunnyPlaceholder extends StatelessWidget {
  const _BunnyPlaceholder({required this.size, required this.tint});
  final double size;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    // 先用占位插画（不引入 assets，避免你还没准备素材就运行报错）
    // TODO: 你提供插画资源后替换为 Image.asset(...)
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A9A62F8),
            blurRadius: 30,
            offset: Offset(0, 18),
          )
        ],
      ),
      child: Center(
        child: Icon(Icons.cruelty_free_rounded, size: size * 0.6, color: tint),
      ),
    );
  }
}

class _GoogleIconSvg extends StatelessWidget {
  const _GoogleIconSvg();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/google.svg',
      width: 24,
      height: 24,
      // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }
}


