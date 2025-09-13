import 'dart:math' as math;
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'styles.dart';

class SelectCircle extends PositionComponent {
  static const double triangleSize = 16.0;

  final double radius;
  final List<Path> paths = [];
  late final Offset _centerOffset;
  Paint circleColor = FlameTheme.planetHighlighter1;
  Paint triangleColor = FlameTheme.planetHighlighter2;

  SelectCircle({
    required this.radius,
    super.position,
    super.priority,
    super.anchor,
  }) : super(size: Vector2.all(radius * 2));

  @override
  FutureOr<void> onLoad() {
    final center = size / 2;
    _centerOffset = center.toOffset();
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2); // 0, π/2, π, 3π/2

      // Position on circumference
      final triangleCenter = Vector2(
        center.x + (radius + 4) * math.cos(angle),
        center.y + (radius + 4) * math.sin(angle),
      );

      final path = Path();

      // Triangle vertices relative to triangle center
      final tip = Vector2(
        triangleCenter.x - triangleSize * math.cos(angle),
        triangleCenter.y - triangleSize * math.sin(angle),
      );
      final left = Vector2(
        triangleCenter.x + (triangleSize / 2) * math.cos(angle + math.pi / 2),
        triangleCenter.y + (triangleSize / 2) * math.sin(angle + math.pi / 2),
      );
      final right = Vector2(
        triangleCenter.x + (triangleSize / 2) * math.cos(angle - math.pi / 2),
        triangleCenter.y + (triangleSize / 2) * math.sin(angle - math.pi / 2),
      );

      path.moveTo(tip.x, tip.y);
      path.lineTo(left.x, left.y);
      path.lineTo(right.x, right.y);
      path.close();

      paths.add(path);
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(_centerOffset, radius, circleColor);

    for (final path in paths) {
      canvas.drawPath(path, triangleColor);
    }
  }
}
