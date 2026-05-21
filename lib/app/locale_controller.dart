import 'package:flutter/material.dart';

/// 语言设置控制器。
///
/// 继承自 ChangeNotifier，用于管理应用的语言设置。
/// 通过 [LocaleScope] 在组件树中共享，允许子组件访问和响应语言变化。
///
/// 支持的语言操作：
/// - [setSystem]: 跟随系统语言设置
/// - [setLocale]: 设置指定的语言
///
/// 使用示例：
/// ```dart
/// final controller = LocaleController();
/// controller.setSystem();              // 跟随系统
/// controller.setLocale(Locale('zh'));  // 设置为中文
/// ```
class LocaleController extends ChangeNotifier {
  /// 当前语言设置。
  /// null 表示跟随系统语言，非 null 表示使用指定的语言
  Locale? _locale;

  /// 获取当前语言设置。
  ///
  /// 返回当前语言，null 表示跟随系统语言
  Locale? get locale => _locale;

  /// 设置为跟随系统语言。
  ///
  /// 将语言设置重置为 null，表示使用系统默认语言。
  /// 调用后会通知所有监听者状态已更新。
  void setSystem() {
    /// 设置语言为 null，表示跟随系统
    _locale = null;

    /// 通知所有监听者状态已更新
    notifyListeners();
  }

  /// 设置指定的语言。
  ///
  /// 将应用语言设置为指定的 Locale。
  /// 调用后会通知所有监听者状态已更新。
  ///
  /// [locale] 要设置的语言，例如 Locale('zh') 表示中文
  void setLocale(Locale locale) {
    /// 设置指定的语言
    _locale = locale;

    /// 通知所有监听者状态已更新
    notifyListeners();
  }
}

/// 语言设置作用域组件。
///
/// 继承自 InheritedNotifier，用于在组件树中共享 [LocaleController]。
/// 子组件可以通过 [of] 方法获取最近的 [LocaleController] 实例，
/// 并自动订阅语言变化。
///
/// 使用示例：
/// ```dart
/// LocaleScope(
///   controller: myController,
///   child: MyWidget(),
/// )
///
/// // 在子组件中获取控制器
/// final localeCtrl = LocaleScope.of(context);
/// localeCtrl.setLocale(Locale('en'));
/// ```
class LocaleScope extends InheritedNotifier<LocaleController> {
  /// 创建语言作用域组件。
  ///
  /// [controller] 语言控制器实例，用于管理语言设置
  /// [child] 子组件树
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  /// 获取最近的 [LocaleController] 实例。
  ///
  /// 从组件树中查找最近的 [LocaleScope]，返回其关联的控制器。
  /// 如果未找到 [LocaleScope]，将抛出断言错误。
  ///
  /// [context] 构建上下文，用于向上查找 [LocaleScope]
  /// 返回最近的 [LocaleController] 实例
  ///
  /// 抛出 AssertionError 如果组件树中不存在 [LocaleScope]
  static LocaleController of(BuildContext context) {
    /// 查找最近的 LocaleScope 实例
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();

    /// 断言确保 LocaleScope 存在
    assert(scope != null, 'LocaleScope not found');

    /// 返回控制器实例
    return scope!.notifier!;
  }
}
