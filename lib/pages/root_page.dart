import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';
import 'package:flutter_application_2/pages/discover_page.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/profile_page.dart';

const _navIconOffset = Offset(0, 3);
const _navIconSize = 28.0;

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

  static const _systemUiStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle,
      child: Scaffold(
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
                child: Icon(Icons.search, size: _navIconSize),
              ),
              selectedIcon: Transform.translate(
                offset: _navIconOffset,
                child: Icon(Icons.search_rounded, size: _navIconSize),
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
      ),
    );
  }
}


