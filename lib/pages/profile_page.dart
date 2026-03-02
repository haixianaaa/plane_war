import 'package:flutter/material.dart';
import 'package:flutter_application_2/app/locale_controller.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final controller = LocaleScope.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Text(
              t.navMe,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
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
          ],
        ),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: Color(0xFF8D5CF6))
          : null,
      onTap: onTap,
    );
  }
}

