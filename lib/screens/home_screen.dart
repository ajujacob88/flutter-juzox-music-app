import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const Text('My Music'),
      // ),
      body: SafeArea(
        top: false,
        child: Text('Hiiiiiiii'),
      ),
    );
  }
}
