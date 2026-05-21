import 'package:flutter/material.dart';

/// 认证状态控制器。
///
/// 继承自 ChangeNotifier，用于管理用户的登录状态。
/// 通过 [AuthScope] 在组件树中共享，允许子组件访问和响应登录状态变化。
///
/// 使用示例：
/// ```dart
/// final controller = AuthController();
/// controller.signIn();  // 用户登录
/// controller.signOut(); // 用户登出
/// ```
class AuthController extends ChangeNotifier {
  /// 用户是否已认证（已登录）。
  /// true 表示用户已登录，false 表示用户未登录
  bool _authed = false;

  /// 获取当前认证状态。
  ///
  /// 返回 true 表示用户已登录，false 表示未登录
  bool get authed => _authed;

  /// 用户登录操作。
  ///
  /// 将认证状态设置为已登录，并通知所有监听者状态已更新。
  /// 调用后，依赖 [AuthScope] 的组件将自动重建。
  void signIn() {
    /// 设置认证状态为已登录
    _authed = true;

    /// 通知所有监听者状态已更新
    notifyListeners();
  }

  /// 用户登出操作。
  ///
  /// 将认证状态设置为未登录，并通知所有监听者状态已更新。
  /// 调用后，依赖 [AuthScope] 的组件将自动重建。
  void signOut() {
    /// 设置认证状态为未登录
    _authed = false;

    /// 通知所有监听者状态已更新
    notifyListeners();
  }
}

/// 认证状态作用域组件。
///
/// 继承自 InheritedNotifier，用于在组件树中共享 [AuthController]。
/// 子组件可以通过 [of] 方法获取最近的 [AuthController] 实例，
/// 并自动订阅状态变化。
///
/// 使用示例：
/// ```dart
/// AuthScope(
///   controller: myController,
///   child: MyWidget(),
/// )
///
/// // 在子组件中获取控制器
/// final auth = AuthScope.of(context);
/// if (auth.authed) { ... }
/// ```
class AuthScope extends InheritedNotifier<AuthController> {
  /// 创建认证作用域组件。
  ///
  /// [controller] 认证控制器实例，用于管理登录状态
  /// [child] 子组件树
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  /// 获取最近的 [AuthController] 实例。
  ///
  /// 从组件树中查找最近的 [AuthScope]，返回其关联的控制器。
  /// 如果未找到 [AuthScope]，将抛出断言错误。
  ///
  /// [context] 构建上下文，用于向上查找 [AuthScope]
  /// 返回最近的 [AuthController] 实例
  ///
  /// 抛出 AssertionError 如果组件树中不存在 [AuthScope]
  static AuthController of(BuildContext context) {
    /// 查找最近的 AuthScope 实例
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();

    /// 断言确保 AuthScope 存在
    assert(scope != null, 'AuthScope not found');

    /// 返回控制器实例
    return scope!.notifier!;
  }
}
