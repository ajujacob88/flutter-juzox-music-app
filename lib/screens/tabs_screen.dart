import 'package:flutter/material.dart';
import 'package:juzox_music_app/screens/library_screen.dart';
import 'package:juzox_music_app/screens/home_screen.dart';
import 'package:juzox_music_app/screens/music_screen.dart';
import 'package:juzox_music_app/widgets/juzox_bottom_navigation_bar.dart';

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
      extendBody: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const Text('My Music'),
      // ),
      bottomNavigationBar: JuzoxBottomNavigationBar(
        onCurrentPageChanged: handleOnCurrentPageChanged,
      ),
      body: [
        const HomeScreen(),
        const MusicScreen(),
        const LibraryScreen(),
      ][currentPageIndex],
    );
  }
}



/*
//here is the code to change it to stateless widget and use valuelistenablebuilder
//but itis actually not required here - here only the tabs index is changing in this whole and if i used value notifier , then also it needs to rebuild it when the index changes,, same is the case with set state.. so here, both of this has same effect
//Also, while using valuenotifier, we need to dispose it to avoid memory leaks, so we need to call dispose method and calling dispose method can be achievable only on stateful widget, so anyway we need stateful widget.... 
//in below code, the notifier is not disposed...
class TabsScreen extends StatelessWidget {
  TabsScreen({super.key});

  final ValueNotifier<int> currentPageIndexNotifier = ValueNotifier<int>(0);

  void handleOnCurrentPageChanged(int newIndex) {
    currentPageIndexNotifier.value = newIndex;
    print('debug check 1 currentpageindex = $newIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: JuzoxBottomNavigationBar(
        onCurrentPageChanged: handleOnCurrentPageChanged,
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: currentPageIndexNotifier,
        builder: (context, currentPageIndex, child) {
          return [
            HomeScreen(),
            MusicScreen(),
            LibraryScreen(),
          ][currentPageIndex];
        },
      ),
    );
  }
}



*/