import 'package:flutter/material.dart';
import 'package:flutter_application_2/app/auth_controller.dart';
import 'package:flutter_application_2/app/locale_controller.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/theme/app_theme.dart';
import 'package:flutter_application_2/widgets/app_dialog.dart';
import 'package:flutter_application_2/network/app_network.dart';

/// 设置页面组件。
///
/// 提供应用设置功能：
/// - 语言切换（跟随系统、英语、中文、韩语、日语）
/// - 登出操作
class SettingsPage extends StatelessWidget {
  /// 创建设置页面实例
  const SettingsPage({super.key});

  /// 构建设置页面 UI。
  ///
  /// [context] 构建上下文
  /// 返回设置页面的 Scaffold
  @override
  Widget build(BuildContext context) {
    /// 获取本地化字符串
    final t = AppLocalizations.of(context);

    /// 获取语言控制器
    final controller = LocaleScope.of(context);

    /// 获取认证控制器
    final auth = AuthScope.of(context);

    return Scaffold(
      /// 应用栏
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),

      /// 设置列表
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          /// 语言设置标题
          Text(
            t.language,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4F4F4F),
            ),
          ),
          const SizedBox(height: 8),

          /// 跟随系统语言选项
          _LocaleOption(
            title: t.languageSystem,
            selected: controller.locale == null,
            onTap: controller.setSystem,
          ),

          /// 英语选项
          _LocaleOption(
            title: t.languageEnglish,
            selected: controller.locale?.languageCode == 'en',
            onTap: () => controller.setLocale(const Locale('en')),
          ),

          /// 中文选项
          _LocaleOption(
            title: t.languageChinese,
            selected: controller.locale?.languageCode == 'zh',
            onTap: () => controller.setLocale(const Locale('zh')),
          ),

          /// 韩语选项
          _LocaleOption(
            title: t.languageKorean,
            selected: controller.locale?.languageCode == 'ko',
            onTap: () => controller.setLocale(const Locale('ko')),
          ),

          /// 日语选项
          _LocaleOption(
            title: t.languageJapanese,
            selected: controller.locale?.languageCode == 'ja',
            onTap: () => controller.setLocale(const Locale('ja')),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          /// 登出按钮
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              t.logout,
              style: const TextStyle(color: Color(0xFFD94C4C)),
            ),
            onTap: () async {
              /// 显示确认对话框
              final ok = await showAppDialog<bool>(
                context: context,
                barrierDismissible: true,
                message: t.logoutConfirmMessage,
                actions: [
                  AppDialogAction<bool>(
                    text: t.cancel,
                    result: false,
                    type: AppDialogActionType.primaryGradient,
                  ),
                  AppDialogAction<bool>(
                    text: t.confirm,
                    result: true,
                    type: AppDialogActionType.outline,
                  ),
                ],
              );

              /// 如果用户确认登出
              if (ok == true) {
                /// SettingsPage 是 push 出来的路由；登出后先回到根路由，
                /// 让 AppEntry 在根路由处根据 authed 状态切换到登录页。
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }

                /// 清除 Token
                AppNetwork.tokenStore.clear();

                /// 更新认证状态
                auth.signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}

/// 语言选项组件。
///
/// 显示单个语言选项，支持选中状态显示。
class _LocaleOption extends StatelessWidget {
  /// 创建语言选项实例。
  ///
  /// [title] 选项标题
  /// [selected] 是否选中
  /// [onTap] 点击回调
  const _LocaleOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  /// 选项标题
  final String title;

  /// 是否选中
  final bool selected;

  /// 点击回调
  final VoidCallback onTap;

  /// 构建语言选项 UI。
  ///
  /// [context] 构建上下文
  /// 返回可点击的语言选项
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: selected
          ? Icon(Icons.check, color: AppBrandTheme.of(context).seedColor)
          : null,
      onTap: onTap,
    );
  }
}
