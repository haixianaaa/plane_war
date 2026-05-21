import 'package:flutter/foundation.dart';

/// 应用平台枚举类型。
///
/// 定义应用支持的目标平台类型：
/// - [ios]: iOS 平台（iPhone、iPad）
/// - [android]: Android 平台
/// - [other]: 其他平台（Web、桌面等）
enum AppPlatform {
  /// iOS 平台
  ios,

  /// Android 平台
  android,

  /// 其他平台（Web、桌面等）
  other,
}

/// 平台信息工具类。
///
/// 提供统一的平台判断入口，避免业务代码中散落平台判断逻辑。
/// 不依赖 dart:io，确保在 Web 和桌面平台也能正常工作。
///
/// 使用示例：
/// ```dart
/// if (PlatformInfo.isIOS) {
///   // iOS 特定逻辑
/// }
/// if (PlatformInfo.isMobile) {
///   // 移动端特定逻辑
/// }
/// ```
class PlatformInfo {
  /// 私有构造函数，防止实例化
  const PlatformInfo._();

  /// 获取当前运行平台。
  ///
  /// 根据运行环境自动判断当前平台：
  /// - Web 环境返回 [AppPlatform.other]
  /// - iOS 环境返回 [AppPlatform.ios]
  /// - Android 环境返回 [AppPlatform.android]
  /// - 其他环境返回 [AppPlatform.other]
  static AppPlatform get platform {
    /// 如果是 Web 环境，直接返回 other
    if (kIsWeb) return AppPlatform.other;

    /// 根据目标平台判断
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return AppPlatform.ios;
      case TargetPlatform.android:
        return AppPlatform.android;
      default:
        return AppPlatform.other;
    }
  }

  /// 判断是否为 iOS 平台。
  ///
  /// 返回 true 表示当前运行在 iOS 设备上
  static bool get isIOS => platform == AppPlatform.ios;

  /// 判断是否为 Android 平台。
  ///
  /// 返回 true 表示当前运行在 Android 设备上
  static bool get isAndroid => platform == AppPlatform.android;

  /// 判断是否为移动平台（iOS 或 Android）。
  ///
  /// 返回 true 表示当前运行在移动设备上（iOS 或 Android）
  static bool get isMobile => isIOS || isAndroid;
}
