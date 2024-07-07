import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // appBar: AppBar(
        //   title: const Text('Home'),
        // ),
        backgroundColor: Colors.transparent,
        body: Center(child: Text('Home Page')));
  }
}
