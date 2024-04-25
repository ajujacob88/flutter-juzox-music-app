import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:juzox_music_app/screens/home_screen.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 104, 58, 183));
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
            bodySmall: TextStyle(color: kColorScheme.background)),
      ),
      home: const HomeScreen(),
    );
  }
}
