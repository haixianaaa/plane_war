import 'package:flutter/material.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

class AppPageBackground extends StatelessWidget {
  const AppPageBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: ColoredBox(color: AppColors.pageBackground),
        ),
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                  Color(0x00FFFFFF),
                ],
                stops: [0.0, 0.62, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppColors.bgTopLeft,
                    AppColors.bgTopRight,
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

