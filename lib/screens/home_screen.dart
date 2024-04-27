import 'package:flutter/material.dart';
import 'package:juzox_music_app/screens/library_screen.dart';
import 'package:juzox_music_app/screens/main_home_screen.dart';
import 'package:juzox_music_app/screens/search_screen.dart';
import 'package:juzox_music_app/widgets/JuzoxBottomNavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      // body: SafeArea(
      //   //top: false,
      //   child: Text('Hiiiiiiii'),
      // ),

      body: [
        /// Home page
        // Card(
        //   shadowColor: Color.fromARGB(131, 150, 17, 17),
        //   margin: EdgeInsets.all(8.0),
        //   child: SizedBox.expand(
        //     child: Center(
        //       child: Text(
        //         'Home page $currentPageIndex',
        //       ),
        //     ),
        //   ),
        // ),
        MainHomeScreen(),

        /// Notifications page
        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Column(
        //     children: <Widget>[
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 1'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 2'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SearchScreen(),

        /// Messages page
        LibraryScreen(),
      ][currentPageIndex],
    );
  }
}
