import 'package:flutter/material.dart';

/// 首页组件。
///
/// 应用的主页面，目前为空白占位页面。
/// 后续可添加首页内容，如推荐、热门等。
class HomePage extends StatelessWidget {
  /// 创建首页实例
  const HomePage({super.key});

  /// 构建首页 UI。
  ///
  /// [context] 构建上下文
  /// 返回空白的白色背景页面
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      /// 白色背景
      color: Colors.white,
      child: SizedBox.expand(),
    );
  }
}
