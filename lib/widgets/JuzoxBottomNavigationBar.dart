import 'package:flutter/material.dart';
import 'package:juzox_music_app/screens/home_screen.dart';
import 'package:juzox_music_app/screens/search_screen.dart';
import 'package:juzox_music_app/screens/library_screen.dart';

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




/*
class JuzoxBottomNavigationBar extends StatelessWidget {
  const JuzoxBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_music), label: 'Library'),
      ],
      currentIndex: 0, // Set initial selected index (optional)
      onTap: (index) =>
          _handleNavigation(context, index), // Handle tap on navigation items
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    // Implement navigation logic based on the selected index
    // You can use a navigation library like Navigator or custom logic
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const SearchScreen())); // Replace with your search screen widget
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LibraryScreen())); // Replace with your library screen widget
        break;
    }
  }

  // void _handleNavigation(BuildContext context, int index) {
  //   // Update IndexedStack index based on user tap
  //   ScaffoldMessenger.of(context).setState(() {
  //     // Assuming the Scaffold is the parent widget
  //     (Scaffold.of(context)!.body as IndexedStack).index = index;
  //   });
  // }

  // void _handleNavigation(BuildContext context, int index) {
  //   final IndexedStack stack =
  //       Scaffold.of(context)!.body as IndexedStack; // Access IndexedStack
  //   stack.setState(() {
  //     stack.index = index;
  //   });
  // }
 void _handleNavigation(BuildContext context, int index) {
    // Implement navigation logic based on the selected index
    // You can use a navigation library like Navigator or custom logic
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const SearchScreen())); // Replace with your search screen widget
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LibraryScreen())); // Replace with your library screen widget
        break;
    }
  }

}*/