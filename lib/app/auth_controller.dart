import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _authed = false;

  bool get authed => _authed;

  void signIn() {
    _authed = true;
    notifyListeners();
  }

  void signOut() {
    _authed = false;
    notifyListeners();
  }
}

class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope not found');
    return scope!.notifier!;
  }
}


