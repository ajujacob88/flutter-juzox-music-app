import 'package:flutter/material.dart';

class JuzoxBottomNavigationBar extends StatefulWidget {
  const JuzoxBottomNavigationBar(
      {super.key, required this.onCurrentPageChanged});

  final Function(int) onCurrentPageChanged;
  @override
  State<JuzoxBottomNavigationBar> createState() =>
      _JuzoxBottomNavigationBarState();
}

class _JuzoxBottomNavigationBarState extends State<JuzoxBottomNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (index) {
        setState(() {
          currentPageIndex = index;
          widget.onCurrentPageChanged(currentPageIndex);
        });
      },
      indicatorColor: Colors.amber,
      selectedIndex: currentPageIndex,
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          // selectedIcon: Icon(Icons.search),
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
        NavigationDestination(
          // selectedIcon: Icon(Icons.library_music),
          icon: Icon(Icons.library_music),
          label: 'Library',
        ),
      ],
    );
  }
}
