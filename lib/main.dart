import 'package:flutter/material.dart';
import 'package:juzox_music_app/screens/tabs_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 104, 58, 183),
  // seedColor: Color.fromARGB(71, 112, 207, 4),
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
  runApp(const MyApp());
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
