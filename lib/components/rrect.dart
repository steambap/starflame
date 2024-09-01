import 'dart:ui' show Radius, RRect, Canvas;

import 'package:flame/components.dart';

class RRectangle extends RectangleComponent {
  RRectangle({
    Radius radius = const Radius.circular(4),
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.paint,
    super.paintLayers,
    super.key,
  }) : rrect = calcRRect(size ?? Vector2.zero(), radius) {
    size.addListener(
      () => rrect = calcRRect(size, radius),
    );
  }

  RRect rrect;

  static RRect calcRRect(Vector2 size, Radius radius) {
    return RRect.fromRectAndRadius(size.toRect(), radius);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      rrect,
      paint,
    );
  }
}
