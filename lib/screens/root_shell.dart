import 'package:flutter/material.dart';
import 'package:al_urjuza/screens/home_screen.dart';
import 'package:al_urjuza/screens/sections_screen.dart';
import 'package:al_urjuza/screens/reader_screen.dart';
import 'package:al_urjuza/screens/favorites_screen.dart';

/// هيكل التنقل الرئيسي: 4 تابات سفلية + قائمة جانبية.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  int _jumpVerse = 0;
  int _jumpToken = 0;

  /// الانتقال إلى تاب الأرجوزة والقفز إلى بيت معين (من «تابع القراءة»).
  void _goToVerse(int verseNumber) {
    setState(() {
      _index = 2;
      _jumpVerse = verseNumber;
      _jumpToken++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            onContinue: _goToVerse,
            onOpenSections: () => setState(() => _index = 1),
          ),
          const SectionsScreen(),
          ReaderScreen(
            jumpVerse: _jumpVerse,
            jumpToken: _jumpToken,
          ),
          const FavoritesScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_outlined),
            selectedIcon: Icon(Icons.collections_bookmark_rounded),
            label: 'الأبواب',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories_rounded),
            label: 'الأرجوزة',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'المفضلة',
          ),
        ],
      ),
    );
  }
}
