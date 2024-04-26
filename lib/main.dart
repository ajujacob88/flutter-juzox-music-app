import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:juzox_music_app/screens/home_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 104, 58, 183),
);

const myGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF243B55),
    Color(0xFF141E30),
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
            ),
      ),
      //Wrap MaterialApp with Container for gradient
      builder: (context, child) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 5, 37, 73),
              Color.fromARGB(255, 6, 73, 28),
            ],
          ),
        ),
        child: child, // Pass the MaterialApp widget as child
      ),

      home: const HomeScreen(),
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
