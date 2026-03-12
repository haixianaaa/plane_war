import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/models/creator_card_data.dart';
import 'package:flutter_application_2/widgets/global_tap_haptics.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

class CreatorCard extends StatefulWidget {
  const CreatorCard({super.key, required this.item});

  final CreatorCardData item;

  @override
  State<CreatorCard> createState() => _CreatorCardState();
}

class _CreatorCardState extends State<CreatorCard> {
  bool _pressed = false;
  DateTime? _pressedAt;
  static const _minPressedDuration = Duration(milliseconds: 80);

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  void _handleTapDown() {
    if (HapticsScope.isEnabled(context)) {
      HapticFeedback.lightImpact();
    }
    _pressedAt = DateTime.now();
    _setPressed(true);
  }

  void _handleTapEnd() {
    final pressedAt = _pressedAt;
    _pressedAt = null;
    if (pressedAt == null) {
      _setPressed(false);
      return;
    }

    final elapsed = DateTime.now().difference(pressedAt);
    final remaining = _minPressedDuration - elapsed;
    if (remaining <= Duration.zero) {
      _setPressed(false);
      return;
    }

    Future<void>.delayed(remaining, () {
      if (!mounted) return;
      if (_pressedAt != null) return; // pressed again
      _setPressed(false);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final brand = AppBrandTheme.of(context);
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _handleTapDown(),
        onTapUp: (_) => _handleTapEnd(),
        onTapCancel: _handleTapEnd,
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: Image.network(
                        widget.item.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.flag, color: brand.accentColor),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.item.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.creatorPrefix(widget.item.author),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFA2A2A2),
                          fontSize: 12,
                        ),
                      ),
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

