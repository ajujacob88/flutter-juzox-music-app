import 'package:flutter/material.dart';

class StaticMusicIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const StaticMusicIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Container(
          width: 3,
          height: (index + 1) * 4.0 * size,
          //height: (5 - index + 1) * 4.0 * size,
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          color: color,
        );
      }),
    );
  }
}
