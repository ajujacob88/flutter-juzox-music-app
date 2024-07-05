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
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        //padding: EdgeInsets.only(left: 20, right: 20),
        height: 55,
        // height: 60,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 1, 0, 6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80),
            topRight: Radius.circular(80),
          ),
        ),
        child: Container(
          // height: 70,
          decoration: const BoxDecoration(
            // backgroundBlendMode: BlendMode.color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(80),
              topRight: Radius.circular(80),
              // topLeft: Radius.elliptical(100, 80),
              // topRight: Radius.elliptical(100, 80),
            ),

            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(127, 5, 37, 73),
                // Color.fromARGB(129, 64, 195, 255),
                Color.fromARGB(95, 5, 37, 73), //this
                Color.fromARGB(95, 64, 195, 255), //this

                // Color.fromARGB(255, 5, 37, 73),

                // Color.fromARGB(163, 1, 0, 6),

                // Color.fromARGB(255, 5, 37, 73),
                // Color.fromARGB(95, 5, 37, 73),

                // Color.fromARGB(255, 5, 37, 73),
                // Color.fromARGB(161, 3, 11, 43),
                // Color.fromARGB(255, 5, 37, 73),

                // Color.fromARGB(95, 5, 37, 73), //also good
                // Color.fromARGB(255, 5, 37, 73), //also good
              ], // Adjust colors as needed

              //    begin: Alignment.topLeft, //this
              // end: Alignment.bottomRight,  //this

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
                // labelTextStyle: MaterialStateProperty.all(
                //   const TextStyle(
                //     fontSize: 12,
                //     color: Colors.white70,
                //   ),
                // ),

                //set the label text color also changes when icon is sselected.  This allows you to define a function that determines the text style based on the current state of the widget.
                labelTextStyle: MaterialStateProperty.resolveWith(
              (states) => states.contains(MaterialState.selected)
                  ? const TextStyle(
                      fontSize: 12,
                      color: Colors.lightBlueAccent,
                      //height: BorderSide.strokeAlignOutside)
                      height: BorderSide.strokeAlignInside)
                  : const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: BorderSide.strokeAlignInside),
            )

                // labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                //   (Set<MaterialState> states) =>
                //       states.contains(MaterialState.selected)
                //           ? const TextStyle(
                //               fontSize: 12, color: Colors.lightBlueAccent)
                //           : const TextStyle(fontSize: 12, color: Colors.white70),
                // ),
                ),
            child: NavigationBar(
              indicatorColor: Colors.transparent,
              onDestinationSelected: (index) {
                setState(() {
                  currentPageIndex = index;
                  widget.onCurrentPageChanged(currentPageIndex);
                });
              },
              //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              animationDuration: Duration.zero,

              backgroundColor: Colors.transparent,
              // indicatorColor: Colors.amber,
              //height: 70,
              elevation: 0,

              selectedIndex: currentPageIndex,
              destinations: const [
                NavigationDestination(
                  selectedIcon: Padding(
                    padding: EdgeInsets.only(bottom: 9.0),
                    child: Icon(
                      Icons.home,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 9.0),
                    child: Icon(
                      Icons.home_outlined,
                      color: Colors.white70,
                      // size: 20,
                    ),
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Padding(
                    padding: EdgeInsets.only(bottom: 9.0),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 9.0),
                    child: Icon(
                      Icons.music_note_outlined,
                      color: Colors.white70,
                      // size: 20,
                    ),
                  ),
                  label: 'Music',
                ),
                NavigationDestination(
                  selectedIcon: Padding(
                    padding: EdgeInsets.only(bottom: 9.0),
                    child: Icon(
                      Icons.library_music,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 9.0),
                    child: Icon(
                      Icons.my_library_music_outlined,
                      color: Colors.white70,
                      // size: 20,
                    ),
                  ),
                  label: 'Library',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
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
    return Container(
      height: 70,
      color: Colors.black,
      child: Container(
        height: 70,
        // color: Colors.black,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(200), topRight: Radius.circular(200),
              ),
          gradient: LinearGradient(
            colors: [
              // Color.fromARGB(158, 105, 240, 175),

              Color.fromARGB(127, 5, 37, 73),
              Color.fromARGB(129, 64, 195, 255),
            ], // Adjust colors as needed
            begin: Alignment.topLeft,
            end: Alignment.bottomRight, // Adjust gradient direction as needed
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (index) {
            setState(() {
              currentPageIndex = index;
              widget.onCurrentPageChanged(currentPageIndex);
            });
          },
          // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          // backgroundColor: const Color.fromARGB(44, 0, 0, 0),
          //backgroundColor: Color.fromARGB(105, 0, 20, 27),
          //backgroundColor: Color.fromARGB(22, 68, 137, 255),

          //backgroundColor: Color.fromARGB(255, 3, 0, 35),

          backgroundColor: Colors.transparent,
          // indicatorColor: Colors.amber,
          //height: 70,
          elevation: 0,
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.music_note),
              icon: Icon(Icons.music_note_outlined),
              label: 'Music',
            ),
            NavigationDestination(
              // selectedIcon: Icon(Icons.library_music),
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}


*/

/*
//using cliprrect
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
      child: Container(
        color: Color.fromARGB(255, 1, 0, 6),
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(200),
              topRight: Radius.circular(200),
            ),
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(158, 105, 240, 175),

                Color.fromARGB(127, 5, 37, 73),
                Color.fromARGB(129, 64, 195, 255),
              ], // Adjust colors as needed
              begin: Alignment.topLeft,
              end: Alignment.bottomRight, // Adjust gradient direction as needed
            ),
          ),
          child: NavigationBar(
            onDestinationSelected: (index) {
              setState(() {
                currentPageIndex = index;
                widget.onCurrentPageChanged(currentPageIndex);
              });
            },
            // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            // backgroundColor: const Color.fromARGB(44, 0, 0, 0),
            //backgroundColor: Color.fromARGB(105, 0, 20, 27),
            //backgroundColor: Color.fromARGB(22, 68, 137, 255),

            //backgroundColor: Color.fromARGB(255, 3, 0, 35),

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
                selectedIcon: Icon(Icons.music_note),
                icon: Icon(Icons.music_note_outlined),
                label: 'Music',
              ),
              NavigationDestination(
                // selectedIcon: Icon(Icons.library_music),
                icon: Icon(Icons.library_music),
                label: 'Library',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
