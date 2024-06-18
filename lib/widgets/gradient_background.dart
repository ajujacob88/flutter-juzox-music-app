import 'package:flutter/material.dart';
import 'package:juzox_music_app/main.dart';

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
