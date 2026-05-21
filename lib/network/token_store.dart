import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async' show unawaited;

/// Token 存储类。
///
/// 基于安全存储的 Token 管理器，继承自 ChangeNotifier 支持状态通知。
///
/// 平台安全存储：
/// - Android: Keystore / EncryptedSharedPreferences
/// - iOS: Keychain
///
/// 使用示例：
/// ```dart
/// final store = TokenStore();
/// await store.load();           // 启动时加载
/// store.setToken('xxx');        // 登录时设置
/// store.clear();                // 登出时清除
/// ```
class TokenStore extends ChangeNotifier {
  /// 创建 Token 存储实例。
  ///
  /// [storage] 可选的安全存储实例，默认使用 FlutterSecureStorage
  TokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Token 在安全存储中的键名
  static const String _tokenKey = 'auth_token';

  /// 安全存储实例
  final FlutterSecureStorage _storage;

  /// 当前 Token 值
  String? _token;

  /// 获取当前 Token。
  ///
  /// 返回当前存储的 Token，可能为 null
  String? get token => _token;

  /// 检查是否存在有效 Token。
  ///
  /// 返回 true 表示存在非空的 Token
  bool get hasToken => _token != null && _token!.isNotEmpty;

  /// 从安全存储加载 Token。
  ///
  /// 应在应用启动时调用一次。
  /// 加载完成后会通知监听者状态更新。
  Future<void> load() async {
    /// 从安全存储读取 Token
    final v = (await _storage.read(key: _tokenKey))?.trim();

    /// 规范化 Token（空字符串转为 null）
    final next = (v == null || v.isEmpty) ? null : v;

    /// 如果 Token 未变化，不触发通知
    if (_token == next) return;

    /// 更新 Token
    _token = next;

    /// 通知监听者
    notifyListeners();
  }

  /// 设置 Token。
  ///
  /// 更新内存中的 Token 并同步到安全存储。
  /// 设置为 null 或空字符串会清除 Token。
  ///
  /// [token] 新的 Token 值，null 或空字符串表示清除
  void setToken(String? token) {
    /// 规范化 Token
    final next = (token ?? '').trim();
    _token = next.isEmpty ? null : next;

    /// 通知监听者
    notifyListeners();

    /// 异步写入安全存储
    if (_token == null) {
      /// Token 为空时删除存储
      unawaited(_storage.delete(key: _tokenKey));
    } else {
      /// Token 非空时写入存储
      unawaited(_storage.write(key: _tokenKey, value: _token));
    }
  }

  /// 清除 Token。
  ///
  /// 清除内存中的 Token 并删除安全存储中的记录。
  void clear() {
    /// 清除内存中的 Token
    _token = null;

    /// 通知监听者
    notifyListeners();

    /// 异步删除安全存储中的记录
    unawaited(_storage.delete(key: _tokenKey));
  }
}
