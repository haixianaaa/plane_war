import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/pages/chat_page.dart';
import 'package:flutter_application_2/pages/discover_page.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/profile_page.dart';

/// 导航栏图标偏移量。
/// 用于微调图标在导航栏中的垂直位置
const _navIconOffset = Offset(0, 3);

/// 导航栏图标大小
const _navIconSize = 28.0;

/// 根页面组件。
///
/// 应用的主容器页面，包含底部导航栏和多个子页面。
/// 使用 IndexedStack 保持子页面状态，切换页面时不会重新构建。
///
/// 子页面包括：
/// - 首页 (HomePage)
/// - 聊天 (ChatPage)
/// - 发现 (DiscoverPage)
/// - 我的 (ProfilePage)
class RootPage extends StatefulWidget {
  /// 创建根页面实例
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  /// 当前选中的导航索引
  /// 0: 首页, 1: 聊天, 2: 发现, 3: 我的
  int _currentIndex = 0;

  /// 子页面列表。
  /// 使用 const 确保页面不会被重复创建
  final List<Widget> _pages = const [
    HomePage(),
    ChatPage(),
    DiscoverPage(),
    ProfilePage(),
  ];

  /// 系统 UI 样式配置。
  /// - 导航栏背景色：白色
  /// - 导航栏图标亮度：深色
  /// - 状态栏：透明
  static const _systemUiStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  /// 构建根页面 UI。
  ///
  /// [context] 构建上下文
  /// 返回包含底部导航栏的 Scaffold
  @override
  Widget build(BuildContext context) {
    /// 获取本地化字符串
    final t = AppLocalizations.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      /// 应用系统 UI 样式
      value: _systemUiStyle,
      child: Scaffold(
        /// 使用 IndexedStack 保持子页面状态
        body: IndexedStack(index: _currentIndex, children: _pages),

        /// 底部导航栏
        bottomNavigationBar: NavigationBar(
          /// 当前选中索引
          selectedIndex: _currentIndex,

          /// 导航项选中回调
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },

          /// 导航项列表
          destinations: [
            /// 首页导航项
            NavigationDestination(
              icon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.home_outlined, size: _navIconSize),
              ),
              selectedIcon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.home, size: _navIconSize),
              ),
              label: t.navHome,
            ),

            /// 聊天导航项
            NavigationDestination(
              icon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.chat_bubble_outline_rounded, size: _navIconSize),
              ),
              selectedIcon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.chat_bubble_rounded, size: _navIconSize),
              ),
              label: t.navChat,
            ),

            /// 发现导航项
            NavigationDestination(
              icon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.search, size: _navIconSize),
              ),
              selectedIcon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.search_rounded, size: _navIconSize),
              ),
              label: t.navList,
            ),

            /// 我的导航项
            NavigationDestination(
              icon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.person_outline, size: _navIconSize),
              ),
              selectedIcon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.person, size: _navIconSize),
              ),
              label: t.navMe,
            ),
          ],
        ),
      ),
    );
  }
}
