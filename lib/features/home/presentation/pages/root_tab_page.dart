import 'package:flutter/material.dart';

import 'home_tab_page.dart';
import '../../../posts/presentation/pages/new_post_page.dart';
import 'profile_tab_page.dart';

/// Uygulamanın ana iskeleti: altta 3 sekmeli BottomNavigationBar.
///
/// 1) Ana sayfa (içinde Following / Keşfet tabbar'ı)
/// 2) Yeni post oluşturma
/// 3) Profilim (veya giriş yap)
class RootTabPage extends StatefulWidget {
  const RootTabPage({super.key});

  @override
  State&lt;RootTabPage> createState() =&gt; _RootTabPageState();
}

class _RootTabPageState extends State&lt;RootTabPage> {
  int _currentIndex = 0;

  final _pages = const [
    HomeTabPage(),
    NewPostPage(),
    ProfileTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Yeni post',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profilim',
          ),
        ],
      ),
    );
  }
}