import 'package:flutter/material.dart';
import 'package:juzox_music_app/screens/library_screen.dart';
import 'package:juzox_music_app/screens/home_screen.dart';
import 'package:juzox_music_app/screens/search_screen.dart';
import 'package:juzox_music_app/widgets/JuzoxBottomNavigationBar.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TabsScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    void handleOnCurrentPageChanged(int newIndex) {
      setState(() {
        currentPageIndex = newIndex;
      });

      print('debug check 1 currentpageindex = $currentPageIndex');
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const Text('My Music'),
      // ),
      bottomNavigationBar: JuzoxBottomNavigationBar(
        onCurrentPageChanged: handleOnCurrentPageChanged,
      ),
      body: [
        HomeScreen(),
        SearchScreen(),
        LibraryScreen(),
      ][currentPageIndex],
    );
  }
}
