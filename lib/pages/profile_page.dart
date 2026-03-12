import 'package:flutter/material.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/theme/app_theme.dart';
import 'package:flutter_application_2/pages/settings_page.dart';
import 'package:flutter_application_2/icons/remix_icons.dart';
import 'package:flutter_application_2/widgets/app_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final brand = AppBrandTheme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF6EEFF),
              Color(0xFFF8F7FF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
          children: [
            Text(
              t.navMe,
              style: const TextStyle(
                        fontSize: 22,
                fontWeight: FontWeight.w700,
                        color: Color(0xFF2B2B2B),
              ),
            ),
                    const Spacer(),
                    AppSquareIconButton(
                      icon: RemixIcons.settings3Line,
                      iconSize: 24,
                      width: 44,
                      height: 44,
                      backgroundColor: Colors.white.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(999),
                      padding: const EdgeInsets.all(10),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SettingsPage()),
                        );
                      },
                    ),
                  ],
              ),
            ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: Stack(
                          children: [
                            // Soft decorative blobs
                            Positioned(
                              top: 10,
                              left: -40,
                              child: _GlowBlob(
                                size: 180,
                                color: brand.seedColor.withValues(alpha: 0.18),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              right: -60,
                              child: _GlowBlob(
                                size: 220,
                                color: brand.accentColor.withValues(alpha: 0.14),
                              ),
            ),
                            Positioned(
                              bottom: -40,
                              left: 40,
                              child: _GlowBlob(
                                size: 260,
                                color: const Color(0xFFFFFFFF).withValues(alpha: 0.35),
                              ),
            ),

                            // Profile card
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                  height: 86,
                                  padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 24,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      _AvatarPlaceholder(
                                        size: 62,
                                        ringColor: brand.accentColor,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          'ID: 91810537',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF2B2B2B),
                                          ),
              ),
                                      ),
                                      AppSquareIconButton(
                                        icon: RemixIcons.edit2Line,
                                        width: 44,
                                        height: 44,
                                        backgroundColor:
                                            Colors.white.withValues(alpha: 0.78),
                                        borderRadius: BorderRadius.circular(999),
                                        padding: const EdgeInsets.all(10),
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom part placeholder (empty)
                      const SizedBox(height: 26),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 420,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.0),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
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

// _CircleIconButton removed in favor of AppSquareIconButton.

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.size, required this.ringColor});

  final double size;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: ringColor.withValues(alpha: 0.35), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: size * 0.54,
          color: ringColor.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

