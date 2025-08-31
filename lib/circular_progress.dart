import 'dart:async';
import 'dart:ui' show Canvas, Rect;
import 'dart:math';

import 'package:flame/components.dart';
import 'styles.dart';

class CircularProgressBar extends PositionComponent {
  double progress;
  final double radius;
  late final Rect rect;

  CircularProgressBar({
    this.progress = 0.0,
    required this.radius,
    super.priority,
  });

  @override
  FutureOr<void> onLoad() {
    rect = Rect.fromLTWH(-radius, -radius, radius * 2, radius * 2);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final sweepAngle = 2 * pi * progress; // progress 0..1
    canvas.drawArc(rect, -pi / 2, sweepAngle, false, FlameTheme.prodProgress);
  }
}
