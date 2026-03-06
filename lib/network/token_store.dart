import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async' show unawaited;

/// Token store backed by secure storage.
///
/// Android: Keystore / EncryptedSharedPreferences (via plugin)
/// iOS: Keychain
class TokenStore extends ChangeNotifier {
  TokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;
  String? _token;

  String? get token => _token;

  bool get hasToken => _token != null && _token!.isNotEmpty;

  /// Load token from secure storage (call once at startup).
  Future<void> load() async {
    final v = (await _storage.read(key: _tokenKey))?.trim();
    final next = (v == null || v.isEmpty) ? null : v;
    if (_token == next) return;
    _token = next;
    notifyListeners();
  }

  void setToken(String? token) {
    final next = (token ?? '').trim();
    _token = next.isEmpty ? null : next;
    notifyListeners();
    if (_token == null) {
      unawaited(_storage.delete(key: _tokenKey));
    } else {
      unawaited(_storage.write(key: _tokenKey, value: _token));
    }
  }

  void clear() {
    _token = null;
    notifyListeners();
    unawaited(_storage.delete(key: _tokenKey));
  }
}


