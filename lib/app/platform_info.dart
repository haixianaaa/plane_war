import 'package:flutter/foundation.dart';

/// 统一的平台判断入口：
/// - 避免业务代码里到处散落 `Platform.isIOS` / `defaultTargetPlatform` 判断
/// - 不依赖 `dart:io`，未来即使扩展到 Web/桌面也不会因为 import 报错
enum AppPlatform {
  ios,
  android,
  other,
}

class PlatformInfo {
  const PlatformInfo._();

  static AppPlatform get platform {
    if (kIsWeb) return AppPlatform.other;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return AppPlatform.ios;
      case TargetPlatform.android:
        return AppPlatform.android;
      default:
        return AppPlatform.other;
    }
  }

  static bool get isIOS => platform == AppPlatform.ios;
  static bool get isAndroid => platform == AppPlatform.android;
  static bool get isMobile => isIOS || isAndroid;
}


