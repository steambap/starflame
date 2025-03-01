import 'package:flutter/material.dart';

import 'package:starflame/styles.dart';

class ProgressBar extends StatelessWidget {
  static const height = 8.0;

  final List<int> segments;

  const ProgressBar({
    super.key,
    required this.segments,
  }) : assert(segments.length == 3, 'Segments must be 3.');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(segments.length, (index) {
        return Expanded(
          flex: segments[index], // Converts proportion to flex.
          child: Container(
            height: height,
            color: AppTheme.progressBarColors[index],
          ),
        );
      }),
    );
  }
}
