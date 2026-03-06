import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

/// Fullscreen loading overlay (transparent background) with a centered white card
/// and a purple dotted spinner (similar to many iOS apps' custom loaders).
Future<void> showAppLoading(
  BuildContext context, {
  bool useRootNavigator = true,
  bool barrierDismissible = false,
}) {
  return showDialog<void>(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.transparent, // no dim background
    builder: (context) {
      final brand = AppBrandTheme.of(context);
      return Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SizedBox(
              height: 38,
              width: 38,
              child: SpinKitFadingCircle(
                color: brand.seedColor,
                size: 38,
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// Hide the fullscreen loading overlay shown by [showAppLoading].
void hideAppLoading(
  BuildContext context, {
  bool useRootNavigator = true,
}) {
  final nav = Navigator.of(context, rootNavigator: useRootNavigator);
  if (nav.canPop()) nav.pop();
}


