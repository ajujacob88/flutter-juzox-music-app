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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(75),
        topRight: Radius.circular(75),
      ),
      child: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
            widget.onCurrentPageChanged(currentPageIndex);
          });
        },
        // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: const Color.fromARGB(44, 0, 0, 0),
        // indicatorColor: Colors.amber,
        //height: 70,
        elevation: 0,
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
      ),
    );
  }
}



/*
//using material instead of clipRRect, but clipRRect is more efficient

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    return Material(
      color: Color.fromARGB(223, 2, 133, 98),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
      child: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
            widget.onCurrentPageChanged(currentPageIndex);
          });
        },
        // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: Colors.transparent,
        // indicatorColor: Colors.amber,
        //height: 70,
        elevation: 0,
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
      ),
    );
  }
}
*/