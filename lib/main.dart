import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_2/pages/discover_page.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/profile_page.dart';
import 'package:flutter_application_2/app/locale_controller.dart';
import 'package:flutter_application_2/widgets/global_tap_haptics.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';

const _seedColor = Color(0xFF8D5CF6);
const _navSelectedColor = Color(0xFF8D5CF6); // 更深一点的紫色（选中态）
const _navGrey = Color(0xFF4F4F4F);
const _navIconOffset = Offset(0, 3);
const _navIconSize = 28.0;

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _localeController = LocaleController();

  static const _uiStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: _seedColor);
    return LocaleScope(
      controller: _localeController,
      child: AnimatedBuilder(
        animation: _localeController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Find App',
            locale: _localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              if (child == null) return const SizedBox.shrink();
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: _uiStyle,
                child: GlobalTapHaptics(child: child),
              );
            },
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: scheme,
              fontFamily: 'sans-serif',
              navigationBarTheme: NavigationBarThemeData(
                height: 64,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                indicatorColor: Colors.transparent, // 选中 icon 不要背景色
                overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                  // 去掉按下/聚焦等状态下的灰色叠层（你看到的“闪灰”就是它）
                  if (states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.hovered)) {
                    return Colors.transparent;
                  }
                  return null; // 其它状态用默认
                }),
                labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                  (states) {
                    final selected = states.contains(MaterialState.selected);
                    return TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                      color: selected
                          ? _navSelectedColor
                          : _navGrey, // 灰黑之间（不发白）
                    );
                  },
                ),
                iconTheme: const MaterialStatePropertyAll<IconThemeData>(
                  IconThemeData(color: _navGrey),
                ),
              ),
            ),
            home: const RootPage(),
          );
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    DiscoverPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
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
          NavigationDestination(
            icon: Transform.translate(
              offset: _navIconOffset,
              child: Icon(Icons.grid_view_outlined, size: _navIconSize),
            ),
            selectedIcon: Transform.translate(
              offset: _navIconOffset,
              child: Icon(Icons.grid_view_rounded, size: _navIconSize),
            ),
            label: t.navList,
          ),
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
    );
  }
}

