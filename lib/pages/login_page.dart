import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_2/app/platform_info.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/widgets/app_dialog.dart';
import 'package:flutter_application_2/widgets/app_button.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

/// 登录操作类型定义。
///
/// 表示一个异步的登录操作，返回 Future<void>
typedef LoginAction = Future<void> Function();

/// 登录页面组件。
///
/// 提供多种登录方式：
/// - 苹果账号登录（iOS 平台）
/// - 谷歌账号登录（Android 平台）
/// - 邮箱登录
///
/// 包含用户协议和隐私政策的勾选确认功能。
class LoginPage extends StatefulWidget {
  /// 创建登录页面实例。
  ///
  /// [onAppleSignIn] 苹果账号登录回调
  /// [onGoogleSignIn] 谷歌账号登录回调
  /// [onEmailLogin] 邮箱登录回调
  /// [onOpenTerms] 打开服务条款回调
  /// [onOpenPrivacy] 打开隐私政策回调
  const LoginPage({
    super.key,
    this.onAppleSignIn,
    this.onGoogleSignIn,
    this.onEmailLogin,
    this.onOpenTerms,
    this.onOpenPrivacy,
  });

  /// 苹果账号登录回调
  final LoginAction? onAppleSignIn;

  /// 谷歌账号登录回调
  final LoginAction? onGoogleSignIn;

  /// 邮箱登录回调
  final LoginAction? onEmailLogin;

  /// 打开服务条款回调
  final VoidCallback? onOpenTerms;

  /// 打开隐私政策回调
  final VoidCallback? onOpenPrivacy;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// 是否同意用户协议
  bool _agreed = true;

  /// 是否正在执行登录操作
  bool _running = false;

  /// 系统 UI 样式配置。
  /// - Android 系统底部导航栏：无法显示渐变，只能给一个更接近底部渐变的纯色
  /// - 状态栏：透明
  static const _systemUiStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFF5EDFF),
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  /// 执行登录操作。
  ///
  /// 检查是否同意协议，然后执行登录回调。
  ///
  /// [action] 登录操作回调
  Future<void> _run(LoginAction? action) async {
    /// 如果正在执行，直接返回
    if (_running) return;

    /// 检查是否同意协议
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

    /// 如果没有提供回调，直接返回
    if (action == null) {
      /// TODO: 在这里接入真实 API（例如调用你的 AuthService）
      return;
    }

    /// 标记正在执行
    _running = true;

    try {
      /// 执行登录操作
      await action();
    } finally {
      /// 重置执行状态
      _running = false;
    }
  }

  /// 构建登录页面 UI。
  ///
  /// [context] 构建上下文
  /// 返回登录页面的 Scaffold
  @override
  Widget build(BuildContext context) {
    /// 获取本地化字符串
    final t = AppLocalizations.of(context);

    /// 判断是否为 iOS 平台
    final isIOS = PlatformInfo.isIOS;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      /// 应用系统 UI 样式
      value: _systemUiStyle,
      child: Scaffold(
        body: Container(
          /// 背景渐变
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                /// 浅蓝色
                Color(0xFFEAF5FF),
                /// 浅紫色
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

                  /// 登录标题
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

                  /// 占位图标
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

                  /// 苹果/谷歌登录按钮
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

                  /// 邮箱登录按钮
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

                  /// 用户协议行
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

/// 用户协议行组件。
///
/// 显示用户协议和隐私政策的勾选确认。
/// 包含可点击的协议链接。
class _AgreementRow extends StatelessWidget {
  /// 创建用户协议行实例。
  ///
  /// [agreed] 是否已同意
  /// [textPrefix] 前缀文本
  /// [termsText] 服务条款文本
  /// [privacyText] 隐私政策文本
  /// [onChanged] 勾选状态变更回调
  /// [onOpenTerms] 打开服务条款回调
  /// [onOpenPrivacy] 打开隐私政策回调
  const _AgreementRow({
    required this.agreed,
    required this.textPrefix,
    required this.termsText,
    required this.privacyText,
    required this.onChanged,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
  });

  /// 是否已同意协议
  final bool agreed;

  /// 前缀文本（如"我已阅读并同意"）
  final String textPrefix;

  /// 服务条款文本
  final String termsText;

  /// 隐私政策文本
  final String privacyText;

  /// 勾选状态变更回调
  final ValueChanged<bool> onChanged;

  /// 打开服务条款回调
  final VoidCallback? onOpenTerms;

  /// 打开隐私政策回调
  final VoidCallback? onOpenPrivacy;

  /// 构建用户协议行 UI。
  ///
  /// [context] 构建上下文
  /// 返回包含勾选框和协议文本的 Row
  @override
  Widget build(BuildContext context) {
    /// 获取品牌主题
    final brand = AppBrandTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// 勾选框
        GestureDetector(
          onTap: () => onChanged(!agreed),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                /// 已同意时显示品牌色，未同意时显示灰色
                color: agreed ? brand.seedColor : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: agreed
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ),

        /// 协议文本
        Expanded(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A)),
              children: [
                /// 前缀文本
                TextSpan(text: textPrefix),

                /// 服务条款链接
                TextSpan(
                  text: termsText,
                  style: TextStyle(fontSize: 10, color: brand.seedColor),
                  recognizer: TapGestureRecognizer()..onTap = onOpenTerms,
                ),

                /// "和"文本
                const TextSpan(text: ' 和 '),

                /// 隐私政策链接
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

/// 占位图标组件。
///
/// 显示一个圆形的占位图标，用于登录页面的装饰。
/// 后续可替换为真实的插画资源。
class _BunnyPlaceholder extends StatelessWidget {
  /// 创建占位图标实例。
  ///
  /// [size] 图标大小
  /// [tint] 图标颜色
  const _BunnyPlaceholder({required this.size, required this.tint});

  /// 图标大小
  final double size;

  /// 图标颜色
  final Color tint;

  /// 构建占位图标 UI。
  ///
  /// [context] 构建上下文
  /// 返回圆形的占位图标
  @override
  Widget build(BuildContext context) {
    /// 先用占位插画（不引入 assets，避免你还没准备素材就运行报错）
    /// TODO: 你提供插画资源后替换为 Image.asset(...)
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        /// 半透明白色背景
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
        /// 使用动物图标作为占位
        child: Icon(Icons.cruelty_free_rounded, size: size * 0.6, color: tint),
      ),
    );
  }
}

/// 谷歌图标 SVG 组件。
///
/// 从 assets 加载谷歌图标 SVG。
class _GoogleIconSvg extends StatelessWidget {
  /// 创建谷歌图标实例
  const _GoogleIconSvg();

  /// 构建 SVG 图标。
  ///
  /// [context] 构建上下文
  /// 返回 SVG 图片组件
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/google.svg',
      width: 24,
      height: 24,
    );
  }
}
