import 'package:flutter/material.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/screens/tabs_screen.dart';
import 'package:juzox_music_app/widgets/gradient_background.dart';
import 'package:provider/provider.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF004277), //this finalised
);

const kGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color.fromARGB(255, 5, 37, 73), //this

    Color.fromARGB(163, 1, 0, 6), //this
  ],
);
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioPlayerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juzox Music App',
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
          // foregroundColor: Color.fromARGB(255, 121, 157, 174),
        ),
        dividerTheme: DividerThemeData(
          color: Color.fromARGB(172, 64, 195, 255),
        ),
        scaffoldBackgroundColor: kColorScheme.onPrimaryContainer,
        textTheme: ThemeData().textTheme.copyWith(
              bodyLarge: TextStyle(color: kColorScheme.background),
              bodyMedium: TextStyle(color: kColorScheme.background),
              bodySmall: TextStyle(color: kColorScheme.background),
              titleMedium: TextStyle(color: kColorScheme.background),
              titleSmall: TextStyle(color: kColorScheme.background),
              titleLarge: TextStyle(color: kColorScheme.background),
              displayLarge: TextStyle(color: kColorScheme.background),
              displaySmall: TextStyle(color: kColorScheme.background),
              displayMedium: TextStyle(color: kColorScheme.background),
              headlineLarge: TextStyle(color: kColorScheme.background),
              headlineMedium: TextStyle(color: kColorScheme.background),
              headlineSmall: TextStyle(color: kColorScheme.background),
              labelLarge: TextStyle(color: kColorScheme.background),
              labelMedium: TextStyle(color: kColorScheme.background),
              labelSmall: TextStyle(color: kColorScheme.background),
            ),
        listTileTheme: const ListTileThemeData().copyWith(
          titleTextStyle:
              TextStyle(color: kColorScheme.onSecondary, fontSize: 14),
          subtitleTextStyle: const TextStyle(color: Colors.grey),
        ),
      ),

      //Wrap MaterialApp with Container for gradient
      // builder: (context, child) => Container(
      //   decoration: const BoxDecoration(
      //     gradient: kGradient,
      //     // gradient: LinearGradient(
      //     //   begin: Alignment.topCenter,
      //     //   end: Alignment.bottomCenter,
      //     //   colors: [
      //     //     Color.fromARGB(255, 5, 37, 73),
      //     //     Color.fromARGB(255, 6, 73, 28),
      //     //   ],
      //     // ),
      //   ),
      //   child: child, // Pass the MaterialApp widget as child
      // ),

      home: const GradientBackground(
        child: TabsScreen(),
      ),

/*
      //in the other pages outside tabscreen, wrap the pages scafold with GradientBackground or wrap with GradientBackground in navigator.push inorder to achieve gradient... 
//eg:
// In your navigation code (e.g., within TabsScreen)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GradientBackground(
      child: MainPlayer(), // Your MainPlayer widget
    ),
  ),

  OR

   Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
);
*/

      //below is also efficient, giving scafold with transparent background here,, then no need to provide scafold in every pages... this also is good
      //  home: GradientBackground(
      //   child: Scaffold(
      //     backgroundColor: Colors.transparent, // Optional for consistency
      //     body: TabsScreen(), // Or other screens
      //   ),
      // ),
    );
  }
}

/*
//seperated to another file in widgets
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kGradient),
      child: child,
    );
  }
}
*/

/*
//old method using builder method of material app for wrapping the scafold with container and gradient... But creating a seperate clas bradientbackground than using builder function is a better and efficient approach, so i changed the code to above

import 'package:flutter/material.dart';
import 'package:juzox_music_app/providers/audio_player_provider.dart';
import 'package:juzox_music_app/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

var kColorScheme = ColorScheme.fromSeed(
  //seedColor: const Color.fromARGB(255, 104, 58, 183), //this
  // seedColor: Color.fromARGB(71, 112, 207, 4),
  // seedColor: const Color.fromARGB(255, 1, 3, 14), //thisss
  // seedColor: Colors.red,
  seedColor: const Color(0xFF004277), //this finalised
);

// const myGradient = LinearGradient(
//   begin: Alignment.topCenter,
//   end: Alignment.bottomCenter,
//   colors: [
//     Color(0xFF243B55),
//     Color(0xFF141E30),
//   ],
// );

const kGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color.fromARGB(255, 5, 37, 73), //this
    // Color.fromARGB(255, 6, 73, 28),
    // Color.fromARGB(143, 6, 12, 73),
    // Color.fromARGB(143, 18, 2, 28),
    Color.fromARGB(163, 1, 0, 6), //this
  ],
);
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioPlayerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juzox Music App',
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
          // foregroundColor: Color.fromARGB(255, 121, 157, 174),
        ),
        scaffoldBackgroundColor: kColorScheme.onPrimaryContainer,
        textTheme: ThemeData().textTheme.copyWith(
              bodyLarge: TextStyle(color: kColorScheme.background),
              bodyMedium: TextStyle(color: kColorScheme.background),
              bodySmall: TextStyle(color: kColorScheme.background),
              titleMedium: TextStyle(color: kColorScheme.background),
              titleSmall: TextStyle(color: kColorScheme.background),
              titleLarge: TextStyle(color: kColorScheme.background),
              displayLarge: TextStyle(color: kColorScheme.background),
              displaySmall: TextStyle(color: kColorScheme.background),
              displayMedium: TextStyle(color: kColorScheme.background),
              headlineLarge: TextStyle(color: kColorScheme.background),
              headlineMedium: TextStyle(color: kColorScheme.background),
              headlineSmall: TextStyle(color: kColorScheme.background),
              labelLarge: TextStyle(color: kColorScheme.background),
              labelMedium: TextStyle(color: kColorScheme.background),
              labelSmall: TextStyle(color: kColorScheme.background),
            ),
        listTileTheme: const ListTileThemeData().copyWith(
          titleTextStyle:
              TextStyle(color: kColorScheme.onSecondary, fontSize: 14),
          subtitleTextStyle: const TextStyle(color: Colors.grey),
        ),
        // navigationBarTheme: ThemeData().navigationBarTheme.copyWith(
        //       //backgroundColor: kColorScheme.onPrimaryContainer,
        //       labelTextStyle: MaterialStateProperty.all(
        //         const TextStyle(
        //           fontSize: 12,
        //           color: Colors.white70,
        //         ),
        //       ),
        //     ),

        // elevatedButtonTheme:
        //     ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),

        // tabBarTheme: const TabBarTheme().copyWith(
        //   labelColor: Colors.pink[800],
        //   labelStyle: TextStyle(color: Colors.pink[800]),
        //   overlayColor: MaterialStatePropertyAll(Colors.green),
        // ),
      ),
      //Wrap MaterialApp with Container for gradient
      builder: (context, child) => Container(
        decoration: const BoxDecoration(
          gradient: kGradient,
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color.fromARGB(255, 5, 37, 73),
          //     Color.fromARGB(255, 6, 73, 28),
          //   ],
          // ),
        ),
        child: child, // Pass the MaterialApp widget as child
      ),

      home: const TabsScreen(),
      // home: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         Color.fromARGB(255, 104, 58, 183),
      //         Color.fromARGB(255, 10, 160, 28),
      //       ],
      //     ),
      //   ),
      //   child: const HomeScreen(),
      // ),
    );
  }
}
*/
