import 'dart:ui' show Radius;
import 'package:flutter/painting.dart' show BorderRadius;
import 'package:flame/components.dart';

class CutOutRect extends PolygonComponent {
  CutOutRect({
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
    BorderRadius cut = const BorderRadius.only(bottomRight: Radius.circular(8)),
  }) : super(sizeToVertices(size ?? Vector2.zero(), cut, anchor)) {
    size.addListener(
      () => refreshVertices(
        newVertices: sizeToVertices(size, cut, anchor),
        shrinkToBoundsOverride: false,
      ),
    );
  }

  static List<Vector2> sizeToVertices(
    Vector2 size,
    BorderRadius cut,
    Anchor? componentAnchor,
  ) {
    final anchor = componentAnchor ?? Anchor.topLeft;

    if (cut.bottomLeft.x > 0) {
      final split = cut.bottomLeft.x;

      return [
        // top left
        Vector2(-size.x * anchor.x, -size.y * anchor.y),
        // 2 points at bottom left
        Vector2(-size.x * anchor.x, size.y - size.y * anchor.y - split),
        Vector2(-size.x * anchor.x + split, size.y - size.y * anchor.y),
        // bottom right
        Vector2(size.x - size.x * anchor.x, size.y - size.y * anchor.y),
        // top right
        Vector2(size.x - size.x * anchor.x, -size.y * anchor.y),
      ];
    }

    if (cut.topRight.x > 0) {
      final split = cut.topRight.x;

      return [
        // top left
        Vector2(-size.x * anchor.x, -size.y * anchor.y),
        // bottom left
        Vector2(-size.x * anchor.x, size.y - size.y * anchor.y),
        // bottom right
        Vector2(size.x - size.x * anchor.x, size.y - size.y * anchor.y),
        // 2 points at top right
        Vector2(size.x - size.x * anchor.x, -size.y * anchor.y + split),
        Vector2(size.x - size.x * anchor.x - split, -size.y * anchor.y),
      ];
    }

    final split = cut.bottomRight.x;

    return [
      // top left
      Vector2(-size.x * anchor.x, -size.y * anchor.y),
      // bottom left
      Vector2(-size.x * anchor.x, size.y - size.y * anchor.y),
      // 2 points at bottom right
      Vector2(size.x - size.x * anchor.x - split, size.y - size.y * anchor.y),
      Vector2(size.x - size.x * anchor.x, size.y - size.y * anchor.y - split),
      // top right
      Vector2(size.x - size.x * anchor.x, -size.y * anchor.y),
    ];
  }
}
