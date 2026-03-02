import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app/platform_info.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';

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
  bool _loading = false;

  Future<void> _run(LoginAction? action) async {
    if (!_agreed || _loading) return;
    if (action == null) {
      // TODO: 在这里接入真实 API（例如调用你的 AuthService）
      return;
    }
    setState(() => _loading = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isIOS = PlatformInfo.isIOS;

    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 26),
                Text(
                  t.loginTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2B2B2B),
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: Center(
                    child: _BunnyPlaceholder(
                      size: 160,
                      tint: const Color(0xFFB38CFF),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _GradientPillButton(
                  leading: isIOS
                      ? const Icon(Icons.apple, color: Colors.white, size: 22)
                      : _GoogleGIcon(),
                  text: isIOS ? t.loginWithApple : t.loginWithGoogle,
                  onTap: _agreed
                      ? () => _run(isIOS ? widget.onAppleSignIn : widget.onGoogleSignIn)
                      : null,
                  loading: _loading,
                ),
                const SizedBox(height: 14),
                _GradientPillButton(
                  leading: const Icon(Icons.mail_outline_rounded,
                      color: Colors.white, size: 22),
                  text: t.loginWithEmail,
                  onTap: _agreed ? () => _run(widget.onEmailLogin) : null,
                  loading: _loading,
                ),
                const SizedBox(height: 18),
                _AgreementRow(
                  agreed: _agreed,
                  textPrefix: t.loginAgreePrefix,
                  termsText: t.loginTerms,
                  privacyText: t.loginPrivacy,
                  onChanged: (v) => setState(() => _agreed = v),
                  onOpenTerms: widget.onOpenTerms,
                  onOpenPrivacy: widget.onOpenPrivacy,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPillButton extends StatelessWidget {
  const _GradientPillButton({
    required this.leading,
    required this.text,
    required this.onTap,
    required this.loading,
  });

  final Widget leading;
  final String text;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null || loading;
    final opacity = disabled ? 0.55 : 1.0;

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          height: 54,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFB78CFF),
                Color(0xFFA86CFF),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A8D5CF6),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    leading,
                    const SizedBox(width: 10),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (loading)
                const Positioned(
                  right: 16,
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
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
    final baseStyle = const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A));
    final linkStyle =
        baseStyle.copyWith(color: const Color(0xFF8D5CF6), height: 1.2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onChanged(!agreed),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: agreed ? const Color(0xFFB78CFF) : const Color(0xFFE9E9E9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: agreed
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: baseStyle,
              children: [
                TextSpan(text: textPrefix),
                TextSpan(
                  text: termsText,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()..onTap = onOpenTerms,
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: privacyText,
                  style: linkStyle,
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
        color: Colors.white.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.cruelty_free_rounded, size: size * 0.55, color: tint),
      ),
    );
  }
}

class _GoogleGIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 避免引入第三方 icon 包；这里先用“G”做占位，后续接入 Google 登录时可换成官方 logo asset/svg
    return Container(
      height: 22,
      width: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'G',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}


