import 'package:flutter/material.dart';
import 'package:flutter_application_2/app/auth_controller.dart';
import 'package:flutter_application_2/app/locale_controller.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/theme/app_theme.dart';
import 'package:flutter_application_2/widgets/app_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final controller = LocaleScope.of(context);
    final auth = AuthScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Text(
            t.language,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4F4F4F),
            ),
          ),
          const SizedBox(height: 8),
          _LocaleOption(
            title: t.languageSystem,
            selected: controller.locale == null,
            onTap: controller.setSystem,
          ),
          _LocaleOption(
            title: t.languageEnglish,
            selected: controller.locale?.languageCode == 'en',
            onTap: () => controller.setLocale(const Locale('en')),
          ),
          _LocaleOption(
            title: t.languageChinese,
            selected: controller.locale?.languageCode == 'zh',
            onTap: () => controller.setLocale(const Locale('zh')),
          ),
          _LocaleOption(
            title: t.languageKorean,
            selected: controller.locale?.languageCode == 'ko',
            onTap: () => controller.setLocale(const Locale('ko')),
          ),
          _LocaleOption(
            title: t.languageJapanese,
            selected: controller.locale?.languageCode == 'ja',
            onTap: () => controller.setLocale(const Locale('ja')),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              t.logout,
              style: const TextStyle(color: Color(0xFFD94C4C)),
            ),
            onTap: () async {
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
              if (ok == true) {
                // SettingsPage 是 push 出来的路由；登出后先回到根路由，
                // 让 AppEntry 在根路由处根据 authed 状态切换到登录页。
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
                auth.signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LocaleOption extends StatelessWidget {
  const _LocaleOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = AppBrandTheme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: selected ? Icon(Icons.check_rounded, color: brand.seedColor) : null,
      onTap: onTap,
    );
  }
}


