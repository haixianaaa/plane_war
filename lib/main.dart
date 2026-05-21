import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/pages/game_page.dart';

/// 应用程序入口函数。
///
/// 在应用启动前完成必要的初始化工作：
/// 1. 确保 Flutter 绑定初始化完成
/// 2. 设置屏幕方向为竖屏
/// 3. 启动 Flutter 应用
Future<void> main() async {
  /// 确保 Flutter 绑定初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  /// 设置屏幕方向为竖屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// 设置系统UI样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  /// 启动 Flutter 应用
  runApp(const PlaneWarApp());
}

/// 飞机大战应用程序根组件。
///
/// 作为整个应用的顶层配置入口，负责：
/// - 配置应用主题
/// - 设置游戏主页面
class PlaneWarApp extends StatelessWidget {
  /// 构造函数，使用 const 确保组件不可变
  const PlaneWarApp({super.key});

  /// 构建应用 UI。
  ///
  /// [context] 构建上下文
  /// 返回配置完成的 MaterialApp 组件
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// 隐藏调试模式横幅
      debugShowCheckedModeBanner: false,

      /// 应用标题
      title: '飞机大战',

      /// 应用主题配置
      theme: ThemeData(
        /// 使用深色主题
        brightness: Brightness.dark,

        /// 主色调
        primarySwatch: Colors.blue,

        /// 背景色
        scaffoldBackgroundColor: const Color(0xFF0A0E27),

        /// 禁用材质3
        useMaterial3: false,
      ),

      /// 主页面设置为游戏页面
      home: const GamePage(),
    );
  }
}
